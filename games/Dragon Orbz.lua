repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local selectedTool = "Punch"
local selectedMob = "Robber"
local tool = {}
local mob = {}
local keys = {
    "B";
    "V";
    "F";
    "X";
    "Z";
}

for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if v:IsA("Tool") then
        table.insert(tool,v.Name)
    end
end

for i, v in pairs(game:GetService("Workspace").Resources.SpawnedAI:GetChildren()) do
    if not table.find(mob, v.PlayerTag.TextLabel.Text) then
        table.insert(mob, v.PlayerTag.TextLabel.Text)
    end
end

table.sort(mob, function(a,b)
    return tonumber(string.match(a,"%d+")) < tonumber(string.match(b,"%d+"))
end)

function click()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(69, 69))		
end

function equipTool()
    game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(selectedTool))
    click()
end

game:GetService("RunService").Stepped:Connect(function()
    if _G.autofarm then 
        ReplicatedStorage.Packages.Knit.Services.CombatService.RF.MeleeAttack:InvokeServer("Punch")
    end
end)

local library = loadstring(game:HttpGet"https://pastebin.com/raw/CNw4eMqu")()
local w = library:Window("Uzu Scripts", "v1.0.0", Color3.fromRGB(66, 134, 245), Enum.KeyCode.RightControl)

local HomeTab = w:Tab("Home", 6026568198)

HomeTab:Button("Features:", "", function()
    library:Notification("[+] Auto Farm [+] Auto Quest\n [+] Auto Skill [+] Inf Charge\n [+] Auto Stats [+] Auto Random Orb\n [+] Auto Get Orb", "Thanks")
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

local FarmingTab = w:Tab("Farming", 6034287535)

FarmingTab:Toggle("Auto Farm", "", false, function(t)
    _G.autofarm = t

    task.spawn(function()
        while task.wait() do
            if not _G.autofarm then break end
            pcall(function()
                for i, v in pairs(game:GetService("Workspace").Resources.SpawnedAI:GetChildren()) do
                    if v.Name == selectedMob and v.PlayerTag then
                        repeat task.wait()
                            Player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,5,0) * CFrame.Angles(math.rad(-90),0,0)
                            if Player.PlayerGui.ActiveQuest.Background.Background.Visible == false then
                                ReplicatedStorage.Packages.Knit.Services.QuestService.RF.AcceptQuest:InvokeServer(selectedMob.." Quest")
                            end
                            equipTool()
                        until not v.PlayerTag or not _G.autofarm
                    end
                end
            end)
        end
    end)
end)

local mobdrop = FarmingTab:Dropdown("Select Mob", mob, function(v)
    local eelol = string.split(v," (")
    selectedMob = eelol[1]
end)

FarmingTab:Button("Refresh Mob", "", function()
    library:Notification("Success!", "Ok")

    mobdrop:Clear()

    local mob = {}

    for i, v in pairs(game:GetService("Workspace").Resources.SpawnedAI:GetChildren()) do
        if not table.find(mob, v.PlayerTag.TextLabel.Text) then
            table.insert(mob, v.PlayerTag.TextLabel.Text)
        end
    end

    table.sort(mob, function(a,b)
        return tonumber(string.match(a,"%d+")) < tonumber(string.match(b,"%d+"))
    end)
    
    for i, v in pairs(mob) do
        mobdrop:Add(v)
    end
end)

FarmingTab:Dropdown("Select Tool", tool, function(v)
    selectedTool = v
end)

FarmingTab:Toggle("Auto Skill", "", false, function(v)
    _G.autoSkill = v

    task.spawn(function()
        while task.wait() do
            if not _G.autoSkill then break end
            for i, v in pairs(keys) do
                game:GetService('VirtualInputManager'):SendKeyEvent(true, v, false, game)
                task.wait()
                game:GetService('VirtualInputManager'):SendKeyEvent(false, v, false, game)
            end
        end
    end)
end)

FarmingTab:Toggle("Inf Charge", "", false, function(v)
    _G.infcharge = v

    task.spawn(function()
        while task.wait() do
            if not _G.infcharge then break end
            ReplicatedStorage.Packages.Knit.Services.CharacterService.RF.ToggleCharge:InvokeServer(true)
        end
    end)
end)

local StatsTab = w:Tab("Stats", 6035078901)

StatsTab:Toggle("Melee", "", false, function(v)
    _G.autoMelee = v

    task.spawn(function()
        while task.wait() do
            if not _G.autoMelee then break end
            ReplicatedStorage.Packages.Knit.Services.StatService.RF.AddPoint:InvokeServer("Melee", 1)
        end
    end)
end)

StatsTab:Toggle("Defense", "", false, function(v)
    _G.autoDefense = v

    task.spawn(function()
        while task.wait() do
            if not _G.autoDefense then break end
            ReplicatedStorage.Packages.Knit.Services.StatService.RF.AddPoint:InvokeServer("Defense", 1)
        end
    end)
end)

StatsTab:Toggle("Mana", "", false, function(v)
    _G.autoMana = v

    task.spawn(function()
        while task.wait() do
            if not _G.autoMana then break end
            ReplicatedStorage.Packages.Knit.Services.StatService.RF.AddPoint:InvokeServer("Mana", 1)
        end
    end)
end)

StatsTab:Toggle("Orb", "", false, function(v)
    _G.autoOrb = v

    task.spawn(function()
        while task.wait() do
            if not _G.autoOrb then break end
            ReplicatedStorage.Packages.Knit.Services.StatService.RF.AddPoint:InvokeServer("Orb", 1)
        end
    end)
end)

local shopTab = w:Tab("Shop", 6031265987)

shopTab:Toggle("Auto Random Orb", "25k Zen [Lvl. 50 Required]", false, function(v)
    _G.randomOrb = v
    
    task.spawn(function()
        while task.wait() do
            if not _G.randomOrb then break end
            ReplicatedStorage.Packages.Knit.Services.OrbDealerService.RF.BuyRandomOrb:InvokeServer()
        end
    end)
end)

local MiscTab = w:Tab("Misc", 6031215984)

MiscTab:Toggle("Auto Get Orb", "", false, function(v)
    _G.autoOrb = v
    
    task.spawn(function()
        while task.wait() do
            if not _G.autoOrb then break end
            for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
                if v:IsA("Tool") then
                    Player.Character.Humanoid:EquipTool(v)
                end
            end
            for i, v in pairs(game:GetService("Workspace").Resources.SpawnedOrbs:GetChildren()) do
                Player.Character.Humanoid:EquipTool(v)
            end
        end
    end)
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
