repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.mobFarm = false
_G.selectedMob = "Krunks"

local mob = {}
local farmPos = "Behind"

for i, v in pairs(game.Workspace.NPCS:GetChildren()) do
    if not table.find(mob,v.Name) then
        table.insert(mob,v.Name)
    end
end

function getNear()
    local near
    local nearr = math.huge
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart

    for i, v in pairs(game:GetService("Workspace").NPCS:GetChildren()) do
        if v.Name == _G.selectedMob and (plr.Position - v.HumanoidRootPart.Position).Magnitude < nearr then
            near = v.HumanoidRootPart
            nearr = (plr.Position - v.HumanoidRootPart.Position).Magnitude
        end
    end

    return near
end 

function teleport(enemy)
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart

    if farmPos == "Under" then
        plr.CFrame = enemy.CFrame * CFrame.new(0,-10,0)
    elseif farmPos == "Behind" then
        plr.CFrame = enemy.CFrame * CFrame.new(0,0,5) 
    end
end

function noclip()
    for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

local library = loadstring(game:HttpGet("https://pastebin.com/raw/Uz6HijUN", true))()
local w = library:CreateWindow("Farming")

w:Toggle("Enabled", {flag = "a"}, function(value)
    _G.mobFarm = value
    
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-393.16705322266, 5.9964461326599, -405.14428710938)
    game.Workspace.Gravity = 198.2
end)

w:Dropdown("Dropdown", { flag = "dw", list = mob}, function(v)
    _G.selectedMob = v
end)

w:Dropdown("Farm Position", {flag = "a", list = {"Behind","Under"}}, function(v)
    farmPos = v
end)

w:Section("Script by Uzu")

w:Button("discord.gg/waAsQFwcBn", function()
    setclipboard(tostring("discord.gg/waAsQFwcBn"))
end)

if _G.lol then _G.lol:Disconnect() end
_G.lol = game:GetService('RunService').Stepped:Connect(function()
    if _G.mobFarm then
        noclip()
        pcall(function()
            game.Workspace.Gravity = 0
            teleport(getNear())
            game:GetService("ReplicatedStorage").Remotes.ClientRemote:InvokeServer("Tapping",getNear())
        end)
    end
end)