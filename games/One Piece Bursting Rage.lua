repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local selectedQuest = "BanditQuest"
local selectedTool = "Combat"
local quest = {}
local tool = {}

for i, v in pairs(game:GetService("Workspace").QuestBoard:GetChildren()) do
    for a, b in pairs(v:GetChildren()) do
        if string.match(b.Name,"Quest") then
            table.insert(quest,b.Name)
        end
    end
end

for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if v:IsA("Tool") then
        table.insert(tool,v.Name)
    end
end

function equipTool()
    game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(selectedTool))
end

function getEnemy()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    for i, v in pairs(game:GetService("Workspace").Map.Live:GetChildren()) do
        local asd = string.split(selectedQuest,"Quest")
        print(asd[1])
        if string.find(v.Name,asd[1]) and v:FindFirstChild("HumanoidRootPart") then
            v:FindFirstChild("HumanoidRootPart").CFrame = plr.CFrame * CFrame.new(0,0,-2)
        end
    end
end

function doQuest()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    if _G.autofarm and not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("QuestsGUI") then
        for i, v in pairs(game:GetService("Workspace").QuestBoard:GetChildren()) do
            for a, b in pairs(v:GetChildren()) do
                if b.Name == selectedQuest then
                    plr.CFrame = b.CFrame
                    fireproximityprompt(b.ProximityPrompt)
                end
            end
        end
    end
end

game:GetService("RunService").Stepped:connect(function()
    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 1000)
end)

local library = loadstring(game:HttpGet("https://pastebin.com/raw/Uz6HijUN", true))()
local w = library:CreateWindow("Farming")
local b = library:CreateWindow("Stats")

w:Toggle("Enabled", {flag = "a"}, function(v)
    _G.autofarm = v

    task.spawn(function()
        while task.wait() do
            if not _G.autofarm then break end
            game:GetService("ReplicatedStorage").RemoteEvents.CombatBase:FireServer()
            getEnemy()
            equipTool()
            doQuest()
        end
    end)
end)

w:Dropdown("Select Quest", { flag = "dw", list = quest}, function(v)
    selectedQuest = v
end)

w:Dropdown("Select Tool", { flag = "dw", list = tool}, function(v)
    selectedTool = v
end)

b:Toggle("Strength", { flag = "a"}, function(v)
    autoup1 = v
end)    

b:Toggle("Defense", { flag = "a"}, function(v)
    autoup2 = v
end)    

b:Toggle("Sword", { flag = "a"}, function(v)
    autoup3 = v
end)    

b:Toggle("Gun", { flag = "a"}, function(v)
    autoup4 = v
end)    

task.spawn(function()
    while task.wait() do
        if autoup1 then
            local args = {
                [1] = game:GetService("Players").LocalPlayer.PlayerValues,
                [2] = game:GetService("Players").LocalPlayer.PlayerValues.StrengthLevel,
                [3] = game:GetService("Players").LocalPlayer.PlayerValues.DefenseLevel,
                [4] = game:GetService("Players").LocalPlayer.PlayerValues.SwordLevel,
                [5] = game:GetService("Players").LocalPlayer.PlayerValues.GunLevel,
                [6] = game:GetService("Players").LocalPlayer.PlayerValues.StrengthLevel,
                [7] = 1
            }

            game:GetService("ReplicatedStorage").RemoteEvents.StatPoint:InvokeServer(unpack(args))
        end
        if autoup2 then
            local args = {
                [1] = game:GetService("Players").LocalPlayer.PlayerValues,
                [2] = game:GetService("Players").LocalPlayer.PlayerValues.StrengthLevel,
                [3] = game:GetService("Players").LocalPlayer.PlayerValues.DefenseLevel,
                [4] = game:GetService("Players").LocalPlayer.PlayerValues.SwordLevel,
                [5] = game:GetService("Players").LocalPlayer.PlayerValues.GunLevel,
                [6] = game:GetService("Players").LocalPlayer.PlayerValues.StrengthLevel,
                [7] = 1
            }
            game:GetService("ReplicatedStorage").RemoteEvents.StatPoint:InvokeServer(unpack(args))
        end
        if autoup3 then
            local args = {
                [1] = game:GetService("Players").LocalPlayer.PlayerValues,
                [2] = game:GetService("Players").LocalPlayer.PlayerValues.StrengthLevel,
                [3] = game:GetService("Players").LocalPlayer.PlayerValues.DefenseLevel,
                [4] = game:GetService("Players").LocalPlayer.PlayerValues.SwordLevel,
                [5] = game:GetService("Players").LocalPlayer.PlayerValues.GunLevel,
                [6] = game:GetService("Players").LocalPlayer.PlayerValues.SwordLevel,
                [7] = 1
            }
            game:GetService("ReplicatedStorage").RemoteEvents.StatPoint:InvokeServer(unpack(args))

        end
        if autoup4 then
            print('a')
        end
    end
end)
