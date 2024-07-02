if CLIENT then
    hook.Add("Tick", "nfblacksword", function()
        for _, ply in pairs(player.GetAll()) do
            if ply:GetActiveWeapon():IsValid() then
                if ply:GetActiveWeapon():GetClass() == "weapon_ttt_nfblacksword" then
                    local pos = ply:EyePos()
                    local ang = ply:EyeAngles()
                    local light = DynamicLight(ply:EntIndex())
                    if light then
                        light.r = 110
                        light.g = 110
                        light.b = 255
                        if ply == LocalPlayer() then
                            light.Pos = pos + (ang:Forward() * 38) + (ang:Up() * 2) + (ang:Right() * 10)
                        else
                            light.Pos = pos + (ang:Forward() * 38) + (ang:Up() * 2) + (ang:Right() * 10)
                        end

                        light.Brightness = 0.8
                        light.Size = 200
                        light.Decay = 25
                        light.DieTime = CurTime() + 1
                        light.Style = 1
                    end
                end
            end
        end
    end)
end
