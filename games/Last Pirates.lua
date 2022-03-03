
repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Config = {
    Mob =       "Bandit [Lv:5]",
    Tool =      "Combat",
    Level =     false,
    Farm =      false,
    Skill =     false,
    Melee =     false,
    Sword =     false,
    Defense =   false,
    Devil =     false,
    AutoGet =   false,
    BigMom =    false,
    Factory =   false,
    SeaBeast =  false,
    Golem =     false,
    Tree =      false,
    Turtle =    false,
    LP =        false
}

local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

local MyLevel = Player.PlayerStats.Level
local Time = workspace.Time
local Hour = Time.Hour
local Minute = Time.Minute
local Second = Time.Second
local isHaki = false
local isBoss = false

local mobLevels = {}
for i, v in pairs(game:GetService("Workspace").Lives:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChild("Folder") and string.match(v.Name,"%d+") and not table.find(mobLevels,tonumber(string.match(v.Name,"%d+"))) then
        table.insert(mobLevels,tonumber(string.match(v.Name,"%d+")))
    end
end

for i, v in pairs(game:GetService("Workspace").Maps:GetChildren()) do
    if v.Name == "Part" then
        v:Destroy()
    end
end

function GetMob()
    local mob = {}
    for i, v in pairs(game:GetService("Workspace").Lives:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Folder") and not table.find(mob,v.Name) then
            table.insert(mob,v.Name)
        end
    end
    return mob
end

function GetTool()
    local tool = {}
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            table.insert(tool,v.Name)
        end
    end
    return tool
end

function ClosestLowLevel()
    local want = 5
    for i, v in pairs(mobLevels) do
        if v <= MyLevel.Value and want <= v then
            want = v
        end
    end
    return want
end

function Click()
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(69, 69))		
end

function EquipTool()
    Player.Character.Humanoid:EquipTool(Player.Backpack:FindFirstChild(_G.Config.Tool))
end

function StartQuest()
    task.spawn(function()
        local button = Player.PlayerGui.QuestGui.X
        local X = button.AbsolutePosition.X + button.AbsoluteSize.X
        local Y = button.AbsolutePosition.Y + button.AbsoluteSize.Y

        lol = string.split(_G.Config.Mob," [")
        if Player.PlayerGui.QuestGui.Enabled == false then
            ReplicatedStorage.FuncQuest:InvokeServer(lol[1])
        end
        if lol[1] ~= Player.Quest.Doing.Value and Player.Quest.Doing.Value ~= "None" then
            VirtualInputManager:SendMouseButtonEvent(X-20, Y+30, 0, true, game, 1)
            VirtualInputManager:SendMouseButtonEvent(X-20, Y+30, 0, false, game, 1)
        end
    end)
end

function AutoHaki()
	task.spawn(function()
        if not isHaki then
            isHaki = true
            if not Player.Character:FindFirstChild("Buso") then
                ReplicatedStorage.Haki:FireServer("Buso")
            end
            wait(2)
            if not Player.Character:FindFirstChild("Dodge") then
                ReplicatedStorage.HakiRemote:FireServer("Ken")
            end
            isHaki = false
        end
    end)
end

function NotSpawned()
    if isBoss == true then
        return false
    end
    return true
end

function UseSkill()
    task.spawn(function()
        for i, v in pairs({"Z", "X", "C", "V"}) do
            VirtualInputManager:SendKeyEvent(true, v, false, game) 
            VirtualInputManager:SendKeyEvent(false, v, false, game)
            task.wait()
        end
    end)
end

function GetBoss(asd)
    for i, v in pairs(game:GetService("Workspace").Lives:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Folder") and v.Name == asd then
            return v.HumanoidRootPart
        end
    end
    return false
end

function IsCollector()
    for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
        if v.Name == "Model" and v:FindFirstChild("Head") then
            return true
        end
    end
    return false
end

function IsBossSpawn()
    local boss = {}
    for i, v in pairs(game:GetService("Workspace").Lives:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Folder") and not string.match(v.Name,"%d+") then
            table.insert(boss,v.Name)
        end
    end
    return boss
end

function Teleport(mob)
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = mob
end

function FullAutoFarm()
    task.spawn(function()
        while task.wait() do
            if not _G.Config.Level then break end
            pcall(function()
                if NotSpawned() then
                    local close = ClosestLowLevel()
                    for i, v in pairs(game:GetService("Workspace").Lives:GetChildren()) do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                            if close == tonumber(string.match(v.Name,"%d+")) then
                                repeat task.wait()
                                    _G.Config.Mob = v.Name
                                    StartQuest()AutoHaki()EquipTool()Click()
                                    Teleport(v.HumanoidRootPart.CFrame * CFrame.new(0,7,0) * CFrame.Angles(math.rad(-90),0,0))
                                until v.Humanoid.Health <= 0 or not _G.Config.Level or not NotSpawned()
                            end
                        end
                    end
                end
            end)
        end
    end)
end

function SelectedFarm()
    task.spawn(function()
        while task.wait() do
            if not _G.Config.Farm then break end
            pcall(function()
                if NotSpawned() then
                    for i, v in pairs(game.Workspace.Lives:GetChildren()) do
                        if v.Name == _G.Config.Mob and v:FindFirstChild("Humanoid") then
                            repeat task.wait()
                                if _G.Config.Skill then
                                    UseSkill()
                                end
                                StartQuest()AutoHaki()EquipTool()Click()
                                Teleport(v.HumanoidRootPart.CFrame * CFrame.new(0,7,0) * CFrame.Angles(math.rad(-90),0,0))
                            until v.Humanoid.Health <= 0 or not _G.Config.Farm or not NotSpawned()
                        end
                    end
                end
            end)
        end
    end)
end

function AttackBoss(mob)
    if GetBoss(mob) then
        isBoss = true
        AutoHaki()EquipTool()Click()
        Teleport(GetBoss(mob).CFrame * CFrame.new(0,-7,0) * CFrame.Angles(math.rad(90),0,0))
    else
        isBoss = false
    end
end

function DoStats(asd)
    ReplicatedStorage.okStats:FireServer(1,asd)
end

local library = loadstring(game:HttpGet("https://pastebin.com/raw/4vZh2sLg"))()
local w = library:Window("Uzu Scripts", "Last Pirates", Color3.fromRGB(66, 134, 245), Enum.KeyCode.LeftControl)
local HomeTab = w:Tab("Home", 6026568198)

HomeTab:Button("Updates:", "", function()
    library:Notification("[+] - Auto Farm Boss \n [+] - Auto Get LP", "Thanks")
end)

HomeTab:Line()

HomeTab:Button("discord.gg/waAsQFwcBn"," ", function()
    setclipboard("discord.gg/waAsQFwcBn")
    library:Notification("discord.gg/waAsQFwcBn", "Alright")
end)

HomeTab:Button("Script by Uzu#8575"," ", function()
    setclipboard("Uzu#8575")
    library:Notification("Uzu#8575", "Alright")
end)

HomeTab:Line()

local now = HomeTab:Label("Server Time : "..Hour.Value.." Hour "..Minute.Value.." Minute "..Second.Value.." Second")

local collector = HomeTab:Label("Collector Spawned : "..tostring(IsCollector()))

local iBoss = HomeTab:Label("Boss Spawned : ")

local FarmingTab = w:Tab("Farming", 6034287535)

FarmingTab:Toggle("Auto Level Farm", "Farms mob from Level 1 to Max Level", false, function(t)
    _G.Config.Level = t

    FullAutoFarm()
end)

FarmingTab:Toggle("Auto Farm Selected Mob", "Farms Selected Mob", false, function(t)
    _G.Config.Farm = t

    SelectedFarm()
end)

FarmingTab:Line()

local MobDropdown = FarmingTab:Dropdown("Select Mob", GetMob(), function(v)
    _G.Config.Mob = v
end)

FarmingTab:Button("Refresh Mob","", function()
    MobDropdown:Clear()
    for i, v in pairs(GetMob()) do
        MobDropdown:Add(v)
    end
end)

local ToolDropdown = FarmingTab:Dropdown("Select Tool", GetTool(), function(v)
    _G.Config.Tool = v
end)

FarmingTab:Button("Refresh Tool","", function()
    ToolDropdown:Clear()
    for i, v in pairs(GetTool()) do
        ToolDropdown:Add(v)
    end
end)

FarmingTab:Toggle("Auto Skill", "", false, function(t)
    _G.Config.Skill = t
end)

FarmingTab:Line()

FarmingTab:Toggle("Auto Farm Big Mom", "", false, function(t)
    _G.Config.BigMom = t

    task.spawn(function()
        while task.wait() do
            if not _G.Config.BigMom then break end
            pcall(function()
                AttackBoss("Soul Boss")
            end)
        end
    end)
end)

FarmingTab:Toggle("Auto Farm Sea Beast", "", false, function(t)
    _G.Config.SeaBeast = t

    task.spawn(function()
        while task.wait() do
            if not _G.Config.SeaBeast then break end
            pcall(function()
                AttackBoss("Sea Beast")
            end)
        end
    end)
end)

FarmingTab:Toggle("Auto Farm Golem", "", false, function(t)
    _G.Config.Golem = t

    task.spawn(function()
        while task.wait() do
            if not _G.Config.Golem then break end
            pcall(function()
                AttackBoss("Golem")
            end)
        end
    end)
end)

FarmingTab:Toggle("Auto Farm Tree Monster", "", false, function(t)
    _G.Config.Tree = t

    task.spawn(function()
        while task.wait() do
            if not _G.Config.Tree then break end
            pcall(function()
                AttackBoss("TreeMoster")
            end)
        end
    end)
end)

FarmingTab:Toggle("Auto Farm Duke Turtle", "", false, function(t)
    _G.Config.Turtle = t

    task.spawn(function()
        while task.wait() do
            if not _G.Config.Turtle then break end
            pcall(function()
                AttackBoss("Turtle")
            end)
        end
    end)
end)

FarmingTab:Line()

FarmingTab:Toggle("Auto Farm Factory", "", false, function(t)
    _G.Config.Factory = t

    task.spawn(function()
        while task.wait() do
            if not _G.Config.Factory then break end
            pcall(function()
                AttackBoss("Factory")
            end)
        end
    end)
end)

local StatsTab = w:Tab("Stats", 6035078901)

StatsTab:Toggle("Melee", "", false, function(t)
    _G.Config.Melee = t

    task.spawn(function()
        while task.wait() do
            if not _G.Config.Melee then break end
            DoStats("1")
        end
    end)
end)

StatsTab:Toggle("Sword", "", false, function(t)
    _G.Config.Sword = t

    task.spawn(function()
        while task.wait() do
            if not _G.Config.Sword then break end
            DoStats("2")
        end
    end)
end)

StatsTab:Toggle("Defense", "", false, function(t)
    _G.Config.Defense = t

    task.spawn(function()
        while task.wait() do
            if not _G.Config.Defense then break end
            DoStats("3")
        end
    end)
end)

StatsTab:Toggle("Devil Fruit", "", false, function(t)
    _G.Config.Devil = t

    task.spawn(function()
        while task.wait() do
            if not _G.Config.Devil then break end
            DoStats("4")
        end
    end)
end)

local shopTab = w:Tab("Shop", 6031265987)

shopTab:Button("Buso Haki"," ", function()
    Teleport(game:GetService("Workspace").HakiSeller.AAA.BusoHaki.CFrame)
end)

shopTab:Button("Ken Haki"," ", function()
    Teleport(CFrame.new(-6278.6826171875, 32.993167877197, 3832.9084472656))
end)

shopTab:Button("Collector"," ", function()
    for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
        if v.Name == "Model" and v:FindFirstChild("Head") then
            Teleport(v.Head.CFrame)
        end
    end
end)

shopTab:Button("Random Color Haki"," ", function()
    Teleport(game:GetService("Workspace")["Random Color haki"]["Random Color haki"].Head.CFrame)
end)

shopTab:Button("Random Fruit"," ", function()
    Teleport(game:GetService("Workspace")["Random Fruit LP"].HumanoidRootPart.CFrame)
end)

shopTab:Button("Random Cupid Box", "", function()
    Teleport(CFrame.new(-5117.9814453125, 59.019378662109375, -5767.9091796875))
end)

shopTab:Button("Black Leg", "", function()
    Teleport(game:GetService("Workspace").Blackleg.Click.CFrame)
end)

shopTab:Button("Pole", "", function()
    Teleport(game:GetService("Workspace")["Pole Seller"].PoleClick.CFrame)
end)

shopTab:Button("Cutlass", "", function()
    Teleport(game:GetService("Workspace").cutlass.Click.CFrame)
end)

shopTab:Button("Bisento", "", function()
    Teleport(game:GetService("Workspace").Bisento.Part.CFrame)
end)

shopTab:Button("Bisento v2", "", function()
    Teleport(game:GetService("Workspace")["BisenV2 NPC"].Model.Model.BisenV2["Right Leg"].CFrame)
end)

shopTab:Button("Saber", "", function()
    Teleport(CFrame.new(3138.58984375, 71.283683776855, -2338.1533203125))
end)

shopTab:Button("Shisui", "", function()
    Teleport(game:GetService("Workspace").MISC.Handle.CFrame)
end)

shopTab:Button("Katana", "", function()
    Teleport(game:GetService("Workspace").KatanaShop.KatanaShop.Head.CFrame)
end)

local teleTab = w:Tab("Teleports", 8916381379)

teleTab:Button("Factory", "", function()
    Teleport(game:GetService("Workspace").Factory.Block.CFrame)
end)

for i, v in pairs(game:GetService("Workspace")["Spawn island"]:GetChildren()) do
    teleTab:Button(v.Name, "", function()
        Teleport(v.CFrame)
    end)
end

local MiscTab = w:Tab("Misc", 8916127218)

MiscTab:Toggle("Auto Get LP", "", false, function(t)
    _G.Config.LP = t

    task.spawn(function()
        while task.wait() do
            if not _G.Config.LP then break end
            for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
                if v.Name == "Part" and v:FindFirstChild("ProximityPrompt") then
                    if not v.ProximityPrompt:FindFirstChild("Script") then
                        Teleport(v.CFrame)
                        fireproximityprompt(v.ProximityPrompt)
                    end
                end
            end
        end
    end)
end)

MiscTab:Toggle("Auto Get Devil Fruit", "", false, function(t)
    _G.Config.AutoGet = t

    task.spawn(function()
        while task.wait() do
            if not _G.Config.AutoGet then break end
            for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
                if v:IsA("Part") and v:FindFirstChild("Part") and v:FindFirstChild("ProximityPrompt") then
                    if not v.ProximityPrompt:FindFirstChild("Script") then
                        Teleport(v.CFrame)
                        fireproximityprompt(v.ProximityPrompt)
                    end
                end
            end
        end
    end)
end)

MiscTab:Button("Inventory"," ", function()
    Teleport(CFrame.new(413.05569458008, 40.559078216553, -1830.5759277344))
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

task.spawn(function()
    while task.wait(1) do
        now:Change("Server Time : "..Hour.Value.." Hour "..Minute.Value.." Minute "..Second.Value.." Second")
    end
end)

task.spawn(function()
    while task.wait(2) do
        collector:Change("Collector Spawned : Refreshing.") task.wait(1)
        collector:Change("Collector Spawned : Refreshing..") task.wait(1)
        collector:Change("Collector Spawned : Refreshing...") task.wait(1)
        collector:Change("Collector Spawned : "..tostring(IsCollector()))
    end
end)

task.spawn(function()
    while task.wait(2) do
        local ddd = "Boss Spawned :"
        for i, v in pairs(IsBossSpawn()) do
            ddd = ddd..' '..v
        end
        iBoss:Change("Boss Spawned : Refreshing.") task.wait(1)
        iBoss:Change("Boss Spawned : Refreshing..") task.wait(1)
        iBoss:Change("Boss Spawned : Refreshing...") task.wait(1)
        iBoss:Change(ddd)
    end
end)
