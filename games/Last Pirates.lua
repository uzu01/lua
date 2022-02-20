repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.settings = {
    autofarm = false,
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
local selectedMob = "Bandit [Lv:5]"
local mob = {}
local tool = {}
local island = {}

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

for i, v in pairs(game:GetService("Workspace")["Spawn island"]:GetChildren()) do
    table.insert(island,v)
end

local selectedTool = tool[1]

function click()
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(69, 69))		
end

function equipTool()
	Player.Character.Humanoid:EquipTool(Player.Backpack:FindFirstChild(selectedTool))
end

function startQuest()
    task.spawn(function()
        if Player.PlayerGui.QuestGui.Enabled == false then
            lol = string.split(selectedMob," [")
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

local lib = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Wait = lib.subs.Wait

local w = lib:CreateWindow({
    Name = "Last Pirates",
    Themeable = {
       Info = "Script by Uzu#6389"
    }
})

local GeneralTab = w:CreateTab({
    Name = "General"
})

local FarmingSection = GeneralTab:CreateSection({
    Name = "Farming"
})

FarmingSection:AddToggle({
    Name = "Auto Farm",
    Callback = function(v)
        _G.settings.autofarm = v
	
        task.spawn(function()
            while task.wait() do
                if not _G.settings.autofarm then break end
                pcall(function()
                    local plr = Player.Character.HumanoidRootPart
                    startQuest()
                    autoHaki()
                    for i, v in pairs(game.Workspace.Lives:GetChildren()) do
                        if v.Name == selectedMob and v:FindFirstChild("Humanoid") then
                            plr.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,7,0) * CFrame.Angles(math.rad(-90),0,0)
                            equipTool()
                            click()
                        end
                    end
                end)
            end
        end)
    end
})

FarmingSection:AddDropdown({
    Name = "Select Mob",
    List = mob,
    Callback = function(v)
        selectedMob = v
    end
})

