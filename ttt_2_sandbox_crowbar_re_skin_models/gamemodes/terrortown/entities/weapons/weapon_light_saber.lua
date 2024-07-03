if SERVER then AddCSLuaFile() end
if CLIENT then
    SWEP.PrintName = "Light Saber"
    SWEP.Slot = 0
    SWEP.Icon = "vgui/ttt/icon_lightsaber"
    SWEP.ViewModelFOV = 54
end

SWEP.HoldType = "melee"
SWEP.UseHands = true
SWEP.Category = "sbzl's Weapons"
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/v_crewbar.mdl"
SWEP.WorldModel = "models/weapons/w_ttt_lightsaber_jedi.mdl"
SWEP.Weight = 5
SWEP.DrawCrosshair = false
SWEP.ViewModelFlip = false
SWEP.Primary.Damage = 20
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.5
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 5
SWEP.Kind = WEAPON_MELEE
SWEP.WeaponID = AMMO_CROWBAR
SWEP.InLoadoutFor = {nil}
SWEP.NoSights = true
SWEP.IsSilent = true
SWEP.AutoSpawnable = false
SWEP.AllowDelete = false -- never removed for weapon reduction
SWEP.AllowDrop = false
SWEP.Offset = {
    Pos = {
        Up = -22,
        Right = 1,
        Forward = 6,
    },
    Ang = {
        Up = -20,
        Right = 190,
        Forward = -5
    },
    Scale = 1
}

local sound_single = Sound("Weapon_Crowbar.Single")
local sound_open = Sound("DoorHandles.Unlocked3")
if SERVER then
    CreateConVar("ttt_crowbar_unlocks", "1", FCVAR_ARCHIVE)
    CreateConVar("ttt_crowbar_pushforce", "395", FCVAR_NOTIFY)
end

-- only open things that have a name (and are therefore likely to be meant to
-- open) and are the right class. Opening behaviour also differs per class, so
-- return one of the OPEN_ values
local function OpenableEnt(ent)
    local cls = ent:GetClass()
    if ent:GetName() == "" then
        return OPEN_NO
    elseif cls == "prop_door_rotating" then
        return OPEN_ROT
    elseif cls == "func_door" or cls == "func_door_rotating" then
        return OPEN_DOOR
    elseif cls == "func_button" then
        return OPEN_BUT
    elseif cls == "func_movelinear" then
        return OPEN_NOTOGGLE
    else
        return OPEN_NO
    end
end

local function CrowbarCanUnlock(t)
    return not GAMEMODE.crowbar_unlocks or GAMEMODE.crowbar_unlocks[t]
end

-- will open door AND return what it did
function SWEP:OpenEnt(hitEnt)
    -- Get ready for some prototype-quality code, all ye who read this
    if SERVER and GetConVar("ttt_crowbar_unlocks"):GetBool() then
        local openable = OpenableEnt(hitEnt)
        if openable == OPEN_DOOR or openable == OPEN_ROT then
            local unlock = CrowbarCanUnlock(openable)
            if unlock then hitEnt:Fire("Unlock", nil, 0) end
            if unlock or hitEnt:HasSpawnFlags(256) then
                if openable == OPEN_ROT then hitEnt:Fire("OpenAwayFrom", self.Owner, 0) end
                hitEnt:Fire("Toggle", nil, 0)
            else
                return OPEN_NO
            end
        elseif openable == OPEN_BUT then
            if CrowbarCanUnlock(openable) then
                hitEnt:Fire("Unlock", nil, 0)
                hitEnt:Fire("Press", nil, 0)
            else
                return OPEN_NO
            end
        elseif openable == OPEN_NOTOGGLE then
            if CrowbarCanUnlock(openable) then
                hitEnt:Fire("Open", nil, 0)
            else
                return OPEN_NO
            end
        end
        return openable
    else
        return OPEN_NO
    end
end

function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    if not IsValid(self.Owner) then return end
    if self.Owner.LagCompensation then -- for some reason not always true
        self.Owner:LagCompensation(true)
    end
    local owner = self:GetOwner()
    local spos = self.Owner:GetShootPos()
    local sdest = spos + (self.Owner:GetAimVector() * 70)
    local tr_main = util.TraceLine({
        start = spos,
        endpos = sdest,
        filter = self.Owner,
        mask = MASK_SHOT_HULL
    })

    local hitEnt = tr_main.Entity
    self.Weapon:EmitSound("weapons/ls/lightsaber_swing.wav")
    owner:SetAnimation(PLAYER_ATTACK1)
    if IsValid(hitEnt) or tr_main.HitWorld then
        self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
        if not (CLIENT and (not IsFirstTimePredicted())) then
            local edata = EffectData()
            edata:SetStart(spos)
            edata:SetOrigin(tr_main.HitPos)
            edata:SetNormal(tr_main.Normal)
            edata:SetSurfaceProp(tr_main.SurfaceProps)
            edata:SetHitBox(tr_main.HitBox)
            --edata:SetDamageType(DMG_CLUB)
            edata:SetEntity(hitEnt)
            if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
                util.Effect("BloodImpact", edata)
                -- does not work on players rah
                --util.Decal("Blood", tr_main.HitPos + tr_main.HitNormal, tr_main.HitPos - tr_main.HitNormal)
                -- do a bullet just to make blood decals work sanely
                -- need to disable lagcomp because firebullets does its own
                self.Owner:LagCompensation(false)
                self.Owner:FireBullets({
                    Num = 1,
                    Src = spos,
                    Dir = self.Owner:GetAimVector(),
                    Spread = Vector(0, 0, 0),
                    Tracer = 0,
                    Force = 1,
                    Damage = 0
                })
            else
                util.Effect("Impact", edata)
            end
        end
    else
        self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
    end

    if SERVER then
        -- Do another trace that sees nodraw stuff like func_button
        local tr_all = nil
        tr_all = util.TraceLine({
            start = spos,
            endpos = sdest,
            filter = self.Owner
        })

        self.Owner:SetAnimation(PLAYER_ATTACK1)
        if hitEnt and hitEnt:IsValid() then
            if self:OpenEnt(hitEnt) == OPEN_NO and tr_all.Entity and tr_all.Entity:IsValid() then
                -- See if there's a nodraw thing we should open
                self:OpenEnt(tr_all.Entity)
            end

            local dmg = DamageInfo()
            dmg:SetDamage(self.Primary.Damage)
            dmg:SetAttacker(self.Owner)
            dmg:SetInflictor(self.Weapon)
            dmg:SetDamageForce(self.Owner:GetAimVector() * 1500)
            dmg:SetDamagePosition(self.Owner:GetPos())
            dmg:SetDamageType(DMG_CLUB)
            hitEnt:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)
            --         self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
            --         self.Owner:TraceHullAttack(spos, sdest, Vector(-16,-16,-16), Vector(16,16,16), 30, DMG_CLUB, 11, true)
            --         self.Owner:FireBullets({Num=1, Src=spos, Dir=self.Owner:GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=20})
        else
            --         if tr_main.HitWorld then
            --            self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
            --         else
            --            self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
            --         end
            -- See if our nodraw trace got the goods
            if tr_all.Entity and tr_all.Entity:IsValid() then self:OpenEnt(tr_all.Entity) end
        end
    end

    if self.Owner.LagCompensation then self.Owner:LagCompensation(false) end
