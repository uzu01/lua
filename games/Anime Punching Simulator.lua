repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

if game.PlaceId == 8357510970 then

    _G.Settings = {
        autoTap = false;
        autoRebirth = false;
        autoPractice = false;
        autoEgg = false;
        autoUpgrade = false;
        autoRank = false;
        autoAura = false;
        autoWorld = false;
        tripleEgg = "1";
        autoMaxElite = false;
    }

	local codes = {
        "HUNTER";
        "70KFAVS";
        "45KLIKES";
        "16MVISITS";
        "HERO";
        "35KLIKES";
        "50KFAVS";
        "10MVISITS";
        "30KLIKES";
        "8MVISITS";
        "BOLINHOBLOX";
        "25KLIKES";
        "VAGNERGAMES";
        "15klikes";
        "4MVisits";
        "2MVISITS";
        "10KLIKES";
        "5KLIKES";
        "1MVISITS";
        "MASTER";
        "500KVISITS";
        "250kvisits";
        "80KVISITS";
        "1KLIKES";
        "Release";
    }

    pcall(function()
        game:GetService("Players").LocalPlayer.PlayerGui.Ui.CenterFrame.Error:Destroy()
        game:GetService("Players").LocalPlayer.PlayerGui.EggAnimation:Destroy()
    end)

    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    local tickk = tick()
    local reb = {}
    local practiceArea = {}
    local egg = {}

    for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Ui.CenterFrame.Rebirths.Frame:GetChildren()) do
        if v:IsA("ImageLabel") and not table.find(reb,v.Price.Text) then
            table.insert(reb,v.Price.Text)
        end
    end

    for i, v in pairs(game.Workspace.__SETTINGS.__INTERACT:GetChildren()) do
        if v.Name == "Practice" and not table.find(practiceArea,v.Area.Value.." Boost: "..v.Boost.Value) then
            table.insert(practiceArea,v.Area.Value.." Boost: "..v.Boost.Value)
        end
    end 

    for i, v in pairs(game.Workspace.__SETTINGS.__INTERACT:GetChildren()) do
        if v.Name == "EGG" and not table.find(egg,v.Tier.Value) then 
            table.insert(egg,v.Tier.Value)
        end
    end

    function noclip()
        for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
    
    function teleport(mob)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.CFrame
    end
    
    local library = loadstring(game:HttpGetAsync("https://pastebin.com/raw/znibQh36"))()
    local MainWindow = library:CreateWindow("Main")
    local TeleWindow = library:CreateWindow("Teleport")
    local MiscWindow = library:CreateWindow("Misc")
    local FarmFolder = MainWindow:AddFolder("Farming")
    local HeroFolder = MainWindow:AddFolder("Heroes")
    local ShopFolder = MainWindow:AddFolder("Shop")

    FarmFolder:AddToggle({
        text = "Auto Tap", 
        state = false,
        callback = function(v) 
            _G.Settings.autoTap = v

            task.spawn(function()
                while task.wait() do
                    if not _G.Settings.autoTap then break end
                    game:GetService("ReplicatedStorage").Remotes.TappingEvent:FireServer()
                end
            end)
        end
    })

    FarmFolder:AddToggle({
        text = "Auto Rebirth", 
        state = false,
        callback = function(v) 
            _G.Settings.autoRebirth = v

            task.spawn(function()
                while task.wait() do
                    if not _G.Settings.autoRebirth then break end
                    game:GetService("ReplicatedStorage").Remotes.ClientRemote:InvokeServer("Rebirths",selectedNum)
                end
            end)
        end
    })

    FarmFolder:AddList({
        text = "Select Rebirth Amount", 
        values = reb, 
        callback = function(value) 
            for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Ui.CenterFrame.Rebirths.Frame:GetChildren()) do
                if v:IsA("ImageLabel") and v.Price.Text == tostring(value) then
                    selectedNum = tonumber(v.Name)
                end
            end
        end
    })

    FarmFolder:AddToggle({
        text = "Auto Practice", 
        state = false,
        callback = function(v) 
            _G.Settings.autoPractice = v
            
            task.spawn(function()
                while task.wait() do
                    if not _G.Settings.autoPractice then break end
                    for i, v in pairs(game.Workspace.__SETTINGS.__INTERACT:GetChildren()) do
                        if v.Name == "Practice" and v.Boost.Value == tonumber(selectedArea) then
                            pcall(function() 
                                repeat task.wait()
                                    teleport(v)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, "E", false, game) task.wait()
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, "E", false, game)
                                    game:GetService("ReplicatedStorage").Remotes.ClientRemote:InvokeServer("Practice",v)
                                until not _G.Settings.autoPractice
                            end)
                        end
                    end
                end
            end)
        end
    })

    FarmFolder:AddList({
        text = "Select Practice Area", 
        values = practiceArea, 
        callback = function(v) 
            selectedArea = string.match(v,"%d+")
        end
    })

    HeroFolder:AddToggle({
        text = "Auto Open Egg", 
        state = false,
        callback = function(v) 
            _G.Settings.autoEgg = v

            task.spawn(function()
                while task.wait() do
                    if not _G.Settings.autoEgg then break end
                    pcall(function() 
                        teleport(selectedEgg)
                        repeat task.wait()
                            game:GetService("ReplicatedStorage").Remotes.ClientRemote:InvokeServer("EGG",selectedEgg,_G.Settings.tripleEgg,{})
                        until not _G.Settings.autoEgg
                    end)
                end
            end)
        end
    })

    HeroFolder:AddList({
        text = "Select Egg", 
        values = egg, 
        callback = function(value) 
            for i, v in pairs(game.Workspace.__SETTINGS.__INTERACT:GetChildren()) do
                if v.Name == "EGG" and v.Tier.Value == value then 
                    selectedEgg = v
                end
            end  
        end
    })

    HeroFolder:AddToggle({
        text = "Triple Egg", 
        state = false,
        callback = function(v) 
            lulul = v
            
            if lulul then
                _G.Settings.tripleEgg = "2"
            else
                _G.Settings.tripleEgg = "1"
            end 
        end
    })

    HeroFolder:AddToggle({
        text = "Auto Max Elite", 
        state = false,
        callback = function(v) 
            _G.Settings.autoMaxElite = v

            task.spawn(function()
                while task.wait() do
                    if not _G.Settings.autoMaxElite then break end
                    game:GetService("ReplicatedStorage").Remotes.NPCSystem:InvokeServer(true,"MAXELITE")
                end
            end)
        end
    })

    ShopFolder:AddToggle({
        text = "Auto Buy Upgrade", 
        state = false,
        callback = function(v) 
            _G.Settings.autoUpgrade = v

            task.spawn(function()
                while task.wait() do
                    if not _G.Settings.autoUpgrade then break end
                    for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Ui.CenterFrame.Shop.Upgrades:GetChildren()) do
                        if v:IsA("ImageLabel") then
                            game:GetService("ReplicatedStorage").Remotes.ClientRemote:InvokeServer("Upgrade",tonumber(v.Name))
                        end
                    end
                    
                end
            end)
        end
    })

    ShopFolder:AddToggle({
        text = "Auto Buy Rank", 
        state = false,
        callback = function(v) 
            _G.Settings.autoRank = v

            task.spawn(function()
                while task.wait() do
                    if not _G.Settings.autoRank then break end
                    for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Ui.CenterFrame.Shop.Ranks:GetChildren()) do
                        if v:IsA("ImageLabel") then
                            game:GetService("ReplicatedStorage").Remotes.ClientRemote:InvokeServer("Ranks",tonumber(v.Name))
                        end
                    end
                    
                end
            end)
        end
    })

    ShopFolder:AddToggle({
        text = "Auto Buy Aura", 
        state = false,
        callback = function(v) 
            _G.Settings.autoAura = v

            task.spawn(function()
                while task.wait() do
                    if not _G.Settings.autoAura then break end
                    for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Ui.CenterFrame.Auras.Frame:GetChildren()) do
                        if v:IsA("ImageLabel") then
                            game:GetService("ReplicatedStorage").Remotes.ClientRemote:InvokeServer("Auras",tonumber(v.Name))
                        end
                    end
                    
                end
            end)
        end
    })

    ShopFolder:AddToggle({
        text = "Auto Buy World", 
        state = false,
        callback = function(value) 
            _G.Settings.autoWorld = value

            task.spawn(function()
                while task.wait() do
                    if not _G.Settings.autoWorld then break end
                    for i, v in pairs(game:GetService("Workspace")["__SETTINGS"]["__AREAS"]:GetChildren()) do
                        game:GetService("ReplicatedStorage").Remotes.ClientRemote:InvokeServer("Areas",v.Name)
                    end
                end
            end)
        end
    })

    for i, v in pairs(game:GetService("Workspace")["__SETTINGS"]["__AREAS"]:GetChildren()) do
        TeleWindow:AddButton({
            text = v.Name,
            callback = function()
                teleport(v)
            end
        })
    end

    MiscWindow:AddToggle({
        text = "Claim Group Reward", 
        state = false,
        callback = function(v) 
            _G.Settings.autoClaim = v

            task.spawn(function()
                while task.wait() do
                    if not _G.Settings.autoClaim then break end
                    game:GetService("ReplicatedStorage").Remotes.ClientRemote:InvokeServer("GroupChest")
                end
            end)
        end
    })

    MiscWindow:AddButton({
        text = "Tp to Second World",
        callback = function()
            for i, v in pairs(game.Workspace.__Map:GetChildren()) do
                if v:FindFirstChild("TouchInterest") then
                    firetouchinterest(v,plr,0)
                end
            end
        end
    })

    MiscWindow:AddButton({
        text = "Redeem Codes",
        callback = function()
            for i, v in pairs(codes) do
                game:GetService("ReplicatedStorage").Remotes.ClientRemote:InvokeServer("Codes",v)
            end
        end
    })

    MiscWindow:AddBind({
        text = "Toggle GUI", 
        key = "LeftControl", 
        callback = function() 
            library:Close()
        end
    })

    MiscWindow:AddButton({
        text = "Script by Uzu",
        callback = function()
            print("a")
        end
    })

    MiscWindow:AddButton({
        text = "discord.gg/waAsQFwcBn",
        callback = function()
            setclipboard("discord.gg/waAsQFwcBn")
        end
    })

    library:Init()
    
	warn("Last Update: 2/8/22, 7:23 PM PST")
    warn("script took ",string.format("%.0f",tick()-tickk),"seconds to load")

elseif game.PlaceId == 8649665676 then

    loadstring(game:HttpGet("https://pastebin.com/raw/NcyduV34"))()

end