FarmingSection:AddButton({
    Name = "Refresh Mob",
    Callback = function()
        table.clear(mob)

        for i, v in pairs(game:GetService("Workspace").Lives:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Folder") and not table.find(mob,v.Name) then
                table.insert(mob,v.Name)
            end
        end
    end
})

FarmingSection:AddDropdown({
    Name = "Select Tool",
    List = tool,
    Callback = function(v)
        selectedTool = v
    end
})

FarmingSection:AddButton({
    Name = "Refresh Tool",
    Callback = function()
        table.clear(tool)

        for i, v in pairs(Player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                table.insert(tool,v.Name)
            end
        end
    end
})

FarmingSection:AddToggle({
    Name = "Auto Skill",
    Callback = function(v)
        _G.settings.autoskill = v
	
        task.spawn(function()
            while task.wait() do
                if not _G.settings.autoskill then break end
                useSkill()
            end
        end)
    end
})

local SkillSection = GeneralTab:CreateSection({
    Name = "Skill"
})

SkillSection:AddToggle({
    Name = "Melee",
    Callback = function(v)
        _G.settings.melee = v
	
        task.spawn(function()
            while task.wait() do
                if not _G.settings.melee then break end
                ReplicatedStorage.okStats:FireServer(1,"1")
            end
        end)
    end
})

SkillSection:AddToggle({
    Name = "Sword",
    Callback = function(v)
        _G.settings.sword = v
	
        task.spawn(function()
            while task.wait() do
                if not _G.settings.sword then break end
                ReplicatedStorage.okStats:FireServer(1,"2")
            end
        end)
    end
})

SkillSection:AddToggle({
    Name = "Defense",
    Callback = function(v)
        _G.settings.defense = v
	
        task.spawn(function()
            while task.wait() do
                if not _G.settings.defense then break end
                ReplicatedStorage.okStats:FireServer(1,"3")
            end
        end)
    end
})

SkillSection:AddToggle({
    Name = "Devil Fruit",
    Callback = function(v)
        _G.settings.devil = v
	
        task.spawn(function()
            while task.wait() do
                if not _G.settings.devil then break end
                ReplicatedStorage.okStats:FireServer(1,"4")
            end
        end)
    end
})

local ShopSection = GeneralTab:CreateSection({
    Name = "Shop",
    Side = "Right"
})

ShopSection:AddButton({
    Name = "Buso Haki",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace").HakiSeller.AAA.BusoHaki.CFrame
    end
})

ShopSection:AddButton({
    Name = "Ken Haki",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = CFrame.new(-6278.6826171875, 32.993167877197, 3832.9084472656)
    end
})

ShopSection:AddButton({
    Name = "Random Color Haki",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace")["Random Color haki"]["Random Color haki"].Head.CFrame
    end
})

ShopSection:AddButton({
    Name = "Random Fruit",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace").RandomFruit.HumanoidRootPart.CFrame
    end
})

ShopSection:AddButton({
    Name = "Black Leg",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace").Blackleg.Click.CFrame
    end
})

ShopSection:AddButton({
    Name = "Pole",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace")["Pole Seller"].PoleClick.CFrame
    end
})

ShopSection:AddButton({
    Name = "Cutlass",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace").cutlass.Click.CFrame
    end
})

ShopSection:AddButton({
    Name = "Bisento",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace").Bisento.Part.CFrame
    end
})

ShopSection:AddButton({
    Name = "Bisento v2",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace")["BisenV2 NPC"].Model.Model.BisenV2["Right Leg"].CFrame
    end
})

ShopSection:AddButton({
    Name = "Saber",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = CFrame.new(3138.58984375, 71.283683776855, -2338.1533203125)
    end
})

ShopSection:AddButton({
    Name = "Shisui",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace").MISC.Handle.CFrame
    end
})

ShopSection:AddButton({
    Name = "Katana",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace").KatanaShop.KatanaShop.Head.CFrame
    end
})

local TeleSection = GeneralTab:CreateSection({
    Name = "Teleports"
})

TeleSection:AddButton({
    Name = "Factory",
    Callback = function()
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = game:GetService("Workspace").Factory.Block.CFrame
    end
})

TeleSection:AddDropdown({
    Name = "Select Island",
    List = island,
    Callback = function(v)
        local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
        plr.CFrame = v.CFrame
    end
})

local MiscSection = GeneralTab:CreateSection({
    Name = "Misc",
    Side = "Right"
})

MiscSection:AddToggle({
    Name = "Auto Get Devil Fruit",
    Callback = function(v)
        _G.settings.autoget = v
	
        task.spawn(function()
            while task.wait() do
                if not _G.autoget then break end
                for i, v in pairs(game.Workspace.Maps:GetDescendants()) do
                    if v.Name == "ProximityPrompt" then
                        local plr = Player.Character.HumanoidRootPart
                        plr.CFrame = v.Parent.CFrame    
                        fireproximityprompt(v)
                    end
                end
            end 
        end)
    end
})

MiscSection:AddButton({
    Name = "Inventory",
    Callback = function()
        local plr = Player.Character.HumanoidRootPart
        plr.CFrame = CFrame.new(413.05569458008, 40.559078216553, -1830.5759277344)
    end
})

MiscSection:AddButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,Player)
    end
})

MiscSection:AddButton({
    Name = "Serverhop",
    Callback = function()
        while task.wait() do
            local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
            for i,v in pairs(Servers.data) do
                if v.id ~= game.JobId then
                    task.wait()
                    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, v.id)
                end
            end
        end
    end
})

MiscSection:AddButton({
    Name = "Serverhop Low Server",
    Callback = function()
        while task.wait() do
            local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
            for i,v in pairs(Servers.data) do
                if v.id ~= game.JobId and v.playing <= 3 then
                    task.wait()
                    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, v.id)
                end
            end
        end
    end
})
