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
local mob = {"-- Select Mob --"}
local tool = {"-- Select Tool --"}
local players = {}

function check(a,b)
	for i, v in pairs(b) do
		if v == a then
			return true
		end
	end
end

for i, v in pairs(game.Players:GetPlayers()) do
	table.insert(players,v.Name)
end

for i, v in pairs(game.Workspace.Lives:GetChildren()) do
	if v:IsA("Model") and not check(v.Name,players) and not table.find(mob,v.Name) then
		table.insert(mob,v.Name)
		table.sort(mob)
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
        VIM:SendKeyEvent(true, "Z", false, game)
        VIM:SendKeyEvent(true, "X", false, game)
        VIM:SendKeyEvent(true, "C", false, game)
        VIM:SendKeyEvent(true, "V", false, game) task.wait(.5)
        VIM:SendKeyEvent(false, "Z", false, game)
        VIM:SendKeyEvent(false, "X", false, game)
        VIM:SendKeyEvent(false, "C", false, game)
        VIM:SendKeyEvent(false, "V", false, game)
    end)
end

local library = loadstring(game:HttpGet("https://pastebin.com/raw/Uz6HijUN", true))()
local w = library:CreateWindow("Last Pirates")

w:Section("Farming")

w:Toggle("Enabled", {flag = "a"}, function(a)
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
                        plr.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,7.8,0) * CFrame.Angles(math.rad(-90),0,0)
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

w:Dropdown("Select Tool", { flag = "b", list = tool}, function(a)
    selectedTool = a
end)

w:Toggle("Auto Skill", {flag = "v"}, function(a)
    _G.autoSkill = a
end)

w:Section("Stats")

w:Toggle("Melee",{flag = b}, function(a)
	_G.Melee = a
	
	task.spawn(function()
		while task.wait() do
			if not _G.Melee then break end
			game:GetService("ReplicatedStorage").okStats:FireServer(1,"1")
		end
	end)
end)

w:Toggle("Sword",{flag = b}, function(a)
	_G.Sword = a
	
	task.spawn(function()
		while task.wait() do
			if not _G.Sword then break end
			game:GetService("ReplicatedStorage").okStats:FireServer(1,"2")
		end
	end)
end)

w:Toggle("Defense",{flag = b}, function(a)
	_G.Defense = a
	
	task.spawn(function()
		while task.wait() do
			if not _G.Defense then break end
			game:GetService("ReplicatedStorage").okStats:FireServer(1,"3")
		end
	end)
end)

w:Toggle("Devil Fruit",{flag = b}, function(a)
	_G.Devil = a
	
	task.spawn(function()
		while task.wait() do
			if not _G.Devil then break end
			game:GetService("ReplicatedStorage").okStats:FireServer(1,"4")
		end
	end)
end)

w:Section("Script by Uzu")

w:Button("discord.gg/waAsQFwcBn",function()
    setclipboard(tostring("discord.gg/waAsQFwcBn"))
end)