repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.autofarm = false

local selectedMob = "Thug (lvl. 5)"
local selectedTool = "Strategy to Defeat the Emperor Vegeta"
local mob = {}
local tool = {}

for i, v in pairs(game.Workspace.Live:GetChildren()) do
    if v:IsA("Model") and v.Name ~= "Training Dummy" and not table.find(mob,v.Name) then
        table.insert(mob,v.Name)
    end
end

table.sort(mob, function(a,b) return tonumber(string.match(a,"%d+")) < tonumber(string.match(b,"%d+")) end)

for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if v:IsA("Tool") then
        table.insert(tool,v.Name)
    end
end

function click()
    task.spawn(function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        game:GetService("ReplicatedStorage").RemoteEvents.BladeCombatRemote:FireServer(false,plr.CFrame.p,plr.CFrame)
        if autoSkill then
            game:GetService('VirtualInputManager'):SendKeyEvent(true, "E", false, game)
            game:GetService('VirtualInputManager'):SendKeyEvent(true, "R", false, game)
            game:GetService('VirtualInputManager'):SendKeyEvent(true, "X", false, game) task.wait(.5)
            game:GetService('VirtualInputManager'):SendKeyEvent(false, "E", false, game)
            game:GetService('VirtualInputManager'):SendKeyEvent(false, "R", false, game)
            game:GetService('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
        end
    end)
end

function equipTool()
	game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(selectedTool))
end


function teleport(ene)
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = ene.CFrame * CFrame.new(0,0,5)
end

function noclip()
    for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

function doQuest()
    for i, v in pairs(game:GetService("ReplicatedStorage").Quests:GetChildren()) do
        local a = string.split(v.Name," ")
        local b = string.split(selectedMob," ")
        if string.find(a[3],b[1]) then
            if game.Players.LocalPlayer.PlayerGui.Menu.QuestFrame.Visible == false or game.Players.LocalPlayer.PlayerGui.Menu.QuestFrame.QuestName.Text ~= v.Name then
                game:GetService("ReplicatedStorage").RemoteEvents.ChangeQuestRemote:FireServer(v)
            end
        end
    end
end

function getNear()
    local nearr,near = math.huge
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart

    for i, v in pairs(game.Workspace.Live:GetChildren()) do
        if v.Name == selectedMob and v:IsA("Model") and (plr.CFrame.p - v.HumanoidRootPart.CFrame.p).Magnitude < nearr then
            near = v.HumanoidRootPart
            nearr = (plr.CFrame.p - v.HumanoidRootPart.CFrame.p).Magnitude
        end
    end
    return near
end

local library = loadstring(game:HttpGetAsync("https://pastebin.com/raw/znibQh36"))()
local MainWindow = library:CreateWindow("DBZ Unleashed")
local FarmingFolder = MainWindow:AddFolder("Farming")
local MiscFolder = MainWindow:AddFolder("Misc")

FarmingFolder:AddToggle({
    text = "Auto Farm", 
    state = false,
    callback = function(v) 
        _G.autofarm = v 

        task.spawn(function()
            while task.wait() do
                if not _G.autofarm then break end
				teleport(getNear())
				click()
				equipTool()
            end
        end)

        task.spawn(function()
            while wait(2) do
                if not _G.autofarm then break end
                doQuest()
            end
        end)
    end
})

FarmingFolder:AddList({
    text = "Select Mob", 
    value = selectedMob,
    values = mob, 
    callback = function(v) 
        selectedMob = v 
    end
})

FarmingFolder:AddList({
    text = "Select Tool", 
    value = selectedTool,
    values = tool, 
    callback = function(v) 
        selectedTool = v 
    end
})

FarmingFolder:AddToggle({
    text = "Auto Skill", 
    state = false,
    callback = function(v) 
        autoSkill = v
    end
})

MiscFolder:AddBind({
    text = "Toggle GUI", 
    key = "LeftControl", 
    callback = function() 
        library:Close()
    end
})

MiscFolder:AddButton({
    text = "Rejoin", 
    callback = function()
        game:GetService'TeleportService':TeleportToPlaceInstance(game.PlaceId,game.JobId,game:GetService'Players'.LocalPlayer)
    end
})


library:Init()