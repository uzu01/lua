_G.autoFarm = false
_G.selectedMob = "Hoku"
_G.openEgg = false
_G.selectedEgg = "EGG1"

local mob = {}
local egg ={}

for i, v in pairs(game:GetService("Workspace").Enemys:GetChildren()) do
    if not table.find(mob,v.Name) then
        table.insert(mob,v.Name)
        table.sort(mob)
    end
end

for i, v in pairs(workspace.Tiers:GetChildren()) do
    if not table.find(egg,v.Name) then
        table.insert(egg,v.Name)
    end
end

function getNear()
    local near
    local nearr = math.huge
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart

    for i, v in pairs(game:GetService("Workspace").Enemys:GetChildren()) do
        if v.Name == _G.selectedMob and (plr.Position - v.HumanoidRootPart.Position).magnitude < nearr then
            near = v
            nearr = (plr.Position - v.HumanoidRootPart.Position).magnitude
        end
    end
    return near
end

function teleport(enemy)
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = enemy.CFrame * CFrame.new(0,0,4)
end

local library = loadstring(game:HttpGet("https://pastebin.com/raw/Uz6HijUN", true))()
local w = library:CreateWindow("Farming")
local b = library:CreateWindow("Egg")
local c = library:CreateWindow("Teleport")
local d = library:CreateWindow("Misc")

w:Toggle("Enabled", {flag = "a"}, function(v)
    _G.autoFarm = v
        
    task.spawn(function()
        while task.wait() do
            if not _G.autoFarm then break end
            local enemy = getNear()
            if enemy.Configuration.Died.Value == false then
                game:GetService("ReplicatedStorage").RemoteEvent.PetsAllEvent:FireServer("Best")
                teleport(enemy.HumanoidRootPart)
                game:GetService("ReplicatedStorage").RemoteEvent.AttackEvent:FireServer(enemy)
                wait(.5)
                repeat task.wait()
                    game:GetService("ReplicatedStorage").RemoteEvent.DamageAttack:FireServer()
                until enemy.Configuration.Died.Value == true or enemy.Configuration.Using.Value == false or not _G.autoFarm
            end
        end
    end)
end)

w:Dropdown("Select Enemy", {flag = "b", list = mob}, function(v)
    _G.selectedMob = v
end)

b:Toggle("Enabled", {flag = "a"}, function(v)
    _G.openEgg = v

    task.spawn(function()
        while task.wait() do
            if not _G.openEgg then break end
            game:GetService("ReplicatedStorage").RemoteEvent.PetPurchase:FireServer(workspace.Tiers[_G.selectedEgg],"NN")
        end
    end)
end)

b:Dropdown("Select Egg", {flag = "b", list = egg}, function(v)
    _G.selectedEgg = v
end)

for i, v in pairs(game.Workspace.Portals:GetChildren()) do
    c:Button(v.Name, function()
        game:GetService("ReplicatedStorage").RemoteEvent.IslandBuyOrTeleport:FireServer(v)
    end)
end

d:Button("Invisible", function()
    pcall(function()
		game.Players.LocalPlayer.Character.Humanoid.Animator:Destroy()
        game.Players.LocalPlayer.Character.LowerTorso.Root:Destroy()
        game.Players.LocalPlayer.Character.Tag:Destroy()
    end)
end)

d:Section("Script by Uzu")

d:Button("discord.gg/waAsQFwcBn", function()
    setclipboard(tostring("discord.gg/waAsQFwcBn"))
end)

local bb = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    bb:CaptureController()
    bb:ClickButton2(Vector2.new())
end)