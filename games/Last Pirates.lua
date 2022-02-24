repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Settings = {
    autofarm = false,
    selectedMob = "Bandit [Lv:5]",
    selectedTool = "Combat",
    autoskill = false,
    melee = false,
    sword = false,
    defense = false,
    devil = false,
    autoget = false,
}

local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local MyLevel = Player.PlayerStats.Level
local mobLevels = {}
local mob = {}
local tool = {}

local keys = {
    "Z";
    "X";
    "C";
    "V"
}

for i, v in pairs(game:GetService("Workspace").Lives:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChild("Folder") and string.match(v.Name,"%d+") and not table.find(mobLevels,tonumber(string.match(v.Name,"%d+"))) then
        table.insert(mobLevels,tonumber(string.match(v.Name,"%d+")))
    end
end

for i, v in pairs(game:GetService("Workspace").Lives:GetChildren()) do
    if v:IsA("Model") and v:FindFirstChild("Folder") and not table.find(mob,v.Name) then
        table.insert(mob,v.Name)
    end
end

for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
	if v:IsA("Tool") then
		table.insert(tool,v.Name)
	end
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

function click()
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(69, 69))		
end

function equipTool()
	Player.Character.Humanoid:EquipTool(Player.Backpack:FindFirstChild(_G.Settings.selectedTool))
end

function startQuest()
    task.spawn(function()
        if Player.PlayerGui.QuestGui.Enabled == false then
            lol = string.split(_G.Settings.selectedMob," [")
            ReplicatedStorage.FuncQuest:InvokeServer(lol[1])
        end
    end)
end

function autoHaki()
    if not Player.Character:FindFirstChild("Buso") then
        ReplicatedStorage.Haki:FireServer("Buso")
        ReplicatedStorage.HakiRemote:FireServer("Ken")
    end
end

function useSkill()
    for i, v in pairs(keys) do
        VirtualInputManager:SendKeyEvent(true, v, false, game) 
        task.wait()
        VirtualInputManager:SendKeyEvent(false, v, false, game)
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/uzu01/lua/main/ui/flux.lua"))()
local w = library:Window("Uzu Scripts", "Last Pirates", Color3.fromRGB(66, 134, 245), Enum.KeyCode.LeftControl)
local HomeTab = w:Tab("Home", 6026568198)

HomeTab:Button("Updates:", "", function()
    library:Notification("[+] Full Auto Farm", "Thanks")
end)

HomeTab:Line()

HomeTab:Button("Discord"," ", function()
    setclipboard("discord.gg/waAsQFwcBn")
    library:Notification("discord.gg/waAsQFwcBn", "Alright")
end)

HomeTab:Button("Script by Uzu"," ", function()
    setclipboard("discord.gg/waAsQFwcBn")
    library:Notification("discord.gg/waAsQFwcBn", "Alright")
end)

local FarmingTab = w:Tab("Farming", 6034287535)

FarmingTab:Toggle("Full Auto Farm", "", false, function(t)
    _G.Settings.fullfarm = t

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.fullfarm then break end
            pcall(function()
                local plr = Player.Character.HumanoidRootPart
                local close = ClosestLowLevel()
                for i, v in pairs(game:GetService("Workspace").Lives:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                        if close == tonumber(string.match(v.Name,"%d+")) then
                            repeat task.wait()
                                _G.Settings.selectedMob = v.Name
                                startQuest()
                                autoHaki()
                                plr.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,7,0) * CFrame.Angles(math.rad(-90),0,0)
                                equipTool()
                                click()
                            until v.Humanoid.Health <= 0 or not _G.Settings.fullfarm
                        end
                    end
                end
            end)
        end
    end)
end)

FarmingTab:Line()

FarmingTab:Toggle("Auto Farm", "", false, function(t)
    _G.Settings.autofarm = t

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autofarm then break end
            pcall(function()
                local plr = Player.Character.HumanoidRootPart
                startQuest()
                autoHaki()
                for i, v in pairs(game.Workspace.Lives:GetChildren()) do
                    if v.Name == _G.Settings.selectedMob and v:FindFirstChild("Humanoid") then
                        repeat task.wait()
                            plr.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,7,0) * CFrame.Angles(math.rad(-90),0,0)
                            equipTool()
                            click()
                        until v.Humanoid.Health <= 0 or not _G.Settings.autofarm
                    end
                end
            end)
        end
    end)
