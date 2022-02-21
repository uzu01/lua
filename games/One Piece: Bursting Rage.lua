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
            if bringMob then
                v:FindFirstChild("HumanoidRootPart").CFrame = plr.CFrame * CFrame.new(0,0,-2)
                click()
                equipTool()
            else
                plr.CFrame = v:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,5,0) * CFrame.Angles(math.rad(-90),0,0)
                click()
                equipTool()
            end
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
    if bringMob and sethiddenproperty then
        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 1000)
    end
    if _G.autofarm then
        game:GetService("ReplicatedStorage").RemoteEvents.CombatBase:FireServer()		
    end
end)

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/uzu01/lua/main/ui/wallyv2.lua", true))()
local w = library:CreateWindow("Farming")
local b = library:CreateWindow("Stats")
local c = library:CreateWindow("Teleports")
local d = library:CreateWindow("Misc")

w:Toggle("Auto Farm", {flag = "toggle1"}, function(v)
    _G.autofarm = v 

    task.spawn(function()
        while task.wait() do
            if not _G.autofarm then break end
            pcall(function()
                getEnemy()
                doQuest()
                for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if not string.match(v.Name,"BusoArm") then
                        game:GetService("ReplicatedStorage").RemoteEvents.Busoshoku:FireServer()
                    end
                end
            end)
        end
    end)
end)

w:Dropdown("Select Quest", { flag = "dw", list = quest}, function(v)
    selectedQuest = v
end)

w:Toggle("Bring Mob [PC]", {flag = "toggle1"}, function(v)
    bringMob = v 
end)

w:Dropdown("Select Tool", { flag = "dw", list = tool}, function(v)
    selectedTool = v
end)

w:Toggle("Auto Skill", {flag = "toggle1"}, function(v)
    _G.autoskill = v 

    task.spawn(function()
        while task.wait() do
            if not _G.autoskill then break end
            for i, v in pairs(keys) do
                game:GetService('VirtualInputManager'):SendKeyEvent(true, v, false, game)
            end
        end
    end)
end)

b:Toggle("Strength", {flag = "toggle1"}, function(v)
    autoup1 = v 
end)

b:Toggle("Defense", {flag = "toggle1"}, function(v)
    autoup2 = v 
end)

b:Toggle("Sword", {flag = "toggle1"}, function(v)
    autoup3 = v
end)

b:Toggle("Gun", {flag = "toggle1"}, function(v)
    autoup4 = v 
end)

c:Dropdown("Select Island", { flag = "dw", list = island}, function(v)
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").Map.SpawnPoints[v].CFrame
end)

c:Dropdown("Select Npc", { flag = "dw", list = npc}, function(v)
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").Map.NPCs[v].Torso.CFrame
end)

c:Dropdown("Select Shop", { flag = "dw", list = shop}, function(v)
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    for i, v in pairs(game:GetService("Workspace").Map.Shops[v]:GetChildren()) do
        if v:IsA("Part") then
            plr.CFrame = v.CFrame
        end
    end
end)

d:Toggle("Auto Hide Name", {flag = "toggle1"}, function(v)
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
end)

d:Toggle("Collect Chest", {flag = "ads"}, function(v)
    _G.collectchest = v

    task.spawn(function()
        while task.wait() do
            if not _G.collectchest then break end
            if game.Workspace.Map.Chests:FindFirstChild("Chest") then
                for i, v in pairs(game.Workspace.Map.Chests.Chest:GetChildren()) do
                    if v.Name == "ProximityPrompt" then
                        task.wait()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                        fireproximityprompt(v,.1)
                    end
                end
            end
        end
    end)

end)

d:Toggle("Auto Get Fruit", {flag = "toggle1"}, function(v)
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
end)

d:Button("Server Hop", function()
    while wait() do
        local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for i,v in pairs(Servers.data) do
            if v.id ~= game.JobId then
                wait()
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end
end)

d:Button("Script by Uzu", function()
    print("Balls")
end)

d:Button("Copy Discord Link", function()
    setclipboard("discord.gg/waAsQFwcBn")
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
