
print("Last Update: 2/12/22, 11:31 PM PST")

repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local area = {}
local boss_area = {}

local autocollect = false
local selected_type = "Teleport"
local selected_mob_type = "Nearest"

for i, v in pairs(game:GetService("Workspace").Fight:GetChildren()) do
    if string.find(v.Name,"FightArea") and not table.find(area,v.Name)then
        table.insert(area,v.Name)
    end
end

for i, v in pairs(game:GetService("Workspace").Fight:GetChildren()) do
    if v:FindFirstChild("BossTeleports") and not table.find(boss_area,v.Name) then
        table.insert(boss_area,v.Name)
    end
end

for i, v in pairs(game:GetService("ReplicatedStorage").CommonLogic.Fight.Models:GetChildren()) do
    if string.find(v.Name,"FightArea") then
        table.insert(area,v.Name)
    end
end

for i, v in pairs(game:GetService("ReplicatedStorage").CommonLogic.Fight.Models:GetChildren()) do
    if v:FindFirstChild("BossTeleports") and not table.find(boss_area,v.Name) then
        table.insert(boss_area,v.Name)
    end
end

table.sort(area)
table.sort(boss_area)

local selected_area = area[1]
local selected_boss_area = boss_area[1]
local selected_gamble_area = area[1]

function getHighest()
    local high = {}
    for i, v in pairs(game:GetService("Workspace").Fight.Chests:GetChildren()) do
        for x, y in pairs(game.Workspace.Fight[selected_area].Root:GetChildren()) do
            if v.Name == y.Name then
                table.insert(high,v.ChestHp.Value)
                table.sort(high, function(a,b) return a > b end)            
            end
        end
    end
 
    for a, b in pairs(game:GetService("Workspace").Fight.Chests:GetChildren()) do
        for x, y in pairs(game.Workspace.Fight[selected_area].Root:GetChildren()) do
            if b.Name == y.Name and high[1] == b.ChestHp.Value then
                return b.Name
            end
        end
    end    
end
 
