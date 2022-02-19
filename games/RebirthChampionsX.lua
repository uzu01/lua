
local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local isTriple = "Single"

function GetNearestEgg()
    local nearr = math.huge
    local near
    local plr = Player.Character.HumanoidRootPart

    for i, v in pairs(game:GetService("Workspace").Scripts.Eggs:GetChildren()) do
        if (plr.CFrame.p - v.Egg.Egg.CFrame.p).Magnitude < nearr then
            near = v.Name
            nearr = (plr.CFrame.p - v.Egg.Egg.CFrame.p).Magnitude
        end
    end
    return near
end

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()
local w = library:CreateWindow("Rebirth Champions X")

local b = w:CreateFolder("Farming")
local c = w:CreateFolder("Pet")
local d = w:CreateFolder("Shop")
local e = w:CreateFolder("Teleports")
local f = w:CreateFolder("Misc")

b:Button("Rebirth Gamepass",function()
    for i, v in pairs(Player.Passes:GetChildren()) do
        v.Value = true
    end
end)

b:Toggle("Auto Click",function(a)
    autoclick = a
end)

c:Toggle("Open Nearest Egg",function(a)
    autoegg = a
end)

c:Toggle("Triple Egg",function(a)
    asd = a

    if asd then
        isTriple = "Triple"
    else
        isTriple = "Single"
    end
end)

c:Toggle("Equip Best (10 sec)",function(a)
    autobest = a
end)

c:Toggle("Auto Craft (3 sec)",function(a)
    autocraft = a
end)

d:Toggle("Auto Upgrade",function(a)
    autoupgrade = a
end)

d:Toggle("Buy Potion",function(a)
    autopotion = a
end)

for i, v in pairs(game:GetService("Workspace").Scripts.TeleportTo:GetChildren()) do
    e:Button(v.Name, function()
        Player.Character.HumanoidRootPart.CFrame = v.CFrame
    end)
end

f:Button("Script by Uzu", function()
    setclipboard("Uzu#6389")
end)

f:Button("Discord", function()
    setclipboard("discord.gg/waAsQFwcBn")
end)

f:DestroyGui()

task.spawn(function()
    while task.wait() do
        if autoclick then
            ReplicatedStorage.Events.Click:FireServer()
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if autoegg then
            ReplicatedStorage.Functions.Unbox:InvokeServer(GetNearestEgg(),isTriple)
        end
    end
end)

task.spawn(function()
    while task.wait(10) do
        if autobest then
            firesignal(Player.PlayerGui.MainUI.PetsFrame.Additional.EquipBest.Click.MouseButton1Up)
        end
    end
end)

task.spawn(function()
    while task.wait(3) do
        if autocraft then
            firesignal(Player.PlayerGui.MainUI.PetsFrame.Additional.CraftAll.Click.MouseButton1Up)
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if autoupgrade then
            for i, v in pairs(require(ReplicatedStorage.Modules.UpgradesShop)) do
                ReplicatedStorage.Functions.Upgrade:InvokeServer(tostring(i))
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if autopotion then
            for i, v in pairs(require(ReplicatedStorage.Modules.Potions)) do
                ReplicatedStorage.Events.Potion:FireServer(tostring(i))
            end
        end
    end
end)
