if SERVER then
    AddCSLuaFile()
    --resource.AddWorkshop("2682267311")
end

if CLIENT then
    SWEP.PrintName = "Demonic Scarlet Rose"
    SWEP.Slot = 0
    SWEP.Weight = 5
    SWEP.Icon = "vgui/ttt/icon_scarlet_rose"
    SWEP.ViewModelFOV = 85
    killicon.Add("tfa_cso_scarlet_rose", "vgui/killicons/tfa_cso_scarlet_rose", Color(255, 255, 255, 255))
end

SWEP.HoldType = "melee2"
SWEP.UseHands = true
SWEP.Base = "weapon_tttbase"
SWEP.ViewModel = "models/weapons/tfa_cso/c_scarlet_rose.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_scarlet_rose.mdl"
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
SWEP.ReloadCooldown = 10 -- R cooldown
SWEP.NextReloadAvailable = 0 -- Next time it can be reloaded
SWEP.Offset = {
    Pos = {
        Up = -16,
        Right = 4,
        Forward = 3,
    },
    Ang = {
        Up = -0,
        Right = 0,
        Forward = 80
    },
    Scale = 1
}

local sound_single = Sound("Weapon_Crowbar.Single")
local sound_open = Sound("DoorHandles.Unlocked3")
sound.Add({
    ['name'] = "ScarletRose.Draw",
    ['channel'] = CHAN_WEAPON,
    ['sound'] = {"weapons/ttt/scarlet_rose/draw.wav"},
    ['pitch'] = {100, 100}
})

sound.Add({
    ['name'] = "ScarletRose.Slash",
    ['channel'] = CHAN_WEAPON,
    ['sound'] = {"weapons/ttt/scarlet_rose/slash.wav"},
    ['pitch'] = {100, 100}
})

sound.Add({
    ['name'] = "ScarletRose.Stab1",
    ['channel'] = CHAN_WEAPON,
    ['sound'] = {"weapons/ttt/scarlet_rose/stab1.wav"},
    ['pitch'] = {100, 100}
})

sound.Add({
    ['name'] = "ScarletRose.Stab2",
    ['channel'] = CHAN_WEAPON,
    ['sound'] = {"weapons/ttt/scarlet_rose/stab2.wav"},
    ['pitch'] = {100, 100}
})

sound.Add({
    ['name'] = "ScarletRose.Stab3",
    ['channel'] = CHAN_WEAPON,
    ['sound'] = {"weapons/ttt/scarlet_rose/stab3.wav"},
    ['pitch'] = {100, 100}
})

sound.Add({
    ['name'] = "ScarletRose.Stab_Exp",
    ['channel'] = CHAN_STATIC,
    ['sound'] = {"weapons/ttt/scarlet_rose/stab_exp.wav"},
    ['pitch'] = {100, 100}
})

sound.Add({
    ['name'] = "ScarletRose.Hit1",
    ['channel'] = CHAN_WEAPON,
    ['sound'] = {"weapons/ttt/scarlet_rose/hit1.wav"},
    ['pitch'] = {100, 100}
})

sound.Add({
    ['name'] = "ScarletRose.Hit2",
    ['channel'] = CHAN_WEAPON,
    ['sound'] = {"weapons/ttt/scarlet_rose/hit2.wav"},
    ['pitch'] = {100, 100}
})

sound.Add({
    ['name'] = "ScarletRose.Hit3",
    ['channel'] = CHAN_WEAPON,
    ['sound'] = {"weapons/ttt/scarlet_rose/hit3.wav"},
    ['pitch'] = {100, 100}
})

sound.Add({
    ['name'] = "ScarletRose.Wall1",
    ['channel'] = CHAN_WEAPON,
    ['sound'] = {"weapons/ttt/scarlet_rose/wall1.wav"},
    ['pitch'] = {100, 100}
})

sound.Add({
    ['name'] = "ScarletRose.Wall2",
    ['channel'] = CHAN_WEAPON,
    ['sound'] = {"weapons/ttt/scarlet_rose/wall2.wav"},
    ['pitch'] = {100, 100}
})

if SERVER then
    CreateConVar("ttt_crowbar_unlocks", "1", FCVAR_ARCHIVE)
    CreateConVar("ttt_crowbar_pushforce", "395", FCVAR_NOTIFY)
end

