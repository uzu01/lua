
repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local selectedQuest = "BanditQuest"
local selectedTool = "Combat"
local quest = {}
local tool = {}
local island = {}
local npc = {}
local shop = {}

local keys = {
    "E";
    "R";
    "Z";
    "X";
    "C";
    "V"
}

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

for i, v in pairs(game:GetService("Workspace").Map.SpawnPoints:GetChildren()) do
    table.insert(island,v.Name)
end

for i, v in pairs(game:GetService("Workspace").Map.NPCs:GetChildren()) do
    table.insert(npc,v.Name)
end

for i, v in pairs(game:GetService("Workspace").Map.Shops:GetChildren()) do
    table.insert(shop,v.Name)
end

function equipTool()
    game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(selectedTool))
end

function click()
	local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:Button1Down(Vector2.new(69, 69))		
end

function getEnemy()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    for i, v in pairs(game:GetService("Workspace").Map.Live:GetChildren()) do
        local asd = string.split(selectedQuest,"Quest")
        if string.match(string.lower(v.Name),string.lower(asd[1])) and v:FindFirstChild("HumanoidRootPart") then
            v:FindFirstChild("HumanoidRootPart").CFrame = plr.CFrame * CFrame.new(0,0,-2)
            click()
            equipTool()
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

local mt = getrawmetatable(game)
local oldnc = mt.__namecall
setreadonly(mt,false)

mt.__namecall = function(self,...)
	local method = getnamecallmethod()
	if method == "Kick" and self == game:GetService("Players").LocalPlayer then
		return
	end
	return oldnc(self,...)
end

game:GetService("RunService").Stepped:connect(function()
    game:GetService("ReplicatedStorage").RemoteEvents.CombatBase:FireServer()
    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 1000)
end)

local library = loadstring(game:HttpGetAsync("https://pastebin.com/raw/znibQh36"))()
local window = library:CreateWindow("OP:BR")
local farming_folder = window:AddFolder('Farming')
local stats_folder = window:AddFolder('Stats')
local tele_folder = window:AddFolder("Teleports")
local misc_folder = window:AddFolder('Misc')

farming_folder:AddToggle({
    text = "Auto Farm", 
    callback = function(v) 
        _G.autofarm = v 

        task.spawn(function()
            while task.wait() do
                if not _G.autofarm then break end
                pcall(function()
                    getEnemy()
                    doQuest()
                end)
            end
        end)
    end
})

farming_folder:AddList({
    text = "Select Quest", 
    values = quest, 
    callback = function(v) 
        selectedQuest = v
    end
})

farming_folder:AddList({
    text = "Select Tool", 
    values = tool, 
    callback = function(v) 
        selectedTool = v
    end
})

farming_folder:AddToggle({
    text = "Auto Skill", 
    callback = function(v) 
        _G.autoskill = v 

        task.spawn(function()
            while task.wait() do
                if not _G.autoskill then break end
                for i, v in pairs(keys) do
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, v, false, game)
                end
            end
        end)
    end
})

stats_folder:AddToggle({
    text = "Strength", 
    callback = function(v) 
        autoup1 = v
    end
})

stats_folder:AddToggle({
    text = "Defense", 
    callback = function(v) 
        autoup2 = v
    end
})

stats_folder:AddToggle({
    text = "Sword", 
    callback = function(v) 
        autoup3 = v 
    end
})

stats_folder:AddToggle({
    text = "Gun", 
    callback = function(v) 
        autoup4 = v
    end
})

tele_folder:AddList({
    text = "Select Island",
    values = island,
    callback = function(v)
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace").Map.SpawnPoints[v].CFrame
    end
})

tele_folder:AddList({
    text = "Select Npc",
    values = npc,
    callback = function(v)
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace").Map.NPCs[v].Torso.CFrame
    end
})

tele_folder:AddList({
    text = "Select Shop",
    values = shop,
    callback = function(v)
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        for i, v in pairs(game:GetService("Workspace").Map.Shops[v]:GetChildren()) do
            if v:IsA("Part") then
                plr.CFrame = v.CFrame
            end
        end
    end
})

misc_folder:AddToggle({
    text = "Auto Hide NameTag", 
    callback = function(v) 
        _G.autohide = v
        
        task.spawn(function()
            while task.wait() do
                if not _G.autohide then break end            
                pcall(function()
                    if game.Players.LocalPlayer.Character.Head.NameDisplay then
                        game.Players.LocalPlayer.Character.Head.NameDisplay:Destroy()
                    end
                end)
            end
        end)   
    end
})

misc_folder:AddToggle({
    text = "Auto Get Fruit", 
    callback = function(v) 
        _G.getitem = v
        
        task.spawn(function()
            while task.wait() do
                if not _G.getitem then break end
                pcall(function()
                    for i, v in pairs(game.Workspace:GetChildren()) do
                        if v:IsA("Tool") then
                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                        end
                    end
                end)
            end
        end)    
    end
})

misc_folder:AddBind({
    text = "Toggle GUI", 
    key = "LeftControl", 
    callback = function() 
        library:Close()
    end
})
 
misc_folder:AddButton({
    text = "Script by Uzu",
    callback = function()
        print('a')
    end
})
 
misc_folder:AddButton({
    text = "Discord",
    callback = function()
        setclipboard("discord.gg/waAsQFwcBn")
    end
})

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

library:Init()
