-- inf jump
local a = game:GetService("Players").LocalPlayer.PlayerScripts.Client.Main.doubleJumping
for i, v in pairs(getgc()) do
    if typeof(v) == 'function' and getfenv(v).script == a then
        for i2, v2 in pairs(getupvalues(v)) do
            if type(v2) == 'number' then
                setupvalue(v,i2,9e9)
            end
        end
    end
end

-- gamepass
local b = require(game:GetService("ReplicatedStorage").ShopModule)
local gpData = game:GetService("Players").LocalPlayer.Data.gamepasses
for i, v in pairs(b.Gamepasses) do
    gpData.Value = gpData.Value..';'..v.Label..';'
end

-- boost
for i, v in pairs(game:GetService("Players").LocalPlayer.Boosts:GetChildren()) do
    v:FindFirstChild("isActive").Value = true
end