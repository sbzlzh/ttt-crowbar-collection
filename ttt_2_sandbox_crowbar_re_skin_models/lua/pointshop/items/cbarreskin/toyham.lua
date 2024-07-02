ITEM.Name = 'Toy Hammer'
ITEM.Price = 5000
ITEM.Material = 'materials/pointshop/toyham.png'
ITEM.SingleUse = false
ITEM.WeaponClass = 'weapon_toy_hammer'
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