end

function SWEP:SecondaryAttack()
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self.Weapon:SetNextSecondaryFire(CurTime() + 0.1)
    if self.Owner.LagCompensation then self.Owner:LagCompensation(true) end
    local tr = self.Owner:GetEyeTrace(MASK_SHOT)
    local owner = self:GetOwner()
    if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPlayer() and (self.Owner:EyePos() - tr.HitPos):Length() < 100 then
        local ply = tr.Entity
        if SERVER and (not ply:IsFrozen()) then
            local pushvel = tr.Normal * GetConVar("ttt_crowbar_pushforce"):GetFloat()
            -- limit the upward force to prevent launching
            pushvel.z = math.Clamp(pushvel.z, 50, 100)
            ply:SetVelocity(ply:GetVelocity() + pushvel)
            self.Owner:SetAnimation(PLAYER_ATTACK1)
            ply.was_pushed = {
                att = self.Owner, --, infl=self}
                t = CurTime()
            }
        end

        self.Weapon:EmitSound(sound_single)
        self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
        owner:SetAnimation(PLAYER_ATTACK1)
        self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
    end

    if self.Owner.LagCompensation then self.Owner:LagCompensation(false) end
end

function SWEP:GetClass()
    return "weapon_light_saber"
end

function SWEP:OnDrop()
    self:Remove()
end

local gm = engine.ActiveGamemode()
if string.find(gm, "terrortown") then
    SWEP.Base = "weapon_tttbase"
    DEFINE_BASECLASS("weapon_tttbase")
end

local gm = engine.ActiveGamemode()
if string.find(gm, "sandbox") then
    SWEP.Base = "weapon_base"
    DEFINE_BASECLASS("weapon_base")
end

if SERVER then return end
killicon.Add("weapon_light_saber", "vgui/ttt/icon_lightsaber", color_white)
function SWEP:DrawWorldModel()
    local hand, offset, rotate
    if not IsValid(self.Owner) then
        self:DrawModel()
        return
    end

    if not self.Hand then self.Hand = self.Owner:LookupAttachment("anim_attachment_rh") end
    hand = self.Owner:GetAttachment(self.Hand)
    if not hand then
        self:DrawModel()
        return
    end

    offset = hand.Ang:Right() * self.Offset.Pos.Right + hand.Ang:Forward() * self.Offset.Pos.Forward + hand.Ang:Up() * self.Offset.Pos.Up
    hand.Ang:RotateAroundAxis(hand.Ang:Right(), self.Offset.Ang.Right)
    hand.Ang:RotateAroundAxis(hand.Ang:Forward(), self.Offset.Ang.Forward)
    hand.Ang:RotateAroundAxis(hand.Ang:Up(), self.Offset.Ang.Up)
    self:SetRenderOrigin(hand.Pos + offset)
    self:SetRenderAngles(hand.Ang)
    self:DrawModel()
end

function SWEP:DrawWorldModel()
    local hand, offset, rotate
    local pl = self:GetOwner()
    if IsValid(pl) then
        local boneIndex = pl:LookupBone("ValveBiped.Bip01_R_Hand")
        if boneIndex then
            local pos, ang = pl:GetBonePosition(boneIndex)
            pos = pos + ang:Forward() * self.Offset.Pos.Forward + ang:Right() * self.Offset.Pos.Right + ang:Up() * self.Offset.Pos.Up
            ang:RotateAroundAxis(ang:Up(), self.Offset.Ang.Up)
            ang:RotateAroundAxis(ang:Right(), self.Offset.Ang.Right)
            ang:RotateAroundAxis(ang:Forward(), self.Offset.Ang.Forward)
            self:SetRenderOrigin(pos)
            self:SetRenderAngles(ang)
            self:DrawModel()
        end
    else
        self:SetRenderOrigin(nil)
        self:SetRenderAngles(nil)
        self:DrawModel()
    end
end
