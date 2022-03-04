repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EnemyPath = game:GetService("Workspace").Villains
local SelectedMob = "Goon"
local SelectedEgg = "Blue Tesseract"
local IsTriple = false

local egg = {}
for i, v in pairs(workspace.Eggs:GetChildren()) do
    if not table.find(egg,v.Name) then
        table.insert(egg,v.Name)
    end
end

pcall(function()
    Player.PlayerGui.Notifs:Destroy()
end)

function GetMobs()
    local tbl = {}
    for i, v in pairs(EnemyPath:GetChildren()) do
        if not table.find(tbl,'> ' .. v.Name .. ' World' .. ' <') then
            table.insert(tbl,'> ' .. v.Name .. ' World' .. ' <')
        end
        for i2, v2 in pairs(v:GetChildren()) do
            if not table.find(tbl,v2.Name) then
                table.insert(tbl,v2.Name)
            end
        end
    end
    return tbl
end

function Teleport(mob)
    local plr = Player.Character.HumanoidRootPart
    plr.CFrame = mob.CFrame
end

function CollectCoins()
    task.spawn(function()
        while task.wait() do
            if not _G.Coins then break end
            pcall(function()
                for i, v in pairs(workspace.MouseIgnore.Coins:GetChildren()) do
                    v.CFrame = Player.Character.HumanoidRootPart.CFrame
                end
            end)
        end
    end)
end

function GetNearest()
    local nearr = math.huge
    local near
    local plr = Player.Character.HumanoidRootPart
    
    for i, v in pairs(EnemyPath:GetChildren()) do
        for i2, v2 in pairs(v:GetChildren()) do
            if v2.Name == SelectedMob then
                local mag = (plr.CFrame.p - v2.HumanoidRootPart.CFrame.p).Magnitude
                if mag < nearr then
                    near = v2.HumanoidRootPart
                    nearr = mag
                end
            end
        end
    end
    return near
end

function DoFarm()
    task.spawn(function()
        while task.wait() do
            if not _G.Farm then break end
            pcall(function()  
                local ene = GetNearest()
                Teleport(ene)
                ReplicatedStorage.Events.Hero:FireServer({"Fight",ene.Parent,true})
                repeat task.wait()
                    ReplicatedStorage.Events.Click:FireServer({"DamageClick"})
                until ene.Parent.Humanoid.Health <= 0 or not _G.Farm
            end)
        end
    end)
end

function DoHatch()
    task.spawn(function()
        while task.wait() do
            if not _G.Hatch then break end
            ReplicatedStorage.Events.Purchase:FireServer({"BuyEgg",SelectedEgg,IsTriple})
        end
    end)
end

function BuyWorld()
    task.spawn(function()
        while task.wait() do
            if not _G.World then break end
            for i, v in pairs(EnemyPath:GetChildren()) do
                ReplicatedStorage.Events.Purchase:FireServer({"BuyWorld",v.Name})
            end
        end
    end)
end

local library = loadstring(game:HttpGet("https://pastebin.com/raw/znibQh36"))()
local window = library:CreateWindow("Hero Fighters")

local FarmingFolder = window:AddFolder('Farming')

FarmingFolder:AddToggle({
    text = "Auto Farm", 
    callback = function(v) 
        _G.Farm = v

        DoFarm()
    end
})

FarmingFolder:AddList({
    text = "Select Enemy", 
    values = GetMobs(), 
    callback = function(v) 
        SelectedMob = v
    end
})

FarmingFolder:AddToggle({
    text = "Collect Coins", 
    callback = function(v) 
        _G.Coins = v

        CollectCoins()
    end
})

local HeroFolder = window:AddFolder('Heroes')

HeroFolder:AddToggle({
    text = "Open Egg", 
    callback = function(v) 
        _G.Hatch = v

        DoHatch()
    end
})

HeroFolder:AddList({
    text = "Select Egg", 
    values = egg, 
    callback = function(v) 
        SelectedEgg = v
    end
})

HeroFolder:AddToggle({
    text = "Triple Egg", 
    callback = function(v) 
        IsTriple = v
    end
})

local TeleFolder = window:AddFolder('Teleports')

for i, v in pairs(workspace.Maps:GetChildren()) do
    TeleFolder:AddButton({
        text = v.Name,
        callback = function()
            Teleport(v.TP)
        end
    })
end

local MiscFolder = window:AddFolder('Misc')

MiscFolder:AddToggle({
    text = "Buy New World", 
    callback = function(v) 
        _G.World = v
        
        BuyWorld()
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
    text = "Script by Uzu",
    callback = function()
        setclipboard("Uzu#8575")
    end
})

MiscFolder:AddButton({
    text = "Copy Discord Link",
    callback = function()
        setclipboard("discord.gg/waAsQFwcBn")
    end
})

library:Init()