function getMid()
    local mid = {}
    for i, v in pairs(game:GetService("Workspace").Fight.Chests:GetChildren()) do
        for x, y in pairs(game.Workspace.Fight[selected_area].Root:GetChildren()) do
            if v.Name == y.Name then
                table.insert(mid,v.ChestHp.Value)
                table.sort(mid, function(a,b) return a < b end)            
            end
        end
    end
 
    for a, b in pairs(game:GetService("Workspace").Fight.Chests:GetChildren()) do
        for x, y in pairs(game.Workspace.Fight[selected_area].Root:GetChildren()) do
            if b.Name == y.Name and mid[tonumber(string.format("%.g",#mid/2))] == b.ChestHp.Value then
                return b.Name
            end
        end
    end  
end
 
function getLowest()
    local low = {}
    for i, v in pairs(game:GetService("Workspace").Fight.Chests:GetChildren()) do
        for x, y in pairs(game.Workspace.Fight[selected_area].Root:GetChildren()) do
            if v.Name == y.Name then
                table.insert(low,v.ChestHp.Value)
                table.sort(low, function(a,b) return a < b end)            
            end
        end
    end
 
    for a, b in pairs(game:GetService("Workspace").Fight.Chests:GetChildren()) do
        for x, y in pairs(game.Workspace.Fight[selected_area].Root:GetChildren()) do
            if b.Name == y.Name and low[1] == b.ChestHp.Value then
                return b.Name
            end
        end
    end  
end
 
function getNear()
    local nearr,near = math.huge
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
 
    for i, v in pairs(game:GetService("Workspace").Fight.ClientChests:GetChildren()) do
        if (plr.Position - v.Root.Position).Magnitude < nearr then
            near = v
            nearr = (plr.Position - v.Root.Position).Magnitude
        end
    end
 
    return near
end

function getNearBoss()
    local nearr,near = math.huge
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
 
    for i, v in pairs(game:GetService("Workspace").Fight.ClientChests:GetChildren()) do
        if string.match(v.Name,"Boss") and (plr.Position - v.Root.Position).Magnitude < nearr then
            near = v.Root
            nearr = (plr.Position - v.Root.Position).Magnitude
        end
    end
 
    return near
end
 
function getQiChest()
    for i, v in pairs(game:GetService("Workspace").Fight.Chests:GetChildren()) do
        for x, y in pairs(game.Workspace.Fight[selected_area].Root:GetChildren()) do
            if v.Name == y.Name and string.find(v.Value,"ChestBaoXiang") then
                return v.Name
            end
        end
    end
end

function doSomething(mob)
    local char,plr = game.Players.LocalPlayer.Character
    local plr = char.HumanoidRootPart

    if selected_type == "Teleport" then
        plr.CFrame = mob.CFrame * CFrame.new(0,0,5)
    elseif selected_type == "Tween" then
        local a = game:GetService("TweenService"):Create(plr, TweenInfo.new(.5, Enum.EasingStyle.Linear), {CFrame = mob.CFrame * CFrame.new(0,0,5)})
        a:Play()
    elseif selected_type == "Walk" then
        char.Humanoid:MoveTo(mob.Position)
    end
end

function teleport(part)
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    hrp.CFrame = part.CFrame * CFrame.new(0,2,5)
end

_G.autofarm = false
_G.autogamble = false
_G.autoboss = false

game:GetService("RunService").Stepped:Connect(function()
    if _G.autofarm and selected_type ~= "Walk" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end
end)

local library = loadstring(game:HttpGet("https://pastebin.com/raw/Uz6HijUN", true))()
local w = library:CreateWindow("Farming")
local b = library:CreateWindow("Boss")
local c = library:CreateWindow("Gamble")
local d = library:CreateWindow("Misc")

w:Toggle("Chest Farm", {flag = "toggle1"}, function(v)
    _G.autofarm = v

    task.spawn(function()
        while task.wait() do
            if not _G.autofarm then break end
            pcall(function()
                local chest
                local chestLoc
                if selected_mob_type == "Nearest" then
                    chest = getNear()
                    chestLoc = chest.Root
                elseif selected_mob_type == "High Hp" then
                    chest = getHighest()
                    chestLoc = game:GetService("Workspace").Fight.ClientChests[tostring(chest)].Root
                elseif selected_mob_type == "Mid Hp" then
                    chest = getMid()
                    chestLoc = game:GetService("Workspace").Fight.ClientChests[tostring(chest)].Root
                elseif selected_mob_type == "Low Hp" then
                    chest = getLowest()
                    chestLoc = game:GetService("Workspace").Fight.ClientChests[tostring(chest)].Root
                elseif selected_mob_type == "Qi Chest" then
                    chest = getQiChest()
                    chestLoc = game:GetService("Workspace").Fight.ClientChests[tostring(chest)].Root
                end
                
                doSomething(chestLoc)

                repeat task.wait(.5)
                    doSomething(chestLoc)
                    fireclickdetector(chestLoc.ClickDetector,69)
                until not _G.autofarm or not game:GetService("Workspace").Fight.ClientChests[chest].Root 
            end)
        end
    end)
end)

w:Dropdown("Farming Type", { flag = "a", list = {"Teleport","Tween","Walk"}}, function(v)
    selected_type = v
end)

w:Dropdown("Chest Type", { flag = "a", list = {"Nearest","High Hp","Mid Hp","Low Hp","Qi Chest"}}, function(v)
    selected_mob_type = v
end)

w:Dropdown("Select Area", { flag = "a", list = area}, function(v)
    selected_area = v
end)

w:Toggle("Collect Rewards", {flag = "toggle1"}, function(v)
    autocollect = v

    local d = require(game:GetService("ReplicatedStorage").CommonConfig.CfgGlobal)
    
    if autocollect then
        d.RewardCollectRadius = 9e99
    else 
        d.RewardCollectRadius = 12
    end
end)

b:Toggle("Boss Farm", {flag = "toggle1"}, function(v)
    _G.autoboss = v

    task.spawn(function()
        while task.wait() do
            if not _G.autoboss then break end
            pcall(function()
                if open_chest then
                    local area_number = string.match(selected_boss_area,"%d")
                    game:GetService("ReplicatedStorage").CommonLibrary.Tool.RemoteManager.Funcs.DataPullFunc:InvokeServer("ArenaOpenChestChannel", area_number-1, "c1", false)
                end
                wait(1)
                game:GetService("ReplicatedStorage").CommonLibrary.Tool.RemoteManager.Funcs.DataPullFunc:InvokeServer("ArenaTeleportLeaveChannel", "Out")   
                wait(1)
                teleport(game:GetService("Workspace").Fight[tostring(selected_boss_area)].BossTeleports.Platform.Platform)
                wait(1)
                game:GetService("ReplicatedStorage").CommonLibrary.Tool.RemoteManager.Events.BossRoomStartEvent:FireServer("room1")                    
                game:GetService("ReplicatedStorage").CommonLibrary.Tool.RemoteManager.Events.BossRoomStartEvent:FireServer("room2") 
                wait(2)                    
                local near = getNearBoss()
                teleport(near)
                wait(.7)
                fireclickdetector(near.ClickDetector,69)
                repeat task.wait(.5) 
                    teleport(near)
                    fireclickdetector(near.ClickDetector,69)
                until not near or not _G.autoboss
            end)
        end
    end)
end)

b:Dropdown("Select Area", { flag = "a", list = boss_area}, function(v)
    selected_boss_area = v
end)

b:Toggle("Open Boss Chest", {flag = "toggle1"}, function(v)
    open_chest = v
end)

c:Toggle("Auto Gamble", {flag = "toggle1"}, function(v)
    autogamble = v
 
    task.spawn(function()
        while task.wait() do
            if not autogamble then break end
            for i, v in pairs(game.Workspace.Fight[selected_gamble_area].Gamble:GetChildren()) do
                if v:IsA("Part") then
                    teleport(v)
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, "E", false, game)
                    game:GetService('VirtualInputManager'):SendKeyEvent(false, "E", false, game)
                end
            end
        end
    end) 
end)

c:Dropdown("Select Area", {flag = "a", list = area}, function(v)
    selected_gamble_area = a
end)

d:Button("Auto Hide Claimed Spells", function()
    local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
    PlayerGui.ChildAdded:Connect(function(asd)
        if asd.Name == "ScreenRwdGui" then
            asd:Destroy()
            wait(2)
            PlayerGui.MainGui.ScreenGui.Enabled = true
        end
    end)
end)

d:Button("Unlock Some Gamepass", function()
    local a = require(game:GetService("ReplicatedStorage").CommonLogic.Model.GamePasses)
    a.HasGamePass = function() return true end
    game:GetService("Players").LocalPlayer.PlayerGui.MainGui.ScreenGui.MainLeftBarView.FrameChild4.BgTeleport.ImgMask.Visible = false
end)

d:Button("Invisible", function()
    pcall(function()
        for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("MeshPart") and v.Name ~= "Head" and v.Name ~= "LowerTorso" and v.Name ~= "UpperTorso" then
                v:Destroy()
            end
        end
        game.Players.LocalPlayer.Character.Humanoid.Animator:Destroy()
        game.Players.LocalPlayer.Character.LowerTorso.Root:Destroy()
        game.Players.LocalPlayer.Character.NameTag:Destroy() 
    end)
end)

d:Button("Reload Script", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/Bd6R0GaC"))()
end)

d:Button("Script by Uzu", function()
    setclipboard("discord.gg/waAsQFwcBn")
end)

d:Button("Discord", function()
    setclipboard("discord.gg/waAsQFwcBn")
end)
