
repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

pcall(function()
    game.Players.LocalPlayer.PlayerGui.Hatching:Destroy()
end)

local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local hrp = Player.Character.HumanoidRootPart
local isTriple = "Single"
local selectedMob = "G General"
local Plot
local mob = {}
local egg = {}

local keys = {
    "Z";
    "X";
    "C";
    "V";
    "F"
}

for i, v in pairs(game.Workspace.Tycoons:GetChildren()) do
    if v.Data.Owner.Value == Player then
        Plot = v
    end
end

for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
    if v:FindFirstChild("Units") and not table.find(mob,'> '..v.Name..' <') then
        table.insert(mob,'> '..v.Name..' <')
        for i2, v2 in pairs(v.Units:GetChildren()) do
            if v2:FindFirstChild("Head") and v2.Head:FindFirstChild("Overhead") then
                for i3, v3 in pairs(v2.Head.Overhead:GetChildren()) do
                    if v3.Name == "Name" and not table.find(mob,v3.Text) then
                        table.insert(mob,v3.Text)
                    end
                end
            end
        end
    end
end

for i, v in pairs(game:GetService("ReplicatedStorage").Assets.Prisms:GetChildren()) do
    table.insert(egg,v.Name)
end

game:GetService("RunService").Stepped:Connect(function()
    if _G.automob then
        for i, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
        Player.Character.HumanoidRootPart.Velocity =  Vector3.new(0,0,0)
    end
end)

local library = loadstring(game:HttpGet"https://pastebin.com/raw/CNw4eMqu")()
local w = library:Window("Uzu Scripts", "ABT", Color3.fromRGB(66, 134, 245), Enum.KeyCode.LeftControl)

local HomeTab = w:Tab("Home", 6026568198)

HomeTab:Button("Update:", "", function()
    library:Notification("Fixed Bugs", "Thanks")
end)

HomeTab:Line()

HomeTab:Button("Discord","", function()
    setclipboard("discord.gg/waAsQFwcBn")
    library:Notification("discord.gg/waAsQFwcBn", "Alright")
end)

HomeTab:Button("Script by Uzu","", function()
    setclipboard("discord.gg/waAsQFwcBn")
    library:Notification("discord.gg/waAsQFwcBn", "Alright")
end)

local TycTab = w:Tab("Tycoon", 6035067854)

TycTab:Toggle("Spawn Workers", "", false, function(t)
    _G.autospawn = t

    task.spawn(function()
        while task.wait() do
            if not _G.autospawn then break end
            pcall(function() 
                local Spawner = Plot.Tycoon.Objects[1].Spawners.Start.Model.Proximity.Attachment.TycoonSpawn
                local hrp = Player.Character.HumanoidRootPart
                if (hrp.CFrame.p -  Spawner.Parent.Parent.CFrame.p).Magnitude > 50 then
                    hrp.CFrame =  Spawner.Parent.Parent.CFrame
                end
                fireproximityprompt(Spawner) 
            end)
        end
    end)
end)

TycTab:Toggle("Auto Sell", "", false, function(v)
    _G.autosell = v

    task.spawn(function()
        while task.wait() do
            if not _G.autosell then break end
            pcall(function()
                ReplicatedStorage.Modules.ServiceLoader.NetworkService.Events.Objects.UpdateTycoons:FireServer("CollectMoney")
            end)
        end
    end)
end)

TycTab:Toggle("Auto Buy Buttons", "", false, function(t)
    _G.autobuy = t

    task.spawn(function()
        while task.wait() do
            if not _G.autobuy then break end
            pcall(function()
                for i, v in pairs(Plot.Tycoon.Buttons:GetChildren()) do
                    ReplicatedStorage.Modules.ServiceLoader.NetworkService.Events.Objects.UpdateTycoons:FireServer("BuyButton",v.Name)
                end
            end)
        end
    end)
end)

TycTab:Toggle("Auto Buy New Hero", "", false, function(t)
    _G.autohero = t

    task.spawn(function()
        while task.wait() do
            if not _G.autohero then break end
            pcall(function()
                for i, v in pairs(ReplicatedStorage.Modules.ServiceLoader.EffectsService.Handlers.Heroes:GetChildren()) do
                    ReplicatedStorage.Modules.ServiceLoader.NetworkService.Events.Objects.UpdateHeroes:FireServer("BuyHero",v.Name)
                end
            end)
        end
    end)
end)

TycTab:Toggle("Auto Buy New World", "", false, function(t)
    _G.autoworld = t

    task.spawn(function()
        while task.wait() do
            if not _G.autoworld then break end
            pcall(function()
                for i, v in pairs(ReplicatedStorage.Modules.Handlers.Zones.Worlds:GetChildren()) do
                    ReplicatedStorage.Modules.ServiceLoader.NetworkService.Events.Objects.UpdateZones:FireServer("BuyWorld",v.Name)
                end
            end)
        end
    end)
end)

local FarmingTab = w:Tab("Farming", 6034287535)

