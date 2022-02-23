
local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Player.Character.HumanoidRootPart
local selectedTree = "1"
local tree = {}

for i, v in pairs(game:GetService("Workspace").TargetStorage:GetChildren()) do
    for i2, v2 in pairs(v:GetChildren()) do
        for i3, v3 in pairs(v2:GetChildren()) do
            if v3:IsA("ClickDetector") and not table.find(tree,'Tree '..v.Name.." HP: "..v3.Max_HP.Value) then
                table.insert(tree,'Tree '..v.Name.." HP: "..v3.Max_HP.Value)
            end
        end
    end
end

table.sort(tree ,function(a,b)
    return tonumber(string.match(a,"%d+")) < tonumber(string.match(b,"%d+"))
end)

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/uzu01/lua/main/ui/uwuware.lua"))()
local w = library:CreateWindow("Magic Woodcutter")
local FarmingFolder = w:AddFolder("Farming")
local ShopFolder = w:AddFolder("Shop")
local MiscFolder = w:AddFolder("Misc")

FarmingFolder:AddToggle({
    text = "Farm Wood", 
    state = false,
    callback = function(v) 
        _G.farmwood = v

        task.spawn(function()
            while task.wait() do
                if not _G.farmwood then break end
                pcall(function()
                    local plr = Player.Character.HumanoidRootPart
                    for i, v in pairs(game:GetService("Workspace").TargetStorage[selectedTree]:GetChildren()) do
                        if i == 1 and v:FindFirstChild("EVOLUTION_SERIES_ClickDetector") then
                            plr.CFrame = CFrame.new(v['EVOLUTION_SERIES_ClickDetector'].TargetPos.Value)
                            fireclickdetector(v["EVOLUTION_SERIES_ClickDetector"])
                        end
                    end
                end)
            end
        end)
    end
})

FarmingFolder:AddList({
    text = "Select Tree", 
    values = tree, 
    callback = function(v) 
        selectedTree = string.match(v,"%d+")
    end
})


FarmingFolder:AddToggle({
    text = "Auto Sell", 
    state = false,
    callback = function(v) 
        _G.autosell = v

        task.spawn(function()
            while task.wait() do
                if not _G.autosell then break end
                pcall(function()
                    local plr = Player.Character.HumanoidRootPart
                    firetouchinterest(plr,game:GetService("Workspace").Map["Sell_Part"].TouchInterest.Parent,0)
                    firetouchinterest(plr,game:GetService("Workspace").Map["Sell_Part"].TouchInterest.Parent,1)
                end)
            end
        end)
    end
})

ShopFolder:AddToggle({
    text = "Auto Upgrade Axe", 
    state = false,
    callback = function(v) 
        _G.axe = v

        task.spawn(function()
            while task.wait(1) do
                if not _G.axe then break end
                ReplicatedStorage.RemoteEvent:FireServer({"Rank_Upgrade_Request"})
            end
        end)
    end
})

ShopFolder:AddToggle({
    text = "Auto Upgrade Storage", 
    state = false,
    callback = function(v) 
        _G.storage = v

        task.spawn(function()
            while task.wait(1) do
                if not _G.storage then break end
                ReplicatedStorage.RemoteEvent:FireServer({"Capacity_Upgrade_Request"})
            end
        end)
    end
})

MiscFolder:AddButton({
    text = "Invisible",
    callback = function()
        pcall(function()
            Player.Character.Humanoid.Animator:Destroy()
            Player.Character.LowerTorso.Root:Destroy()
        end)
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
        print("A")
    end
})

MiscFolder:AddButton({
    text = "Discord",
    callback = function()
        setclipboard("discord.gg/waAsQFwcBn")
    end
})

library:Init()
