repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Settings = {
    autofarm = false,
    selectedArea = 1,
    autosell = false,
    multitarget = false,
    collectPower = false,
    openEgg = false,
    selectedEgg = "Frost",
    equipBest = false,
    autoEvolve = false,
    buyMagnet = false,
    upgradeMagnet = false,
    upgradeSpeed = false,
    upgrageStorage = false,
    buyWorld = false,
    claimReward = false,
    useEnchant = false,
}

local foldername = "Uzu"
local filename = "MagnetSimulator2.lua"
    
function saveSettings()
    local HttpService,json = game:GetService("HttpService")
    if (writefile) then
        if isfolder(foldername) then
            json = HttpService:JSONEncode(_G.Settings)
            writefile(foldername.."\\"..filename, json)
        else
            makefolder(foldername)
            writefile(foldername.."\\"..filename, json)
        end
    end
end
    
function loadSettings()
    local HttpService = game:GetService("HttpService")
    if (readfile) then
        if isfile(foldername.."\\"..filename) then
            _G.Settings = HttpService:JSONDecode(readfile(foldername.."\\"..filename))
        end
    end
end
    
loadSettings()

pcall(function()
    game.Workspace._Effects:Destroy()
end)    

local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Player.Character.HumanoidRootPart
local egg = {}
local area = {}
local sell = {}

for i, v in pairs(game:GetService("Workspace")["_Eggs"]:GetChildren()) do
    table.insert(egg,v.Name)
end

for i, v in pairs(game:GetService("Workspace")["_SingleCoinSpawns"]:GetChildren()) do
    table.insert(area,v.Name)
end

table.sort(area, function(a,b) return tonumber(a) > tonumber(b) end)

function evolve(lulw) -- shit but works
    local pet = {}
    for i, v in pairs(ReplicatedStorage.ReplicatedData[Player.Name].Pets:GetChildren()) do
        if not table.find(pet,v.Type.Value) then
            table.insert(pet,v.Type.Value)
        end
    end

    if #pet >= 1 then
        local arr = {}
        local asd = math.random(1,#pet)
    
        for i, v in pairs(ReplicatedStorage.ReplicatedData[Player.Name].Pets:GetChildren()) do
            if string.match(v.Type.Value,pet[asd]) and string.match(tostring(v.Evolution.Value),lulw) then
                table.insert(arr,tonumber(v.Name))
            end
        end
        
        if #arr >= 4 then
            local args = {}
            for i = 1, 4 do
                args[#args+1] = arr[#args+1]
            end
            ReplicatedStorage.Events.PetEvents.Evolve:FireServer(args)
        end
    end
end

for i, v in pairs(game:GetService("Workspace").Rings:GetChildren()) do
    if string.match(v.Name,"%d+") then
        table.insert(sell,v.Name)
    end
end

table.sort(sell, function(a,b) return tonumber(string.match(a,"%d+")) > tonumber(string.match(b,"%d+")) end)

local sellArea = sell[1]

function getPets()
    local pet = {}
    for i, v in pairs(game:GetService("Workspace")["_PlayerPets"][Player.Name]:GetChildren()) do
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

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/uzu01/lua/main/ui/flux.lua"))()
local w = library:Window("Uzu Scripts", "Magnet Simulator 2", Color3.fromRGB(66, 134, 245), Enum.KeyCode.LeftControl)
local HomeTab = w:Tab("Home", 6026568198)

HomeTab:Button("Updates:", "", function()
    library:Notification("[+] New Gui [+] Auto Save Config", "Thanks")
end)

HomeTab:Line()

HomeTab:Button("Discord"," ", function()
    setclipboard("discord.gg/waAsQFwcBn")
    library:Notification("discord.gg/waAsQFwcBn", "Alright")
end)

HomeTab:Button("Script by Uzu"," ", function()
    setclipboard("discord.gg/waAsQFwcBn")
    library:Notification("discord.gg/waAsQFwcBn", "Alright")
end)

local FarmingTab = w:Tab("Farming", 6034287535)

FarmingTab:Toggle("Auto Farm", "", _G.Settings.autofarm, function(t)
    _G.Settings.autofarm = t
    saveSettings()

    task.spawn(function()
        while task.wait(1) do
            if not _G.Settings.autofarm then break end
            plr.CFrame = game:GetService("Workspace")["_SingleCoinSpawns"][_G.Settings.selectedArea].CFrame * CFrame.new(0,2,0)
            for i, v in pairs(game.Workspace.Coins:GetChildren()) do
                ReplicatedStorage.Events.GameEvents.CollectCoin:FireServer(v,false)
            end
        end
    end)
end)

FarmingTab:Dropdown("Coin Farm Mult", area, function(v)
    _G.Settings.selectedArea = v
    saveSettings()
end)

FarmingTab:Toggle("Auto Sell", "", _G.Settings.autosell, function(t)
    _G.Settings.autosell = t
    saveSettings()

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autosell then break end
            local plr = Player.Character.HumanoidRootPart
            local sell = game:GetService("Workspace").Rings[sellArea].Touch.TouchInterest
            firetouchinterest(plr,sell.Parent,0)
            firetouchinterest(plr,sell.Parent,1)
        end
    end)
end)

FarmingTab:Toggle("Multi Attack Coins", "", _G.Settings.multitarget, function(t)
    _G.Settings.multitarget = t
    saveSettings()

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.multitarget then break end
            pcall(function()
                local pet = getPets()
                local coin = getCoins()
                for i = 1, #pet do  
                    game:GetService("Workspace")["_PlayerPets"][Player.Name][pet[i]]:FindFirstChild("Torso").CFrame = coin[i]:FindFirstChild("Base").CFrame
                    ReplicatedStorage.Events.PetEvents.Collect:InvokeServer(coin[i],tonumber(pet[i]),"AddPetToStack")
                end
            end)
        end
    end)
end)