if CLIENT then
    surface.CreateFont("YaHeiKey", {
        font = "Microsoft YaHei",
        size = 24,
        weight = 500,
        antialias = true,
    })

    surface.CreateFont("YaHeiCooldown", {
        font = "Microsoft YaHei",
        size = 18,
        weight = 500,
        antialias = true,
    })

    hook.Add("HUDPaint", "DrawCooldownBar", function()
        local ply = LocalPlayer()
        local wep = ply:GetActiveWeapon()
        if not IsValid(wep) or not wep.NextReloadAvailable or not wep.ReloadCooldown then return end
        local w, h = ScrW(), ScrH()
        local width = 87
        local height = 50
        local x = w * 0.9
        local y = h * 0.9 - height
        local cooldownRatio = 0
        local bgColor = Color(255, 255, 255, 150)
        if CurTime() < wep.NextReloadAvailable then
            cooldownRatio = 1 - ((wep.NextReloadAvailable - CurTime()) / wep.ReloadCooldown)
        else
            bgColor = Color(255, 0, 0, 150)
        end

        local fillHeight = height * cooldownRatio
        surface.SetDrawColor(bgColor)
        surface.DrawRect(x, y, width, height)
        surface.SetDrawColor(255, 0, 0, 150)
        surface.DrawRect(x, y + height - fillHeight, width, fillHeight)
        local fontKey = "YaHeiKey"
        local textKey = "R"
        local textColor = Color(255, 255, 255, 255)
        surface.SetFont(fontKey)
        local textWidthKey, textHeightKey = surface.GetTextSize(textKey)
        draw.SimpleText(textKey, fontKey, x + width / 2 - textWidthKey / 2, y + height / 4 - textHeightKey / 2, textColor, TEXT_ALIGN_LEFT)
        if CurTime() < wep.NextReloadAvailable then
            local cooldown = math.ceil(wep.NextReloadAvailable - CurTime())
            local textCooldown = "cooling time:" .. tostring(cooldown)
            local fontCooldown = "YaHeiCooldown"
            surface.SetFont(fontCooldown)
            local textWidthCooldown, textHeightCooldown = surface.GetTextSize(textCooldown)
            draw.SimpleText(textCooldown, fontCooldown, x + width / 2 - textWidthCooldown / 2, y + 3 * height / 4 - textHeightCooldown / 2, textColor, TEXT_ALIGN_LEFT)
        end
    end)
end