FarmingTab:Toggle("Farm Mobs", "", false, function(t)
    _G.automob = t

    task.spawn(function()
        while task.wait() do
            if not _G.automob then break end
            pcall(function()
                local hrp = Player.Character.HumanoidRootPart
                for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v:FindFirstChild("Units") then
                        for i2, v2 in pairs(v.Units:GetChildren()) do
                            if v2:FindFirstChild("HumanoidRootPart") then
                                for i2, v3 in pairs(v2.Head.Overhead:GetChildren()) do
                                    if v3.Name == "Name" and v3.Text == selectedMob and _G.automob then
                                        repeat task.wait() 
                                            hrp.CFrame = v3.Parent.Parent.Parent.HumanoidRootPart.CFrame * CFrame.new(0,-5,0) * CFrame.Angles(math.rad(90),0,0)
                                            ReplicatedStorage.Modules.ServiceLoader.NetworkService.Events.Objects.UpdateMelee:FireServer("RequestAction","Combat","Combat")
                                        until v3.Parent == nil or not _G.automob or v3.Text ~= selectedMob
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

local eneDrop = FarmingTab:Dropdown("Select Mob", mob, function(v)
    selectedMob = v
end)

FarmingTab:Button("Refresh Mob", "", function()
    eneDrop:Clear()

    local mob = {}

    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v:FindFirstChild("Units") and not table.find(mob,'> '..v.Name..' <') then
            table.insert(mob,'> '..v.Name..' <')
            for i2, v2 in pairs(v.Units:GetChildren()) do
                if v2.Head:FindFirstChild("Overhead") then
                    for i2, v3 in pairs(v2.Head.Overhead:GetChildren()) do
                        if v3.Name == "Name" and not table.find(mob,v3.Text) then
                            table.insert(mob,v3.Text)
                        end
                    end
                end
            end
        end
    end

    for i, v in pairs(mob) do
        eneDrop:Add(v)
    end
end)


FarmingTab:Toggle("Auto Skill", "", false, function(v)
    _G.autoskill = v

    task.spawn(function()
        while task.wait() do
            if not _G.autoskill then break end
            for i, v in pairs(keys) do
                game:GetService('VirtualInputManager'):SendKeyEvent(true, v, false, game) task.wait()
                game:GetService('VirtualInputManager'):SendKeyEvent(false, v, false, game)
            end
        end
    end)
end)

local PetTab = w:Tab("Companions", 6031260792)

PetTab:Toggle("Auto Hatch Egg", "", false, function(v)
    _G.autoegg = v

    task.spawn(function()
        while task.wait() do
            if not _G.autoegg then break end
            game:GetService("ReplicatedStorage").Modules.ServiceLoader.NetworkService.Events.Objects.UpdatePets:FireServer("HatchEgg",selectedEgg,isTriple)
        end
    end)
end)

PetTab:Dropdown("Select Egg", egg, function(v)
    selectedEgg = v
end)

PetTab:Toggle("Multiple Hatch", "", false, function(v)
    dddd = v
    
    if dddd then
        isTriple = "Multiple"
    else
        isTriple = "Single"
    end
end)

local StatsTab = w:Tab("Stats", 6035078901)

StatsTab:Toggle("Strength", "", false, function(t)
    _G.Strength = t

    task.spawn(function()
        while task.wait() do
            if not _G.Strength then break end
            pcall(function()
                ReplicatedStorage.Modules.ServiceLoader.NetworkService.Events.Objects.UpdateHeroes:FireServer("BuySkillLevel","Strength",1)
            end)
        end
    end)
end)

StatsTab:Toggle("Ability", "", false, function(t)
    _G.Ability = t

    task.spawn(function()
        while task.wait() do
            if not _G.Ability then break end
            pcall(function()
                ReplicatedStorage.Modules.ServiceLoader.NetworkService.Events.Objects.UpdateHeroes:FireServer("BuySkillLevel","Ability",1)
            end)
        end
    end)
end)

StatsTab:Toggle("Health", "", false, function(t)
    _G.Health = t

    task.spawn(function()
        while task.wait() do
            if not _G.Health then break end
            pcall(function()
                ReplicatedStorage.Modules.ServiceLoader.NetworkService.Events.Objects.UpdateHeroes:FireServer("BuySkillLevel","Health",1)
            end)
        end
    end)
end)

StatsTab:Toggle("Defense", "", false, function(t)
    _G.Defense = t

    task.spawn(function()
        while task.wait() do
            if not _G.Defense then break end
            pcall(function()
                ReplicatedStorage.Modules.ServiceLoader.NetworkService.Events.Objects.UpdateHeroes:FireServer("BuySkillLevel","Defense",1)
            end)
        end
    end)
end)

local MiscTab = w:Tab("Misc", 6031215984)

MiscTab:Toggle("Auto Hide Nametag", "", false, function(t)
    _G.nametag = t

    task.spawn(function()
        while task.wait() do
            if not _G.nametag then break end
            if Player.Character.Head:FindFirstChild("PlayerOverhead") then
                Player.Character.Head:FindFirstChild("PlayerOverhead"):Destroy()
            end 
        end
    end)
end)

MiscTab:Button("Hide Notifications", "", function()
    Player.PlayerGui.Display.Notifications.Visible = false
end)

MiscTab:Line()

MiscTab:Slider("Walk Speed", "",18, 100, 0, function(v)
    Player.Character.Humanoid.WalkSpeed = v
end)

MiscTab:Slider("Jump Height", "", 7.5, 100, 0, function(v)
    Player.Character.Humanoid.JumpHeight = v
end)

MiscTab:Line()

MiscTab:Button("Rejoin", "", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,game.Players.LocalPlayer)
end)

MiscTab:Button("Serverhop", "", function()
    while task.wait() do
        local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for i,v in pairs(Servers.data) do
            if v.id ~= game.JobId then
                task.wait()
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end
end)

MiscTab:Button("Serverhop Low Server", "", function()
    while task.wait() do
        local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for i,v in pairs(Servers.data) do
            if v.id ~= game.JobId and v.playing <= 3 then
                task.wait()
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end
end)