FarmingTab:Toggle("Auto Collect Power Ups", "", _G.Settings.collectPower, function(t)
    _G.Settings.collectPower = t
    saveSettings()

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.collectPower then break end
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

local PetTab = w:Tab("Pet", 6031260792)

PetTab:Toggle("Auto Open Egg", "", _G.Settings.openEgg, function(t)
    _G.Settings.openEgg = t
    saveSettings()

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.openEgg then break end
            ReplicatedStorage.Events.GameEvents.BuyEgg:FireServer(_G.Settings.selectedEgg)
        end
    end)
end)

PetTab:Dropdown("Select Egg", egg, function(v)
    _G.Settings.selectedEgg = v
    saveSettings()
end)

PetTab:Toggle("Auto Equip Best", "", _G.Settings.equipBest, function(t)
    _G.Settings.equipBest = t
    saveSettings()

    task.spawn(function()
        while task.wait(20) do
            if not _G.Settings.equipBest then break end
            ReplicatedStorage.Events.PetEvents.EquipBest:FireServer()
        end
    end)
end)

PetTab:Toggle("Auto Evolve", "", _G.Settings.autoEvolve, function(t)
    _G.Settings.autoEvolve = t
    saveSettings()

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoEvolve then break end
            pcall(function()
                evolve(0)
                evolve(1)
                evolve(2)
                evolve(3)
            end)
        end
    end)
end)

local ShopTab = w:Tab("Shop", 6031265987)

ShopTab:Toggle("Auto Buy Magnet", "", _G.Settings.buyMagnet, function(t)
    _G.Settings.buyMagnet  = t
    saveSettings()

    task.spawn(function()
        while task.wait(1) do
            if not _G.Settings.buyMagnet then break end
            for i, v in pairs(game:GetService("Workspace").MagnetShop.Magnets:GetChildren()) do
                ReplicatedStorage.Events.GameEvents.BuyMagnet:FireServer(v.Name) wait(.5)
            end
        end
    end)
end)

ShopTab:Toggle("Auto Upgrade Magnet", "", _G.Settings.upgradeMagnet, function(t)
    _G.Settings.upgradeMagnet = t
    saveSettings()

    task.spawn(function()
        while task.wait(1) do
            if not _G.Settings.upgradeMagnet then break end
            for i, v in pairs(Player.StarterGear:GetChildren()) do
                currentMagnet = v.Name
            end
            ReplicatedStorage.Events.GameEvents.UpgradeMagnet:FireServer(currentMagnet,"Range")
            ReplicatedStorage.Events.GameEvents.UpgradeMagnet:FireServer(currentMagnet,"Power")
            ReplicatedStorage.Events.GameEvents.UpgradeMagnet:FireServer(currentMagnet,"Speed")
        end
    end)
end)

