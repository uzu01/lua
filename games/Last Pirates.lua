repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.autofarm = false
_G.autoSkill = false
_G.Melee = false
_G.Sword = false
_G.Defense = false
_G.Devil = false

local selectedMob = "Bandit [Lv:5]"
local selectedTool = "Combat"
local mob = {}
local tool = {}
local keys = {
    "Z";
    "X";
    "C";
    "V"
}

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

function click()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(69, 69))		
end

function equipTool()
	game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(selectedTool))
end

function startQuest()
    task.spawn(function()
        if game:GetService("Players").LocalPlayer.PlayerGui.QuestGui.Enabled == false then
            lol = string.split(selectedMob," [")
            game:GetService("ReplicatedStorage").FuncQuest:InvokeServer(lol[1])
        end
    end)
end

function autoHaki()
    if not game.Players.LocalPlayer.Character:FindFirstChild("Buso") then
        game:GetService("ReplicatedStorage").Haki:FireServer("Buso")
        game:GetService("ReplicatedStorage").HakiRemote:FireServer("Ken")
    end
end

function useSkill()
    task.spawn(function()
        local VIM = game:GetService('VirtualInputManager')

        for i, v in pairs(keys) do
            VIM:SendKeyEvent(true, v, false, game) task.wait()
            VIM:SendKeyEvent(true, v, false, game)
        end
    end)
end

local library = loadstring(game:HttpGet("https://pastebin.com/raw/Uz6HijUN", true))()
local w = library:CreateWindow("Farming")
local b = library:CreateWindow("Stats")
local c = library:CreateWindow("Shop")
local d = library:CreateWindow("Teleports")
local e = library:CreateWindow("Misc")

w:Toggle("Auto Farm", {flag = "a"}, function(a)
	_G.autofarm = a
	
	task.spawn(function()
		while task.wait() do
			if not _G.autofarm then break end
			pcall(function()
				local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
				startQuest()
                autoHaki()
				for i, v in pairs(game.Workspace.Lives:GetChildren()) do
					if v.Name == selectedMob and v:FindFirstChild("Humanoid") then
                        plr.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,7,0) * CFrame.Angles(math.rad(-90),0,0)
                        equipTool()
                        click()
                        if _G.autoSkill then
                            useSkill()
                        end
					end
				end
			end)
		end
	end)
end)

w:Dropdown("Select Mob", { flag = "b", list = mob}, function(a)
	selectedMob = a
end)

w:Button("Refresh Mob", function()
    table.clear(mob)
    for i, v in pairs(game:GetService("Workspace").Lives:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Folder") and not table.find(mob,v.Name) then
            table.insert(mob,v.Name)
        end
    end
end)

w:Dropdown("Select Tool", { flag = "b", list = tool}, function(a)
    selectedTool = a
end)

w:Button("Refresh Tool", function()
    table.clear(tool)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            table.insert(tool,v.Name)
        end
    end
end)

w:Toggle("Auto Skill", {flag = "v"}, function(a)
    _G.autoSkill = a
end)

b:Toggle("Melee",{flag = b}, function(a)
	_G.Melee = a
	
	task.spawn(function()
		while task.wait() do
			if not _G.Melee then break end
			game:GetService("ReplicatedStorage").okStats:FireServer(1,"1")
		end
	end)
end)

b:Toggle("Sword",{flag = b}, function(a)
	_G.Sword = a
	
	task.spawn(function()
		while task.wait() do
			if not _G.Sword then break end
			game:GetService("ReplicatedStorage").okStats:FireServer(1,"2")
		end
	end)
end)

b:Toggle("Defense",{flag = b}, function(a)
	_G.Defense = a
	
	task.spawn(function()
		while task.wait() do
			if not _G.Defense then break end
			game:GetService("ReplicatedStorage").okStats:FireServer(1,"3")
		end
	end)
end)

b:Toggle("Devil Fruit",{flag = b}, function(a)
	_G.Devil = a
	
	task.spawn(function()
		while task.wait() do
			if not _G.Devil then break end
			game:GetService("ReplicatedStorage").okStats:FireServer(1,"4")
		end
	end)
end)

c:Button("Buso Haki", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").HakiSeller.AAA.BusoHaki.CFrame
end)

c:Button("Ken Haki", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = CFrame.new(-6278.6826171875, 32.993167877197, 3832.9084472656)
end)

c:Button("Random Color Haki", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace")["Random Color haki"]["Random Color haki"].Head.CFrame
end)

c:Button("Random Fruit", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").RandomFruit.HumanoidRootPart.CFrame
end)

c:Button("Black Leg", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").Blackleg.Click.CFrame
end)

c:Button("Pole", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace")["Pole Seller"].PoleClick.CFrame
end)

c:Button("Cutlass", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").cutlass.Click.CFrame
end)

c:Button("Bisento", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").Bisento.Part.CFrame
end)

c:Button("Bisento v2", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace")["BisenV2 NPC"].Model.Model.BisenV2["Right Leg"].CFrame
end)

c:Button("Saber", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = CFrame.new(3138.58984375, 71.283683776855, -2338.1533203125)
end)

c:Button("Shisui", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").MISC.Handle.CFrame
end)

c:Button("Katana", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").KatanaShop.KatanaShop.Head.CFrame
end)

d:Button("Factory", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = game:GetService("Workspace").Factory.Block.CFrame
end)

for i, v in pairs(game:GetService("Workspace")["Spawn island"]:GetChildren()) do
    d:Button(v.Name,function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = v.CFrame
    end)
end

e:Button("Inventory", function()
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = CFrame.new(413.05569458008, 40.559078216553, -1830.5759277344)
end)

e:Button("Serverhop", function()
    while task.wait() do
        local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for i,v in pairs(Servers.data) do
            if v.id ~= game.JobId then
                wait()
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end
end)

e:Button("Script by Uzu", function()
    print('a')
end)

e:Button("Discord",function()
    setclipboard(tostring("discord.gg/waAsQFwcBn"))
end)

for i, v in pairs(game:GetService("Players").LocalPlayer.GPOwned:GetChildren()) do
    if v:IsA("BoolValue") then
        v.Value = true
    end
end
