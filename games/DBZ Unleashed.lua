
repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.autofarm = false

local Player = game:GetService("Players").LocalPlayer
local ReplicatedStoragee = game:GetService("ReplicatedStorage")
local selectedMob = "Thug (lvl. 5)"
local selectedQuest = "Defeat 10 Thugs"
local mob = {}
local keys = {
    "E";
    "C";
    "R";
    "V";
    "X";
    "Y";
}

for i, v in pairs(game.Workspace.Live:GetChildren()) do
    if v:IsA("Model") and v.Name ~= "Training Dummy" and not table.find(mob,v.Name) then
        table.insert(mob,v.Name)
    end
end

table.sort(mob, function(a,b) return tonumber(string.match(a,"%d+")) < tonumber(string.match(b,"%d+")) end)

function click()
    task.spawn(function()
        local plr = Player.Character.HumanoidRootPart
        ReplicatedStoragee.RemoteEvents.BladeCombatRemote:FireServer(false,plr.CFrame.p,plr.CFrame)
    end)
end

function equipTool()
    for i, v in pairs(Player.Backpack:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Experience") then
            Player.Character.Humanoid:EquipTool(v)
        end
    end
end

function teleport(ene)
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = ene.CFrame * CFrame.new(0,0,5)
end

function noclip()
    for i, v in pairs(Player.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

function quest()
    for i, v in pairs(game.Workspace.Live:GetChildren()) do
        if v.Name == selectedMob and v:IsA("Model") then
            if Player.PlayerGui.Menu.QuestFrame.Visible == false or Player.PlayerGui.Menu.QuestFrame.QuestName.Text ~= v.Quest.Value then
                ReplicatedStoragee.RemoteEvents.ChangeQuestRemote:FireServer(game:GetService("ReplicatedStorage").Quests[v.Quest.Value])
            end
        end
    end
end

function getEnemy()
    local plr = Player.Character.HumanoidRootPart

    for i, v in pairs(game.Workspace.Live:GetChildren()) do
        if v.Name == selectedMob and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
            local qFrame = Player.PlayerGui.Menu.QuestFrame
            if qFrame.QuestName.Text ~= v.Quest.Value then
                ReplicatedStoragee.RemoteEvents.ChangeQuestRemote:FireServer(game:GetService("ReplicatedStorage").Quests[v.Quest.Value])
            end
            plr.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
        end
    end
end

function bring()
    local plr = Player.Character.HumanoidRootPart

    for i, v in pairs(game.Workspace.Live:GetChildren()) do
        if v.Name == selectedMob and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
            for i2, v2 in pairs(game:GetService("Workspace").QuestMarkers:GetChildren()) do
                if v2.Name == v.Quest.Value then
                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 1000)
                    plr.CFrame = v2.CFrame * CFrame.new(0,-20,0)
                    v.HumanoidRootPart.CFrame = plr.CFrame * CFrame.new(0,0,-2)
                end
            end
        end
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/uzu01/lua/main/ui/flux.lua"))()
local w = library:Window("Uzu Scripts", "v1.0.0", Color3.fromRGB(66, 134, 245), Enum.KeyCode.LeftControl)

local HomeTab = w:Tab("Home", 6026568198)
local FarmingTab = w:Tab("Farming", 6034287535)
local ShopTab = w:Tab("Shop", 6031265987)
local MiscTab = w:Tab("Misc", 8916127218)

HomeTab:Button("Update:", "", function()
    library:Notification("[+] New Gui [+] Shop Tab", "Thanks")
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

FarmingTab:Toggle("Auto Farm", "", false, function(t)
    _G.autofarm = t

    task.spawn(function()
        while task.wait() do
            if not _G.autofarm then break end
            pcall(function()
                quest()
                getEnemy()
                click()
                equipTool()
                if bringMob then
                    bring()
                end
            end)
        end
    end)
end)

FarmingTab:Toggle("Bring Mob", "", false, function(t)
    bringMob = t
end)

FarmingTab:Dropdown("Select Mob", mob, function(v)
    selectedMob = v 
end)

FarmingTab:Toggle("Auto Skill", "", false, function(t)
    _G.autoSkill = t

    task.spawn(function()
        while task.wait() do
            if not _G.autoSkill then break end
            for i, v in pairs(keys) do
                game:GetService('VirtualInputManager'):SendKeyEvent(true, v, false, game)
            end
        end
    end)
end)

ShopTab:Toggle("Auto Buy Arrow", "", false, function(t)
    _G.autoArrow = t

    task.spawn(function()
        while task.wait() do
            if not _G.autoArrow then break end
            ReplicatedStoragee.RemoteEvents.BuyItemRemote:FireServer("Arrow")
        end
    end)
end)

ShopTab:Toggle("Auto Buy Bag", "", false, function(t)
    _G.autoArmor = t

    task.spawn(function()
        while task.wait() do
            if not _G.autoArmor then break end
            ReplicatedStoragee.RemoteEvents.BuyItemRemote:FireServer("Random Armor")
        end
    end)
end)

ShopTab:Toggle("Auto Buy Heart", "", false, function(t)
    _G.autoHeart = t

    task.spawn(function()
        while task.wait() do
            if not _G.autoHeart then break end
            ReplicatedStoragee.RemoteEvents.BuyItemRemote:FireServer("Heart")
        end
    end)
end)

ShopTab:Toggle("Auto Buy Random Specialization", "", false, function(t)
    _G.autoSpec = t

    task.spawn(function()
        while task.wait() do
            if not _G.autoSpec then break end
            ReplicatedStoragee.RemoteEvents.BuyItemRemote:FireServer("Random Specialization")
        end
    end)
end)

MiscTab:Toggle("Auto Delete Common Bag", "", false, function(v)
    _G.deleteCommon = v

    task.spawn(function()
        while task.wait() do
            if not _G.deleteCommon then break end
            pcall(function()
                for i, v in pairs(Player.Backpack:GetChildren()) do 
                    if v.Name == "Bag" and v.BagPart.Overhead.Rarity.Text == "Common" then
                        v.Parent = Player.Character
                        v:Destroy()
                    end
                end
            end)
        end
    end)
end)

MiscTab:Toggle("Auto Delete Rare Bag", "", false, function(v)
    _G.deleteRare = v

    task.spawn(function()
        while task.wait() do
            if not _G.deleteRare then break end
            pcall(function()
                for i, v in pairs(Player.Backpack:GetChildren()) do 
                    if v.Name == "Bag" and v.BagPart.Overhead.Rarity.Text == "Rare" then
                        v.Parent = Player.Character
                        v:Destroy()
                    end
                end
            end)
        end
    end)
end)

MiscTab:Line()

MiscTab:Button("Disable Effects", "", function()
    pcall(function() 
        game.Workspace.Effects:Destroy() 
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