ShopTab:Toggle("Auto Upgrade Speed", "", _G.Settings.upgradeSpeed, function(t)
    _G.Settings.upgradeSpeed = t
    saveSettings()

    task.spawn(function()
        while task.wait(1) do
            if not _G.Settings.upgradeSpeed then break end
            ReplicatedStorage.Events.GameEvents.UpgradeSpeed:FireServer()
        end
    end)
end)

ShopTab:Toggle("Auto Upgrade Storage", "", _G.Settings.upgrageStorage, function(t)
    _G.Settings.upgrageStorage = t
    saveSettings()

    task.spawn(function()
        while task.wait(1) do
            if not _G.Settings.upgrageStorage then break end
            ReplicatedStorage.Events.GameEvents.UpgradeStorage:FireServer()
        end
    end)
end)

ShopTab:Toggle("Auto Buy World", "", _G.Settings.buyWorld, function(t)
    _G.Settings.buyWorld = t
    saveSettings()

    task.spawn(function()
        while task.wait(1) do
            if not _G.Settings.buyWorld then break end
            for i, v in pairs(game:GetService("Workspace")["_Gates"]:GetChildren()) do
                ReplicatedStorage.Events.GameEvents.BuyZone:FireServer(v.Name) wait(.5)
            end
        end
    end)
end)

local MiscTab = w:Tab("Misc", 8916127218)

MiscTab:Toggle("Auto Claim Daily Reward", "", _G.Settings.claimReward, function(t)
    _G.Settings.claimReward = t
    saveSettings()

    Player.InGroup.Value = true

    task.spawn(function()
        while task.wait(1) do
            if not _G.Settings.claimReward then break end
            local plr = Player.Character.HumanoidRootPart    
            local part1 = game:GetService("Workspace")["_Dailys"].GroupDaily.Ring.Touch.TouchInterest
            local part2 = game:GetService("Workspace")["_Dailys"].Daily.Ring.Touch.TouchInterest
            firetouchinterest(plr,part1.Parent,0)
            firetouchinterest(plr,part1.Parent,1)task.wait(2)
            firetouchinterest(plr,part2.Parent,0)
            firetouchinterest(plr,part2.Parent,1)
        end
    end)
end)

MiscTab:Toggle("Auto Use Enchantments", "", _G.Settings.useEnchant, function(t)
    _G.Settings.useEnchant = t
    saveSettings()

    task.spawn(function()
        while task.wait(2) do
            if not _G.Settings.useEnchant then break end
            for i, v in pairs(Player.PlayerGui.Game.OpenableUi.Enchantments.Main.Top.Main:GetChildren()) do
                if v:IsA("Frame") then
                    ReplicatedStorage.Events.GameEvents.UseEnchantment:InvokeServer(tonumber(v.Name))
                end
            end
        end
    end)
end)

MiscTab:Button("Unlock Gamepass"," ", function()
    for i, v in pairs(Player.Gamepasses:GetChildren()) do
        v.Value = true
    end 
end)

MiscTab:Button("Disable Notifications"," ", function()
    Player.PlayerGui.Eggs:Destroy()
    Player.PlayerGui.Evolve:Destroy()
    Player.PlayerGui.Game.MidNotifications.Visible = false
    Player.PlayerGui.Game.Notifications.Visible = false
end)

MiscTab:Line()

MiscTab:Slider("Walk Speed", "",18, 100, 0, function(v)
    Player.Character.Humanoid.WalkSpeed = v
end)

MiscTab:Slider("Jump Height", "", 7.5, 100, 0, function(v)
    Player.Character.Humanoid.JumpHeight = v
end)

MiscTab:Line()

MiscTab:Button("Rejoin", "", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,Player)
end)

MiscTab:Button("Serverhop", "", function()
    while task.wait() do
        local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for i,v in pairs(Servers.data) do
            if v.id ~= game.JobId then
                task.wait()
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end
end)

MiscTab:Button("Serverhop Low Server", "", function()
    while task.wait() do
        local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for i,v in pairs(Servers.data) do
            if v.id ~= game.JobId and v.playing <= 3 then
                task.wait()
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end
end)
