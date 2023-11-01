ITEM.Name = 'Diamond Pick'
ITEM.Price = 5000
ITEM.Material = 'materials/pointshop/mcpickaxe.png'
ITEM.SingleUse = false
ITEM.WeaponClass = 'weapon_diamond_pick'

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
