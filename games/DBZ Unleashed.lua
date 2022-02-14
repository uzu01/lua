repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.autofarm = false

local selectedMob = "Thug (lvl. 5)"
local selectedTool = "Strategy to Defeat the Emperor Vegeta"
local mob = {}
local tool = {}
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

for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if v:IsA("Tool") then
        table.insert(tool,v.Name)
    end
end

function click()
    task.spawn(function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        game:GetService("ReplicatedStorage").RemoteEvents.BladeCombatRemote:FireServer(false,plr.CFrame.p,plr.CFrame)
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
        if string.find(string.lower(a[3]),string.lower(b[1])) then
            if game.Players.LocalPlayer.PlayerGui.Menu.QuestFrame.Visible == false or game.Players.LocalPlayer.PlayerGui.Menu.QuestFrame.QuestName.Text ~= v.Name then
                game:GetService("ReplicatedStorage").RemoteEvents.ChangeQuestRemote:FireServer(v)
            end
        end
    end
end

function getEnemy()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart

    for i, v in pairs(game.Workspace.Live:GetChildren()) do
        if v.Name == selectedMob and v:IsA("Model") then
            plr.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
        end
    end
end

function bring()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart

    for i, v in pairs(game.Workspace.Live:GetChildren()) do
        if v.Name == selectedMob and v:IsA("Model") then
            for i2, v2 in pairs(game:GetService("Workspace").QuestMarkers:GetChildren()) do
                local a = string.split(v2.Name," ")
                local b = string.split(selectedMob," ")
                if string.find(string.lower(a[3]),string.lower(b[1])) then
                    plr.CFrame = v2.CFrame
                    v.HumanoidRootPart.CFrame = plr.CFrame * CFrame.new(0,0,-2)
                end
            end
        end
    end
end

game:GetService("RunService").Stepped:Connect(function()
    if bringMob then
        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 1000)
    end
end)


local library = loadstring(game:HttpGet("https://pastebin.com/raw/Uz6HijUN", true))()
local w = library:CreateWindow("Farming")

w:Toggle("Enabled", {flag = "toggle1"}, function(v)
    _G.autofarm = v 

    task.spawn(function()
        while task.wait() do
            if not _G.autofarm then break end
            pcall(function()
                if bringMob then
                    getEnemy()
                    bring()
                    click()
                    equipTool()
                else
                    getEnemy()
                    click()
                    equipTool()
                end
            end)
        end
    end)

    task.spawn(function()
        while true do
            if not _G.autofarm then break end
            pcall(function() doQuest() wait(4) end)
        end
    end)
end)

w:Toggle("Bring Mob [PC]", { flag = "a"}, function(v)
    bringMob = v 
end)

w:Dropdown("Select Mob", { flag = "dw", list = mob}, function(v)
    selectedMob = v 
end)

w:Dropdown("Select Tool", { flag = "dw", list = tool}, function(v)
    selectedTool = v 
end)

w:Toggle("Auto Skill", { flag = "a"}, function(v)
    _G.autoSkill = v 

    task.spawn(function()
        while task.wait() do
            if not _G.autoSkill then break end
            for i, v in pairs(keys) do
                game:GetService('VirtualInputManager'):SendKeyEvent(true, v, false, game)
            end
        end
    end)
end)

w:Button("Discord", function()
    setclipboard("discord.gg/waAsQFwcBn")
end)
