if SERVER then
	AddCSLuaFile()
	--resource.AddWorkshop("2797965347")
end

if CLIENT then
	SWEP.PrintName    = "Blaze Nova"

	SWEP.Slot         = 0
	SWEP.Weight       = 5

	SWEP.Icon         = "vgui/ttt/icon_blazenova"

	SWEP.ViewModelFOV = 85

	killicon.Add("tfa_cso_blazenova", "vgui/killicons/tfa_cso_blazenova", Color(255, 255, 255, 255))
end

SWEP.HoldType              = "melee2"

SWEP.UseHands              = true

SWEP.Base                  = "weapon_tttbase"

SWEP.ViewModel             = "models/weapons/tfa_cso/c_blazenova.mdl"
SWEP.WorldModel            = "models/weapons/tfa_cso/w_blazenova.mdl"

SWEP.DrawCrosshair         = false
SWEP.ViewModelFlip         = false

SWEP.Primary.Damage        = 20
SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Automatic     = true
SWEP.Primary.Delay         = 0.5
SWEP.Primary.Ammo          = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = true
SWEP.Secondary.Ammo        = "none"
SWEP.Secondary.Delay       = 5

SWEP.Kind                  = WEAPON_MELEE

SWEP.InLoadoutFor          = { nil } --{ ROLE_TRAITOR,ROLE_DETECTIVE,ROLE_INNOCENT }
SWEP.NoSights              = true
SWEP.IsSilent              = true

SWEP.InspectPos            = Vector(0, 0, 0) --Replace with a vector, in style of ironsights position, to be used for inspection
SWEP.InspectAng            = Vector(0, 0, 0) --Replace with a vector, in style of ironsights angle, to be used for inspection

SWEP.InspectionLoop        = true            --Setting false will cancel inspection once the animation is done.  CS:GO style.
SWEP.AllowDelete           = false           -- never removed for weapon reduction
SWEP.AllowDrop             = false

SWEP.WElements             = {
	["blazenova_a"] = { type = "Model", model = "models/weapons/tfa_cso/w_blazenova.mdl", bone =
	"ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(6, -1.0, 8.50), angle = Angle(-10, 45, 0), size = Vector(1, 1, 1), color =
		Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

sound.Add({
	['name'] = "Dreadnova.Charge_Start",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/ttt/dreadnova/charge_start.wav" },
	['pitch'] = { 100, 100 }
})

sound.Add({
	['name'] = "Dreadnova.Charge_Release",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/ttt/dreadnova/charge_release.wav" },
	['pitch'] = { 100, 100 }
})

sound.Add({
	['name'] = "Dreadnova.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/ttt/dreadnova/draw.wav" },
	['pitch'] = { 100, 100 }
})

sound.Add({
	['name'] = "Dreadnova.SlashEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/ttt/dreadnova/slash_end.wav" },
	['pitch'] = { 100, 100 }
})

sound.Add({
	['name'] = "Dreadnova.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/ttt/dreadnova/slash1.wav" },
	['pitch'] = { 100, 100 }
})

sound.Add({
	['name'] = "Dreadnova.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/ttt/dreadnova/slash2.wav" },
	['pitch'] = { 100, 100 }
})

sound.Add({
	['name'] = "Dreadnova.Slash3",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/ttt/dreadnova/slash3.wav" },
	['pitch'] = { 100, 100 }
})

sound.Add({
	['name'] = "Dreadnova.Slash4",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/ttt/dreadnova/slash4.wav" },
	['pitch'] = { 100, 100 }
})

sound.Add({
	['name'] = "Dreadnova.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/ttt/dreadnova/stab.wav" },
	['pitch'] = { 100, 100 }
})

sound.Add({
	['name'] = "Dreadnova.HitFleshSlash",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/ttt/dreadnova/hit.wav" },
	['pitch'] = { 100, 100 }
})

sound.Add({
	['name'] = "Dreadnova.HitFleshStab",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/ttt/dreadnova/stab_hit.wav" },
	['pitch'] = { 100, 100 }
})

sound.Add({
	['name'] = "Dreadnova.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/ttt/dreadnova/wall.wav" },
	['pitch'] = { 100, 100 }
})

