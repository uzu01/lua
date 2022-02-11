repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

pcall(function()
    game.Workspace._Effects:Destroy()
end)    

local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
local egg = {}
local area = {}

for i, v in pairs(game:GetService("Workspace")["_Eggs"]:GetChildren()) do
    table.insert(egg,v.Name)
end

for i, v in pairs(game:GetService("Workspace")["_SingleCoinSpawns"]:GetChildren()) do
    table.insert(area,v.Name)
end

table.sort(area, function(a,b) return tonumber(a) > tonumber(b) end)

local selectedArea = area[1]

function evolve(lulw) -- shit but works
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

local sell = {}
for i, v in pairs(game:GetService("Workspace").Rings:GetChildren()) do
    if string.match(v.Name,"%d+") then
        table.insert(sell,v.Name)
        table.sort(sell, function(a,b) return tonumber(string.match(a,"%d+")) > tonumber(string.match(b,"%d+")) end)
    end
end
   
local sellArea = sell[1]
local world = {}

for i, v in pairs(workspace.CollectibleCoins:GetChildren()) do
    table.insert(world,v.Name)
end

local selectedWorld = world[1]

function getPets()
    local pet = {}
    for i, v in pairs(game:GetService("Workspace")["_PlayerPets"][game.Players.LocalPlayer.Name]:GetChildren()) do
        if v:FindFirstChild("Torso") then
            table.insert(pet,v.Name)
        end
    end
    return pet
end

function getCoins()
    local toFarm = {}
    for i, v in pairs(game.Workspace.CollectibleCoins[selectedWorld]:GetChildren()) do
        for i2, v2 in pairs(v:GetChildren()) do
            table.insert(toFarm,v2)
        end
    end
    return toFarm
end

local library = loadstring(game:HttpGetAsync("https://pastebin.com/raw/znibQh36"))()
local Window = library:CreateWindow("Magnet Simulator 2")
local Farm_Folder = Window:AddFolder("Farming")
local Pet_Folder = Window:AddFolder("Pet")
local Shop_Folder = Window:AddFolder("Shop")
local Misc_Folder = Window:AddFolder("Misc")

Farm_Folder:AddToggle({
    text = "Auto Coin Farm", 
    callback = function(v) 
        autofarm = v

        task.spawn(function()
            while task.wait(1) do
                if not autofarm then break end
                plr.CFrame = game:GetService("Workspace")["_SingleCoinSpawns"][selectedArea].CFrame * CFrame.new(0,2,0)
                for i, v in pairs(game.Workspace.Coins:GetChildren()) do
                    game:GetService("ReplicatedStorage").Events.GameEvents.CollectCoin:FireServer(v,false)
                end
            end
        end)
    end
})

Farm_Folder:AddList({
    text = "Coin Farm Mult", 
    values = area, 
    callback = function(value)
		selectedArea = value 
    end
})

Farm_Folder:AddToggle({
    text = "Auto Sell", 
    callback = function(v) 
        autosell = v

        task.spawn(function()
            while task.wait() do
                if not autosell then break end
                local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
                local sell = game:GetService("Workspace").Rings[sellArea].Touch.TouchInterest
                firetouchinterest(plr,sell.Parent,0)
                firetouchinterest(plr,sell.Parent,1)
            end
        end)
    end
})

Farm_Folder:AddToggle({
    text = "Multi Attack Coins", 
    callback = function(v) 
        multitarget = v

        task.spawn(function()
            while task.wait() do
                if not multitarget then break end
                pcall(function()
                    local pet = getPets()
                    local coin = getCoins()
                    for i = 1, #pet do  
                        game:GetService("Workspace")["_PlayerPets"][game.Players.LocalPlayer.Name][pet[i]]:FindFirstChild("Torso").CFrame = coin[i]:FindFirstChild("Base").CFrame
                        game:GetService("ReplicatedStorage").Events.PetEvents.Collect:InvokeServer(coin[i],tonumber(pet[i]),"AddPetToStack")
                    end
                end)
            end
        end)
    end
})

Farm_Folder:AddList({
    text = "Select Area", 
    values = world, 
    callback = function(value)
        selectedWorld = value 
    end
})

Farm_Folder:AddToggle({
    text = "Auto Collect Power Ups", 
    callback = function(v) 
        collectPower = v

        task.spawn(function()
            while task.wait() do
                if not collectPower then break end
                for i, v in pairs(game:GetService("Workspace")["_PlayerPowerUps"][game.Players.LocalPlayer.Name]:GetChildren()) do
                    for a, b in pairs(v:GetChildren()) do
                        if b.Name == "TouchInterest" then
                            firetouchinterest(plr,b.Parent,0) task.wait()
                            firetouchinterest(plr,b.Parent,1)
                        end
                    end
                end
            end 
        end)
    end
})