function SWEP:Reload()
    if CurTime() < self.NextReloadAvailable then return end
    self:SetNextPrimaryFire(CurTime() + 2)
    self:SetNextSecondaryFire(CurTime() + 2)
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    timer.Simple(0.6, function()
        if self:IsValid() then
            util.BlastDamage(self.Owner, self.Owner, self.Owner:GetPos(), 225, 0) --damage
            for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
                if IsValid(v) then
                    if v == self then continue end
                    if v == self.Owner then continue end
                    if v:GetMoveType() ~= MOVETYPE_NOCLIP and (v:IsNPC() or v:IsNextBot() or v:IsPlayer()) then
                        local dif = v:GetPos() - self:GetPos()
                        local forceApplied = dif * 2
                        v:SetVelocity(forceApplied + Vector(0, 0, 100))
                    end
                end
            end

            local effectdata = EffectData()
            effectdata:SetOrigin(self.Owner:GetPos())
            util.Effect("exp_dua_scar", effectdata) -- easy effect
        end
    end)

    self.NextReloadAvailable = CurTime() + self.ReloadCooldown
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
                if openable == OPEN_ROT then hitEnt:Fire("OpenAwayFrom", self:GetOwner(), 0) end
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
    if not IsValid(self:GetOwner()) then return end
    if self:GetOwner().LagCompensation then -- for some reason not always true
        self:GetOwner():LagCompensation(true)
    end

    local spos = self:GetOwner():GetShootPos()
    local sdest = spos + (self:GetOwner():GetAimVector() * 100)
    local rand = math.random(1, 2)
    local tr_main = util.TraceLine({
        start = spos,
        endpos = sdest,
        filter = self:GetOwner(),
        mask = MASK_SHOT_HULL
    })

    local hitEnt = tr_main.Entity
    local owner = self:GetOwner()
    if CLIENT and owner:ShouldDrawLocalPlayer() then self.Weapon:EmitSound(sound_single) end
    owner:SetAnimation(PLAYER_ATTACK1)
    -- Randomly choose an animation
    if rand == 1 then
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    else
        self.Weapon:SendWeaponAnim(ACT_VM_HITLEFT)
    end

    if IsValid(hitEnt) or tr_main.HitWorld then
        if not (CLIENT and (not IsFirstTimePredicted())) then
            local edata = EffectData()
            edata:SetStart(spos)
            edata:SetOrigin(tr_main.HitPos)
            edata:SetNormal(tr_main.Normal)
            edata:SetSurfaceProp(tr_main.SurfaceProps)
            edata:SetHitBox(tr_main.HitBox)
            edata:SetEntity(hitEnt)
            if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
                util.Effect("BloodImpact", edata)
                local sounds = {"ScarletRose.Hit1", "ScarletRose.Hit2", "ScarletRose.Hit3"}
                local randomSound = sounds[math.random(#sounds)]
                self:GetOwner():EmitSound(randomSound)
                self:GetOwner():LagCompensation(false)
                self:GetOwner():FireBullets({
                    Num = 1,
                    Src = spos,
                    Dir = self:GetOwner():GetAimVector(),
                    Spread = Vector(0, 0, 0),
                    Tracer = 0,
                    Force = 1,
                    Damage = 0
                })
            else
                util.Effect("Impact", edata)
                local wallSounds = {"ScarletRose.Wall1", "ScarletRose.Wall2"}
                local randomWallSound = wallSounds[math.random(#wallSounds)]
                self:GetOwner():EmitSound(randomWallSound)
            end
        end
    else
        if rand == 1 then
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        else
            self.Weapon:SendWeaponAnim(ACT_VM_HITLEFT)
        end
    end

    if SERVER then
        local tr_all = nil
        tr_all = util.TraceLine({
            start = spos,
            endpos = sdest,
            filter = self:GetOwner()
        })

        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
        if hitEnt and hitEnt:IsValid() then
            if self:OpenEnt(hitEnt) == OPEN_NO and tr_all.Entity and tr_all.Entity:IsValid() then self:OpenEnt(tr_all.Entity) end
            local dmg = DamageInfo()
            dmg:SetDamage(self.Primary.Damage)
            dmg:SetAttacker(self:GetOwner())
            dmg:SetInflictor(self.Weapon)
            dmg:SetDamageForce(self:GetOwner():GetAimVector() * 1500)
            dmg:SetDamagePosition(self:GetOwner():GetPos())
            dmg:SetDamageType(DMG_CLUB)
            hitEnt:DispatchTraceAttack(dmg, spos + (self:GetOwner():GetAimVector() * 3), sdest)
        else
            if tr_all.Entity and tr_all.Entity:IsValid() then self:OpenEnt(tr_all.Entity) end
        end
    end

    if self:GetOwner().LagCompensation then self:GetOwner():LagCompensation(false) end
end

function SWEP:SecondaryAttack()
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
    if self:GetOwner().LagCompensation then self:GetOwner():LagCompensation(true) end
    local tr = self:GetOwner():GetEyeTrace(MASK_SHOT)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPlayer() and (self:GetOwner():EyePos() - tr.HitPos):Length() < 100 then
        local ply = tr.Entity
        if SERVER and (not ply:IsFrozen()) then
            local pushvel = tr.Normal * GetConVar("ttt_crowbar_pushforce"):GetFloat()
            pushvel.z = math.Clamp(pushvel.z, 50, 100)
            ply:SetVelocity(ply:GetVelocity() + pushvel)
            self:GetOwner():SetAnimation(PLAYER_ATTACK1)
            ply.was_pushed = {
                att = self:GetOwner(),
                t = CurTime(),
                wep = self:GetClass()
            }
        end

        if CLIENT and owner:ShouldDrawLocalPlayer() then self.Weapon:EmitSound(sound_single) end
        self.Weapon:SendWeaponAnim(ACT_VM_MISSLEFT)
        owner:SetAnimation(PLAYER_ATTACK1)
        self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
    end

    if self:GetOwner().LagCompensation then self:GetOwner():LagCompensation(false) end
end

function SWEP:GetClass()
    return "weapon_ttt_scarlet_rose"
end

function SWEP:OnDrop()
    self:Remove()
end

SWEP.InspectionActions = {ACT_VM_RECOIL1}
DEFINE_BASECLASS(SWEP.Base)
if CLIENT then
    SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_scarlet_rose")
    SWEP.DrawWeaponSelection = ttt_DrawWeaponSelection
end

function SWEP:DrawWorldModel()
    local hand, offset, rotate
    local pl = self:GetOwner()
    if IsValid(pl) then
        local boneIndex = pl:LookupBone("ValveBiped.Bip01_R_Hand")
        if boneIndex then
            local pos, ang = pl:GetBonePosition(boneIndex)
            pos, ang = self:ApplyOffset(pos, ang)
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

function SWEP:ApplyOffset(pos, ang)
    pos = pos + ang:Forward() * self.Offset.Pos.Forward + ang:Right() * self.Offset.Pos.Right + ang:Up() * self.Offset.Pos.Up
    ang:RotateAroundAxis(ang:Up(), self.Offset.Ang.Up)
    ang:RotateAroundAxis(ang:Right(), self.Offset.Ang.Right)
    ang:RotateAroundAxis(ang:Forward(), self.Offset.Ang.Forward)
    return pos, ang
end
