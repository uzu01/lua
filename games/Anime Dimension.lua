if game.GameId == 2655311011 then

    repeat wait() until game:IsLoaded()

    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)

    _G.Settings = {
        MapName =       "Titan Dimension";
        Difficulty =    "Easy";
        Hardcore =      false;
        FriendsOnly =   false;
        AutoFarm =      false;
        AutoRetry =     false;
        AutoSkill =     false;
        Distance =      0;
        Speed =         69;
    }

    local foldername = "Uzu"
    local filename = "AnimeDimension2.lua"
     
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
        if isfile(foldername.."\\"..filename) then
            _G.Settings = HttpService:JSONDecode(readfile(foldername.."\\"..filename))
        end
    end
     
    loadSettings()

    local MapList = {
        "Infinite Mode";
        "Titan Dimension";
        "Demon Dimension";
        "Curse Dimension";
        "Villain Dimension";
        "Sword Dimension";
        "Ghoul Dimension";
        "Fate Dimension"
    }

    local MapDifficulty = {
        "Infinite";
        "Easy";
        "Hard";
        "Nightmare";
    }

    local keys = {
        "One";
        "Two";
        "Three";
        "Four";
        "E";
        "R"
    }

    function tween(Enemy)
        local plr,tp = game.Players.LocalPlayer.Character.HumanoidRootPart
        
        if _G.Settings.Distance >= 1 then
            tp = {CFrame = Enemy.CFrame * CFrame.new(0,_G.Settings.Distance,0) * CFrame.Angles(math.rad(-90),0,0)}
        elseif _G.Settings.Distance <= 0 then
            tp = {CFrame = Enemy.CFrame * CFrame.new(0,_G.Settings.Distance,0) * CFrame.Angles(math.rad(90),0,0)}
        end
        

        local ts = game:GetService("TweenService"):Create(plr, TweenInfo.new((plr.Position - Enemy.Position).magnitude/_G.Settings.Speed, Enum.EasingStyle.Linear), tp)
        ts:Play()
    end

    function click()
        local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
        game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill",{["hrpCFrame"] = hrp.CFrame,["attackNumber"] = 1},"BasicAttack")
    end

    function startGame()
        task.spawn(function()
            local args = {"CreateRoom",{["Difficulty"] = _G.Settings.Difficulty,["FriendsOnly"] = _G.Settings.FriendsOnly,["MapName"] = _G.Settings.MapName,["Hardcore"] = _G.Settings.Hardcore}}
            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(unpack(args))
            wait()
            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportPlayers")
        end)
    end 
    
    function noclip()
        for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end

    game:GetService("RunService").Stepped:Connect(function()
        if _G.Settings.AutoFarm then
            noclip()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end)

    local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/uzu01/lua/main/ui/uwuware.lua"))()
    local window = library:CreateWindow("Anime Dimension")
    local FarmingFolder = window:AddFolder("Farming")
    local SettingFolder = window:AddFolder("Settings")
    local CreditsFolder = window:AddFolder("Credits")

    FarmingFolder:AddToggle({
        text = "Enabled", 
        state = _G.Settings.AutoFarm,
        callback = function(a) 
            _G.Settings.AutoFarm = a
            saveSettings()

            startGame()

            task.spawn(function()
                while task.wait() do
                    if not _G.Settings.AutoFarm then break end
                    pcall(function()
                        for i, v in pairs(game:GetService("Workspace").Folders.Monsters:GetChildren()) do 
                            if v.EnemyHealthBarGui then
                                repeat task.wait() 
                                    tween(v.HumanoidRootPart);click()
                                until v.EnemyHealthBarGui == nil or not _G.Settings.AutoFarm
                            end
                        end
                    end)
                end
            end)
        end 
    })

    SettingFolder:AddList({
        text = "Select Map", 
        value = _G.Settings.MapName,
        values = MapList, 
        callback = function(a) 
            _G.Settings.MapName = a
            saveSettings() 
        end
    })  

    SettingFolder:AddList({
        text = " Select Difficulty", 
        value = _G.Settings.Difficulty,
        values = MapDifficulty, 
        callback = function(a) 
            _G.Settings.Difficulty = a
            saveSettings() 
        end
    })

    SettingFolder:AddToggle({
        text = "Friends Only", 
        state = _G.Settings.FriendsOnly,
        callback = function(a) 
            _G.Settings.FriendsOnly = a
            saveSettings()
        end
    })

    SettingFolder:AddToggle({
        text = "Hardcore", 
        state = _G.Settings.Hardcore,
        callback = function(a) 
            _G.Settings.Hardcore = a
            saveSettings()
        end
    })

    SettingFolder:AddToggle({
        text = "Auto Retry", 
        state = _G.Settings.AutoRetry,
        callback = function(a) 
            _G.Settings.AutoRetry = a
            saveSettings()
          
            task.spawn(function()
                while task.wait() do
                    if not _G.Settings.AutoRetry then break end
                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("RetryDungeon")
                end
            end)
        end
    })

    SettingFolder:AddToggle({
        text = "Auto Skill", 
        state = _G.Settings.AutoSkill,
        callback = function(a) 
            _G.Settings.AutoSkill = a
            saveSettings()

            task.spawn(function()
                while task.wait(.5) do
                    if not _G.Settings.AutoSkill then break end
                    for i, v in pairs(keys) do
                        task.spawn(function()
                            game:GetService('VirtualInputManager'):SendKeyEvent(true, v, false, game) 
                        end)
                    end
                end
            end)
        end
    })

    SettingFolder:AddSlider({
        text = "Distance",
        value = _G.Settings.Distance,
        min = -10, 
        max = 10, 
        callback = function(a) 
            _G.Settings.Distance = a 
            saveSettings()
        end
    })

    SettingFolder:AddSlider({
        text = "Speed",
        value = _G.Settings.Speed,
        min = 10, 
        max = 150, 
        callback = function(a) 
            _G.Settings.Speed = a 
            saveSettings()
        end
    })

    CreditsFolder:AddBind({
        text = "Toggle GUI", 
        key = "LeftControl", 
        callback = function() 
            library:Close()
        end
    })

    CreditsFolder:AddButton({
        text = "Script by Uzu",
        callback = function()
            print("asd")
        end
    })

    CreditsFolder:AddButton({
        text = "Discord",
        callback = function()
            setclipboard("discord.gg/waAsQFwcBn")
        end
    })
    
    library:Init()

end
