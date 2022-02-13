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
    for i, v in pairs(game.Workspace.CollectibleCoins:GetChildren()) do
		for i2, v2 in pairs(v:GetChildren()) do
			for i3, v3 in pairs(v2:GetChildren()) do
            	table.insert(toFarm,v3)
        	end
		end
    end
    return toFarm
end

local library = loadstring(game:HttpGet("https://pastebin.com/raw/Uz6HijUN", true))()
local w = library:CreateWindow("Farming")
local b = library:CreateWindow("Pet")
local c = library:CreateWindow("Shop")
local d = library:CreateWindow("Misc")

w:Toggle("Auto Coin Farm", {flag = "toggle1"}, function(v)
    autofarm = v

    task.spawn(function()
        while task.wait(1) do
            if not autofarm then break end
            for i, v in pairs(game.Workspace.Coins:GetChildren()) do
                game:GetService("ReplicatedStorage").Events.GameEvents.CollectCoin:FireServer(v,false)
            end
        end
    end)
end)

w:Dropdown("Coin Farm Mult", {flag = "A", list = area}, function(v)
    selectedArea = v
end)

w:Toggle("Auto Sell", {flag = "toggle1"}, function(v)
    autosell = v

    task.spawn(function()
        while task.wait(3) do
            if not autosell then break end
            local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
            local sell = game:GetService("Workspace").Rings[sellArea].OuterRing
            plr.CFrame = sell.CFrame * CFrame.new(0,3,0)
        end
    end)
end)

w:Toggle("Multi Attack Coins", {flag = "toggle1"}, function(v)
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
end)

w:Toggle("Auto Collect Power Ups", {flag = "toggle1"}, function(v)
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
end)

b:Toggle("Auto Open Egg", {flag = "toggle1"}, function(v)
    openEgg = v 

    task.spawn(function()
        while task.wait() do
            if not openEgg then break end
            game:GetService("ReplicatedStorage").Events.GameEvents.BuyEgg:FireServer(selectedEgg)
        end
    end)
end)

b:Dropdown("Select Egg", {flag = "a", list = egg}, function(v)
    selectedEgg = v
end)

b:Toggle("Auto Equip Best", {flag = "toggle1"}, function(v)
    equipBest = v
        
    task.spawn(function()
        while task.wait(20) do
            if not equipBest then break end
            game:GetService("ReplicatedStorage").Events.PetEvents.EquipBest:FireServer()
        end
    end)
end)

b:Toggle("Auto Evolve", {flag = "toggle1"}, function(v)
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
end)

c:Toggle("Buy Magnet", {flag = "toggle1"}, function(v)
    buyMagnet = v 

    task.spawn(function()
        while task.wait(1) do
            if not buyMagnet then break end
            for i, v in pairs(game:GetService("Workspace").MagnetShop.Magnets:GetChildren()) do
                game:GetService("ReplicatedStorage").Events.GameEvents.BuyMagnet:FireServer(v.Name) wait(.5)
            end
        end
    end)
end)

c:Toggle("Upgrade Magnet", {flag = "toggle1"}, function(v)
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
end)

c:Toggle("Upgrade Speed", {flag = "toggle1"}, function(v)
    upgradeSpeed = v 

    task.spawn(function()
        while task.wait(1) do
            if not upgradeSpeed then break end
            game:GetService("ReplicatedStorage").Events.GameEvents.UpgradeSpeed:FireServer()
        end
    end)
end)

c:Toggle("Upgrade Storage", {flag = "toggle1"}, function(v)
    upgrageStorage = v 
        
    task.spawn(function()
        while task.wait(1) do
            if not upgrageStorage then break end
            game:GetService("ReplicatedStorage").Events.GameEvents.UpgradeStorage:FireServer()
        end
    end)
end)

c:Toggle("Buy World", {flag = "toggle1"}, function(v)
    buyWorld = v 

    task.spawn(function()
        while task.wait(1) do
            if not buyWorld then break end
            for i, v in pairs(game:GetService("Workspace")["_Gates"]:GetChildren()) do
                game:GetService("ReplicatedStorage").Events.GameEvents.BuyZone:FireServer(v.Name) wait(.5)
            end
        end
    end)
end)

d:Toggle("Claim Daily Reward", {flag = "toggle1"}, function(v)
    claimReward = v 
    
    game:GetService("Players").LocalPlayer.InGroup.Value = true

    task.spawn(function()
        while task.wait(1) do
            if not claimReward then break end
            game:GetService("ReplicatedStorage").Events.GameEvents.CollectReward:FireServer("GroupDaily")
            game:GetService("ReplicatedStorage").Events.GameEvents.CollectReward:FireServer("Daily")
        end
    end)
end)

d:Toggle("Use Enchantments", {flag = "toggle1"}, function(v)
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
end)

d:Button("Disable Notification", function()
    pcall(function()
        game.Players.LocalPlayer.PlayerGui.Eggs:Destroy()
        game.Players.LocalPlayer.PlayerGui.Evolve:Destroy()
        game:GetService("Players").LocalPlayer.PlayerGui.Game.MidNotifications.Visible = false
        game:GetService("Players").LocalPlayer.PlayerGui.Game.Notifications.Visible = false
    end)
end)

d:Button("Script by Uzu", function()
    print("A")
end)

d:Button("Discord", function()
    setclipboard("discord.gg/waAsQFwcBn")
end)