end)

local mobDrop = FarmingTab:Dropdown("Select Mob", mob, function(v)
    _G.Settings.selectedMob = v
end)

FarmingTab:Button("Refresh Mob"," ", function()
    mobDrop:Clear()

    local mob = {}

    for i, v in pairs(game:GetService("Workspace").Lives:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Folder") and not table.find(mob,v.Name) then
            table.insert(mob,v.Name)
        end
    end

    for i, v in pairs(mob) do
        mobDrop:Add(v)
    end
end)

FarmingTab:Line()

local toolDrop = FarmingTab:Dropdown("Select Tool", tool, function(v)
    _G.Settings.selectedTool = v
end)

FarmingTab:Button("Refresh Tool"," ", function()
    toolDrop:Clear()

    local tool = {}

    for i, v in pairs(Player.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            table.insert(tool,v.Name)
        end
    end

    for i, v in pairs(tool) do
        toolDrop:Add(v)
    end
end)

FarmingTab:Toggle("Auto Skill", "", false, function(t)
    _G.Settings.autoskill = t

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoskill then break end
            useSkill()
        end
    end)
end)

local StatsTab = w:Tab("Stats", 6035078901)

StatsTab:Toggle("Melee", "", false, function(t)
    _G.Settings.melee = t

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.melee then break end
            ReplicatedStorage.okStats:FireServer(1,"1")
        end
    end)
end)

StatsTab:Toggle("Sword", "", false, function(t)
    _G.Settings.sword = t

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.sword then break end
            ReplicatedStorage.okStats:FireServer(1,"2")
        end
    end)
end)

StatsTab:Toggle("Defense", "", false, function(t)
    _G.Settings.defense = t

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.defense then break end
            ReplicatedStorage.okStats:FireServer(1,"3")
        end
    end)
end)

StatsTab:Toggle("Devil Fruit", "", false, function(t)
    _G.Settings.devil = t

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.devil then break end
            ReplicatedStorage.okStats:FireServer(1,"4")
        end
    end)
end)

local shopTab = w:Tab("Shop", 6031265987)

shopTab:Button("Buso Haki"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").HakiSeller.AAA.BusoHaki.CFrame
end)

shopTab:Button("Ken Haki"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = CFrame.new(-6278.6826171875, 32.993167877197, 3832.9084472656)
end)

shopTab:Button("Random Color Haki"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace")["Random Color haki"]["Random Color haki"].Head.CFrame
end)

shopTab:Button("Random Fruit"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").RandomFruit.HumanoidRootPart.CFrame
end)

shopTab:Button("Black Leg"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").Blackleg.Click.CFrame
end)

shopTab:Button("Pole"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace")["Pole Seller"].PoleClick.CFrame
end)

shopTab:Button("Cutlass"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").cutlass.Click.CFrame
end)

shopTab:Button("Bisento"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").Bisento.Part.CFrame
end)

shopTab:Button("Bisento v2"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace")["BisenV2 NPC"].Model.Model.BisenV2["Right Leg"].CFrame
end)

shopTab:Button("Saber"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = CFrame.new(3138.58984375, 71.283683776855, -2338.1533203125)
end)

shopTab:Button("Shisui"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").MISC.Handle.CFrame
end)

shopTab:Button("Katana"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").KatanaShop.KatanaShop.Head.CFrame
end)

local teleTab = w:Tab("Teleports", 8916381379)

teleTab:Button("Factory"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").Factory.Block.CFrame
end)

for i, v in pairs(game:GetService("Workspace")["Spawn island"]:GetChildren()) do
    teleTab:Button(v.Name," ", function()
        local plr = Player.Character.HumanoidRootPart
        plr.CFrame = v.CFrame
    end)
end

local MiscTab = w:Tab("Misc", 8916127218)

MiscTab:Toggle("Auto Get Devil Fruit", "", false, function(t)
    _G.Settings.autoget = t

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoget then break end
            for i, v in pairs(game.Workspace.Maps:GetDescendants()) do
                if v.Name == "ProximityPrompt" then
                    local plr = Player.Character.HumanoidRootPart
                    plr.CFrame = v.Parent.CFrame    
                    fireproximityprompt(v)
                end
            end
        end
    end)
end)

MiscTab:Button("Inventory"," ", function()
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = CFrame.new(413.05569458008, 40.559078216553, -1830.5759277344)
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
