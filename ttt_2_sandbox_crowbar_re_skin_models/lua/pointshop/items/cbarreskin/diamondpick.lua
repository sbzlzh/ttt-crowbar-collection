ITEM.Name = 'Diamond Pick' -- Name displayed in Poinshop
ITEM.Price = 5000 -- Cost to purchase
ITEM.Material = 'materials/pointshop/mcpickaxe.png' -- image file for the pointshop 
ITEM.SingleUse = false -- makes it so once you buy you keep it
ITEM.WeaponClass = 'weapon_diamond_pick' -- important, do not change

function ITEM:OnEquip(ply)
ply:StripWeapon('weapon_zm_improvised')
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnHolster(ply)
	ply:StripWeapon(self.WeaponClass)
	ply:Give('weapon_zm_improvised')
	ply:SelectWeapon('weapon_zm_improvised')
end