repeat wait() until game:IsLoaded()
 
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)
 
local player =      game:GetService("Players").LocalPlayer
local area =        player.Area
local fire =        player.Fire
local fire_space =  player.FireSpace
 
function mic()
    local asd
    for i, v in pairs(game:GetService("Workspace").Studio.Items:GetChildren()) do
        if string.match(v.Name,"MIC") then
            asd = v.ID.Value
        end
    end
    return asd
end
 
local library = loadstring(game:HttpGet("https://pastebin.com/raw/Uz6HijUN", true))()
local w = library:CreateWindow("Rap Simulator")
 
w:Toggle("Enabled", {flag = "toggle1"}, function(v)
    _G.autofarm = v
 
    task.spawn(function()
         while wait(.5) do 
            if not _G.autofarm then break end
            pcall(function()
                -- Mic Thingy??
                if area.Value == "Stage" and fire.Value < fire_space.Value then 
                    wait(1.5)
                    game:GetService("ReplicatedStorage").Remotes.RequestEquip:FireServer()
                    repeat task.wait()
                        game:GetService("ReplicatedStorage").Remotes.Flick:FireServer()
                    until fire.Value == fire_space.Value or not _G.autofarm
                end
                -- Rap thingy??
                if area.Value == "House" then 
                    wait(1.5)
                    repeat task.wait()
                        game:GetService("ReplicatedStorage").Remotes.Flick:FireServer(tonumber(mic()))
                    until fire.Value == 0 or not _G.autofarm
                    wait(1.5)
                    game:GetService("ReplicatedStorage").Remotes.ToStage:FireServer()
                end
                -- Tele to House
                if fire.Value == fire_space.Value and area.Value ~= "House" then
                    wait(1.5)
                    game:GetService("ReplicatedStorage").Remotes.ToHouse:FireServer()
                end
                -- Tele to Stage
                if fire.Value < fire_space.Value and area.Value == "Lobby" then
                    wait(1.5)
                    game:GetService("ReplicatedStorage").Remotes.ToStage:FireServer()
                end
            end)
        end
    end)
end)

w:Toggle("Buy Stand", {flag = "a"}, function(v)
    _G.autobuy = v

    task.spawn(function()
        while task.wait(1) do
            if not _G.autobuy then break end
            -- Buy Stand
            for i, v in pairs(game:GetService("Workspace").UpgradeInt.Stand:GetChildren()) do
                game:GetService("ReplicatedStorage").Remotes.BuyStand:FireServer(tonumber(v.Name))
            end
        end
    end)
end)

w:Toggle("Buy Mic", {flag = "a"}, function(v)
    _G.autobuy2 = v

    task.spawn(function()
        while task.wait(1) do
            if not _G.autobuy2 then break end
            -- Buy Held
            for i, v in pairs(game:GetService("Workspace").UpgradeInt.Held:GetChildren()) do
                game:GetService("ReplicatedStorage").Remotes.BuyHeld:FireServer(tonumber(v.Name))
            end
        end
    end)
end)

w:Toggle("Get Trash", {flag = "a"}, function(v)
    _G.trash = v

    task.spawn(function()
        while task.wait() do
            if not _G.trash then break end
            for _, v in pairs({"Bottle", "Water Bottle", "Solo Cup"}) do
                game:GetService("ReplicatedStorage").Remotes.PickUpItem:FireServer(v)
                game:GetService("ReplicatedStorage").Remotes.TrashItem:FireServer(v)
            end
        end
    end)
end)