SWEP.Offset = {
	Pos = {
		Up = -10,
		Right = 4.2,
		Forward = 2.5,
	},
	Ang = {
		Up = 75,
		Right = 175,
		Forward = 0
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
			if unlock then
				hitEnt:Fire("Unlock", nil, 0)
			end

			if unlock or hitEnt:HasSpawnFlags(256) then
				if openable == OPEN_ROT then
					hitEnt:Fire("OpenAwayFrom", self:GetOwner(), 0)
				end
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

	local tr_main = util.TraceLine({ start = spos, endpos = sdest, filter = self:GetOwner(), mask = MASK_SHOT_HULL })
	local hitEnt = tr_main.Entity

	--self.Weapon:EmitSound(sound_single)

	if IsValid(hitEnt) or tr_main.HitWorld then
		if math.random() < 0.5 then
			self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK)
		else
			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		end
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
			end
		end
	else
		if math.random() < 0.5 then
			self.Weapon:SendWeaponAnim(ACT_VM_HITLEFT)
		else
			self.Weapon:SendWeaponAnim(ACT_VM_HITRIGHT)
		end
	end


	if CLIENT then
		-- used to be some shit here
	else -- SERVER
		-- Do another trace that sees nodraw stuff like func_button
		local tr_all = nil
		tr_all = util.TraceLine({ start = spos, endpos = sdest, filter = self:GetOwner() })

		self:GetOwner():SetAnimation(PLAYER_ATTACK1)

		if hitEnt and hitEnt:IsValid() then
			if self:OpenEnt(hitEnt) == OPEN_NO and tr_all.Entity and tr_all.Entity:IsValid() then
				-- See if there's a nodraw thing we should open
				self:OpenEnt(tr_all.Entity)
			end

			local dmg = DamageInfo()
			dmg:SetDamage(self.Primary.Damage)
			dmg:SetAttacker(self:GetOwner())
			dmg:SetInflictor(self.Weapon)
			dmg:SetDamageForce(self:GetOwner():GetAimVector() * 1500)
			dmg:SetDamagePosition(self:GetOwner():GetPos())
			dmg:SetDamageType(DMG_CLUB)

			hitEnt:DispatchTraceAttack(dmg, spos + (self:GetOwner():GetAimVector() * 3), sdest)

			--         self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

			--         self:GetOwner():TraceHullAttack(spos, sdest, Vector(-16,-16,-16), Vector(16,16,16), 30, DMG_CLUB, 11, true)
			--         self:GetOwner():FireBullets({Num=1, Src=spos, Dir=self:GetOwner():GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=20})
		else
			--         if tr_main.HitWorld then
			--            self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
			--         else
			--            self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
			--         end

			-- See if our nodraw trace got the goods
			if tr_all.Entity and tr_all.Entity:IsValid() then
				self:OpenEnt(tr_all.Entity)
			end
		end
	end

	if self:GetOwner().LagCompensation then
		self:GetOwner():LagCompensation(false)
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)

	if self:GetOwner().LagCompensation then
		self:GetOwner():LagCompensation(true)
	end

	local tr = self:GetOwner():GetEyeTrace(MASK_SHOT)

	if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPlayer() and (self:GetOwner():EyePos() - tr.HitPos):Length() < 100 then
		local ply = tr.Entity

		if SERVER and (not ply:IsFrozen()) then
			local pushvel = tr.Normal * GetConVar("ttt_crowbar_pushforce"):GetFloat()

			-- limit the upward force to prevent launching
			pushvel.z = math.Clamp(pushvel.z, 50, 100)

			ply:SetVelocity(ply:GetVelocity() + pushvel)
			self:GetOwner():SetAnimation(PLAYER_ATTACK1)

			ply.was_pushed = { att = self:GetOwner(), t = CurTime(), wep = self:GetClass() } --, infl=self}
		end

		--self.Weapon:EmitSound(sound_single)
		self.Weapon:SendWeaponAnim(ACT_VM_MISSLEFT)

		self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	end

	if self:GetOwner().LagCompensation then
		self:GetOwner():LagCompensation(false)
	end
end

function SWEP:Reload(...)
	if self:GetNextPrimaryFire() > CurTime() or self:GetNextSecondaryFire() > CurTime() then return end
	self:SetNextPrimaryFire(CurTime() + 2)
	self:SetNextSecondaryFire(CurTime() + 2)
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	timer.Simple(0.8, function()
		if self:IsValid() then
			---timer.Simple(0.8,function() if self:IsValid() and self.Owner:GetActiveWeapon():GetClass() == "tfa_cso_dark_spirit.lua" then---
			util.BlastDamage(self.Owner, self.Owner, self.Owner:GetPos(), 225, 0) --damage

			for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
				if IsValid(v) then
					if v == self then continue end
					if v == self.Owner then continue end
					if v:GetMoveType() != MOVETYPE_NOCLIP and (v:IsNPC() or v:IsNextBot() or v:IsPlayer()) then
						local dif = v:GetPos() - self:GetPos()
						local forceApplied = (dif * 2)
						v:SetVelocity(forceApplied + Vector(0, 0, 100))
					end
				end
			end
			local effectdata = EffectData()
			effectdata:SetOrigin(self.Owner:GetPos())
			util.Effect("exp_whipsword", effectdata) -- easy effect
		end
	end)
end

function SWEP:GetClass()
	return "weapon_ttt_blazenova"
end

function SWEP:OnDrop()
	self:Remove()
end

SWEP.InspectionActions = { ACT_VM_RECOIL1 }

DEFINE_BASECLASS(SWEP.Base)
function SWEP:Holster(...)
	self:StopSound("Hellfire.Idle")
	return BaseClass.Holster(self, ...)
end

if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_blazenova")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
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
	pos = pos + ang:Forward() * self.Offset.Pos.Forward + ang:Right() * self.Offset.Pos.Right +
		ang:Up() * self.Offset.Pos.Up

	ang:RotateAroundAxis(ang:Up(), self.Offset.Ang.Up)
	ang:RotateAroundAxis(ang:Right(), self.Offset.Ang.Right)
	ang:RotateAroundAxis(ang:Forward(), self.Offset.Ang.Forward)

	return pos, ang
end
