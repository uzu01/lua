repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
local egg = {}
local area = {}

for i, v in pairs(game:GetService("Workspace")["_Eggs"]:GetChildren()) do
    table.insert(egg,v.Name)
end

for i, v in pairs(game:GetService("Workspace")["_SingleCoinSpawns"]:GetChildren()) do
    table.insert(area,v.Name)
    table.sort(area, function(a,b) return tonumber(a) > tonumber(b) end)
end

_G.selectedArea = area[1]

function evolve(lulw) -- shit but still works
    local pet = {}
    for i, v in pairs(game:GetService("ReplicatedStorage").ReplicatedData[game.Players.LocalPlayer.Name].Pets:GetChildren()) do
        if not table.find(pet,v.Type.Value) then
            table.insert(pet,v.Type.Value)
        end
    end

    if #pet >= 1 then
        local arr = {}
        local asd = math.random(1,#pet)
    
        for i, v in pairs(game:GetService("ReplicatedStorage").ReplicatedData[game.Players.LocalPlayer.Name].Pets:GetChildren()) do
            if string.match(v.Type.Value,pet[asd]) and string.match(tostring(v.Evolution.Value),lulw) then
                table.insert(arr,tonumber(v.Name))
            end
        end
        
        if #arr >= 4 then
            local args = {}
            for i = 1, 4 do
                args[#args+1] = arr[#args+1]
            end
            game:GetService("ReplicatedStorage").Events.PetEvents.Evolve:FireServer(args)
        end
    end
end

local library = loadstring(game:HttpGetAsync("https://pastebin.com/raw/znibQh36"))()
local window = library:CreateWindow("Magnet Simulator 2")
local farmingFolder = window:AddFolder('Farming')
local petFolder = window:AddFolder("Pet")
local shopFolder = window:AddFolder("Shop")
local miscFolder = window:AddFolder("Misc")

farmingFolder:AddToggle({
    text = "Coin Farm", 
    callback = function(v) 
        _G.autofarm = v

		local oldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		plr.CFrame = oldPos * CFrame.new(0,20,0)

        task.spawn(function()
            while task.wait(1) do
                if not _G.autofarm then plr.Anchored = false break end
                for i, v in pairs(game.Workspace.Coins:GetChildren()) do
                    plr.Anchored = true
					plr.CFrame = game:GetService("Workspace")["_SingleCoinSpawns"][_G.selectedArea].CFrame * CFrame.new(0,-10,0)
                    game:GetService("ReplicatedStorage").Events.GameEvents.CollectCoin:FireServer(v,false)
                end
            end
        end)
    end
})

farmingFolder:AddList({
    text = "Coin Farm Mult", 
    values = area, 
    callback = function(v)
		_G.selectedArea = v 
        plr.CFrame = game:GetService("Workspace")["_SingleCoinSpawns"][_G.selectedArea].CFrame
    end
})

farmingFolder:AddToggle({
    text = "Auto Sell", 
    callback = function(v) 
        _G.autosell = v

        task.spawn(function()
            while task.wait() do
                if not _G.autosell then break end
                local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
                local sell = game:GetService("Workspace").Rings.Sellx18.Touch.TouchInterest
                firetouchinterest(plr,sell.Parent,0)
                firetouchinterest(plr,sell.Parent,1)
            end
        end)
    end
})

petFolder:AddToggle({
    text = "Auto Open Egg", 
    callback = function(v) 
        _G.openEgg = v 

        task.spawn(function()
            while task.wait() do
                if not _G.openEgg then break end
                game:GetService("ReplicatedStorage").Events.GameEvents.BuyEgg:FireServer(_G.selectedEgg)
            end
        end)
    end
})

petFolder:AddList({
    text = "Select Egg", 
    values = egg, 
    callback = function(v) 
        _G.selectedEgg = v
    end
})

petFolder:AddToggle({
    text = "Auto Equip Best",
    callback = function(v)
        _G.equipBest = v
        
        task.spawn(function()
            while task.wait(15) do
                if not _G.equipBest then break end
                game:GetService("ReplicatedStorage").Events.PetEvents.EquipBest:FireServer()
            end
        end)
    end
})

petFolder:AddToggle({
    text = "Auto Evolve", 
    callback = function(v) 
        _G.autoEvolve = v 

        task.spawn(function()
            while task.wait() do
                if not _G.autoEvolve then break end
                evolve(0)
                evolve(1)
                evolve(2)
                evolve(3)
            end
        end)
    end
})

shopFolder:AddToggle({
    text = "Auto Buy Magnet", 
    callback = function(v) 
        _G.buyMagnet = v 

        task.spawn(function()
            while task.wait(.5) do
                if not _G.buyMagnet then break end
                for i, v in pairs(game:GetService("Workspace").MagnetShop.Magnets:GetChildren()) do
                    game:GetService("ReplicatedStorage").Events.GameEvents.BuyMagnet:FireServer(v.Name) wait(.5)
                end
            end
        end)
    end
})

shopFolder:AddToggle({
    text = "Auto Upgrade Magnet", 
    callback = function(v) 
        _G.upgradeMagnet = v 

        task.spawn(function()
            while task.wait(.5) do
                if not _G.upgradeMagnet then break end
                for i, v in pairs(game:GetService("Players").LocalPlayer.StarterGear:GetChildren()) do
                    currentMagnet = v.Name
                end
                game:GetService("ReplicatedStorage").Events.GameEvents.UpgradeMagnet:FireServer(currentMagnet,"Range")
                game:GetService("ReplicatedStorage").Events.GameEvents.UpgradeMagnet:FireServer(currentMagnet,"Power")
                game:GetService("ReplicatedStorage").Events.GameEvents.UpgradeMagnet:FireServer(currentMagnet,"Speed")
            end
        end)
    end
})

shopFolder:AddToggle({
    text = "Auto Upgrade Speed", 
    callback = function(v) 
        _G.upgradeSpeed = v 

        task.spawn(function()
            while task.wait(.5) do
                if not _G.upgradeSpeed then break end
                game:GetService("ReplicatedStorage").Events.GameEvents.UpgradeSpeed:FireServer()
            end
        end)
    end
})

shopFolder:AddToggle({
    text = "Auto Upgrade Storage", 
    callback = function(v) 
        _G.upgrageStorage = v 
        
        task.spawn(function()
            while task.wait(.5) do
                if not _G.upgrageStorage then break end
                game:GetService("ReplicatedStorage").Events.GameEvents.UpgradeStorage:FireServer()
            end
        end)
    end
})

shopFolder:AddToggle({
    text = "Auto Buy World", 
    callback = function(v) 
        _G.buyWorld = v 

        task.spawn(function()
            while task.wait(.5) do
                if not _G.buyWorld then break end
                for i, v in pairs(game:GetService("Workspace")["_Gates"]:GetChildren()) do
                    game:GetService("ReplicatedStorage").Events.GameEvents.BuyZone:FireServer(v.Name) wait(.5)
                end
            end
        end)
    end
})

miscFolder:AddToggle({
    text = "Auto Claim Daily Reward", 
    callback = function(v) 
        _G.claimReward = v 
    
        game:GetService("Players").LocalPlayer.InGroup.Value = true

        task.spawn(function()
            while task.wait(.2) do
                if not _G.claimReward then break end
                local plr = game.Players.LocalPlayer.Character.HumanoidRootPart    
                local part1 = game:GetService("Workspace")["_Dailys"].GroupDaily.Ring.Touch.TouchInterest
                local part2 = game:GetService("Workspace")["_Dailys"].Daily.Ring.Touch.TouchInterest
                firetouchinterest(plr,part1.Parent,0)
                firetouchinterest(plr,part1.Parent,1)task.wait(2)
                firetouchinterest(plr,part2.Parent,0)
                firetouchinterest(plr,part2.Parent,1)
            end
        end)
    end
})

miscFolder:AddButton({
    text = "Disable Pet Popup",
    callback = function()
        pcall(function()
            game.Players.LocalPlayer.PlayerGui.Eggs:Destroy()
            game.Players.LocalPlayer.PlayerGui.Evolve:Destroy()
        end)
    end
})

miscFolder:AddToggle({
    text = "Disable Notifications",
    callback = function(v)
        disableNotif = v
        
        if disableNotif then
            game:GetService("Players").LocalPlayer.PlayerGui.Game.MidNotifications.Visible = false
            game:GetService("Players").LocalPlayer.PlayerGui.Game.Notifications.Visible = false
        else
            game:GetService("Players").LocalPlayer.PlayerGui.Game.Notifications.Visible = true
            game:GetService("Players").LocalPlayer.PlayerGui.Game.MidNotifications.Visible = true
        end
    end
})

miscFolder:AddButton({
    text = "Unlock Gamepass",
    callback = function()
        for i, v in pairs(game:GetService("Players").LocalPlayer.Gamepasses:GetChildren()) do
            v.Value = true
        end 
    end
})

miscFolder:AddBind({
    text = "Toggle GUI", 
    key = "LeftControl", 
    callback = function() 
        library:Close()
    end
})

miscFolder:AddButton({
    text = "Script by Uzu",
    callback = function()
        print('a')
    end
})

miscFolder:AddButton({
    text = "discord.gg/waAsQFwcBn",
    callback = function()
        setclipboard("discord.gg/waAsQFwcBn")
    end
})

library:Init()