Pet_Folder:AddToggle({
    text = "Auto Open Egg", 
    callback = function(v) 
        openEgg = v 

        task.spawn(function()
            while task.wait() do
                if not openEgg then break end
                game:GetService("ReplicatedStorage").Events.GameEvents.BuyEgg:FireServer(selectedEgg)
            end
        end)
    end
})

Pet_Folder:AddList({
    text = "Select Egg", 
    values = egg, 
    callback = function(value) 
   		selectedEgg = value
    end
})

Pet_Folder:AddToggle({
    text = "Auto Equip Best",
    callback = function(v)
        equipBest = v
        
        task.spawn(function()
            while task.wait(20) do
                if not equipBest then break end
                game:GetService("ReplicatedStorage").Events.PetEvents.EquipBest:FireServer()
            end
        end)
    end
})

Pet_Folder:AddToggle({
    text = "Auto Evolve", 
    callback = function(v) 
        autoEvolve = v 

        task.spawn(function()
            while task.wait() do
                if not autoEvolve then break end
                pcall(function()
                    evolve(0)
                    evolve(1)
                    evolve(2)
                    evolve(3)
                end)
            end
        end)
    end
})

Shop_Folder:AddToggle({
    text = "Auto Buy Magnet", 
    callback = function(v) 
        buyMagnet = v 

        task.spawn(function()
            while task.wait(1) do
                if not buyMagnet then break end
                for i, v in pairs(game:GetService("Workspace").MagnetShop.Magnets:GetChildren()) do
                    game:GetService("ReplicatedStorage").Events.GameEvents.BuyMagnet:FireServer(v.Name) wait(.5)
                end
            end
        end)
    end
})

Shop_Folder:AddToggle({
    text = "Auto Upgrade Magnet", 
    callback = function(v) 
        upgradeMagnet = v 

        task.spawn(function()
            while task.wait(1) do
                if not upgradeMagnet then break end
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

Shop_Folder:AddToggle({
    text = "Auto Upgrade Speed", 
    callback = function(v) 
        upgradeSpeed = v 

        task.spawn(function()
            while task.wait(1) do
                if not upgradeSpeed then break end
                game:GetService("ReplicatedStorage").Events.GameEvents.UpgradeSpeed:FireServer()
            end
        end)
    end
})

Shop_Folder:AddToggle({
    text = "Auto Upgrade Storage", 
    callback = function(v) 
        upgrageStorage = v 
        
        task.spawn(function()
            while task.wait(1) do
                if not upgrageStorage then break end
                game:GetService("ReplicatedStorage").Events.GameEvents.UpgradeStorage:FireServer()
            end
        end)
    end
})

Shop_Folder:AddToggle({
    text = "Auto Buy World", 
    callback = function(v) 
        buyWorld = v 

        task.spawn(function()
            while task.wait(1) do
                if not buyWorld then break end
                for i, v in pairs(game:GetService("Workspace")["_Gates"]:GetChildren()) do
                    game:GetService("ReplicatedStorage").Events.GameEvents.BuyZone:FireServer(v.Name) wait(.5)
                end
            end
        end)
    end
})

Misc_Folder:AddToggle({
    text = "Auto Claim Daily Reward", 
    callback = function(v) 
        claimReward = v 
    
        game:GetService("Players").LocalPlayer.InGroup.Value = true

        task.spawn(function()
            while task.wait(1) do
                if not claimReward then break end
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

Misc_Folder:AddToggle({
    text = "Auto Use Enchantments", 
    callback = function(v) 
        useEnchant = v 
    
        task.spawn(function()
            while task.wait(2) do
                if not useEnchant then break end
                for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Game.OpenableUi.Enchantments.Main.Top.Main:GetChildren()) do
                    if v:IsA("Frame") then
                        game:GetService("ReplicatedStorage").Events.GameEvents.UseEnchantment:InvokeServer(tonumber(v.Name))
                    end
                end
            end
        end)
    end
})

Misc_Folder:AddButton({
    text = "Unlock Gamepass",
    callback = function()
        for i, v in pairs(game:GetService("Players").LocalPlayer.Gamepasses:GetChildren()) do
            v.Value = true
        end 
    end
})

Misc_Folder:AddButton({
    text = "Disable Notifications",
    callback = function()
        pcall(function()
            game.Players.LocalPlayer.PlayerGui.Eggs:Destroy()
            game.Players.LocalPlayer.PlayerGui.Evolve:Destroy()
            game:GetService("Players").LocalPlayer.PlayerGui.Game.MidNotifications.Visible = false
            game:GetService("Players").LocalPlayer.PlayerGui.Game.Notifications.Visible = false
        end)
    end
})

Misc_Folder:AddBind({
    text = "Toggle GUI", 
    key = "LeftControl", 
    callback = function() 
        library:Close()
    end
})

Misc_Folder:AddButton({
    text = "Script by Uzu",
    callback = function()
        print('a')
    end
})

Misc_Folder:AddButton({
    text = "Copy Discord Invite",
    callback = function()
        setclipboard("discord.gg/waAsQFwcBn")
    end
})

library:Init()
