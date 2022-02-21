repeat wait() until game:IsLoaded()
 
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)
 
local player =      game:GetService("Players").LocalPlayer
local area =        player.Area
local fire =        player.Fire
local fire_space =  player.FireSpace
local selected_producer = 1
local selected_computer = 1
local prod = {}
local comp = {}

for i, v in pairs(game:GetService("Workspace"):GetDescendants()) do
    if v.Name == "Producer" and v:IsA("NumberValue") then
        table.insert(prod,v.Parent.Parent.Parent.Name..' '..v.Value)
    end
end

for i, v in pairs(game:GetService("Workspace"):GetDescendants()) do
    if v.Name == "Computer" and v:IsA("NumberValue") then
        table.insert(comp,v.Parent.Parent.Parent.Name..' '..v.Value)
    end
end

table.sort(prod, function(a,b) return string.match(a,"%d") < string.match(b,"%d") end)
table.sort(comp, function(a,b) return string.match(a,"%d") < string.match(b,"%d") end)

function mic()
    local asd
    for i, v in pairs(game:GetService("Workspace").Studio.Items:GetChildren()) do
        if string.match(v.Name,"MIC") then
            asd = v.ID.Value
        end
    end
    return asd
end
 
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/uzu01/lua/main/ui/wallyv2.lua", true))()
local w = library:CreateWindow("Farming")
local c = library:CreateWindow("Upgrades")
local d = library:CreateWindow("Chest")
local e = library:CreateWindow("Teleports")
 
w:Toggle("Full Auto Farm", {flag = "toggle1"}, function(v)
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

w:Toggle("Auto Get Trash", {flag = "a"}, function(v)
    _G.trash = v

    task.spawn(function()
        while task.wait(.2) do
            if not _G.trash then break end
            for _, v in pairs({"Bottle", "Water Bottle", "Solo Cup"}) do
                game:GetService("ReplicatedStorage").Remotes.PickUpItem:FireServer(v)
                game:GetService("ReplicatedStorage").Remotes.TrashItem:FireServer(v)
            end
        end
    end)
end)

c:Toggle("Buy Stand", {flag = "a"}, function(v)
    _G.autobuy = v

    task.spawn(function()
        while task.wait() do
            if not _G.autobuy then break end
            -- Buy Stand
            for i, v in pairs(game:GetService("Workspace").UpgradeInt.Stand:GetChildren()) do
                game:GetService("ReplicatedStorage").Remotes.BuyStand:FireServer(tonumber(v.Name))
            end
        end
    end)
end)

c:Toggle("Buy Mic", {flag = "a"}, function(v)
    _G.autobuy2 = v

    task.spawn(function()
        while task.wait() do
            if not _G.autobuy2 then break end
            -- Buy Held
            for i, v in pairs(game:GetService("Workspace").UpgradeInt.Held:GetChildren()) do
                game:GetService("ReplicatedStorage").Remotes.BuyHeld:FireServer(tonumber(v.Name))
            end
        end
    end)
end)

d:Toggle("Producer Chest", {flag = "a"}, function(v)
    open_producer = v

    task.spawn(function()
        while task.wait() do
            if not open_producer then break end
            game:GetService("ReplicatedStorage").Remotes.RequestSpin:FireServer(tonumber(selected_producer),false)
            game:GetService("ReplicatedStorage").Remotes.SpinFinish:FireServer()
        end
    end)
end)

d:Dropdown("Select Chest", {flag = "a", list = prod}, function(v)
    selected_producer = string.match(v,"%d+")
end)

d:Toggle("Computer Chest", {flag = "a"}, function(v)
    open_computer= v

    task.spawn(function()
        while task.wait() do
            if not open_computer then break end
            game:GetService("ReplicatedStorage").Remotes.RequestSpin:FireServer(tonumber(selected_computer),true)
            game:GetService("ReplicatedStorage").Remotes.SpinFinish:FireServer()
        end
    end)
end)

d:Dropdown("Select Chest", {flag = "a", list = comp}, function(v)
    selected_computer = string.match(v,"%d+")
end)

for i, v in pairs(require(game:GetService("ReplicatedStorage").Modules.Towns)) do
    for a, b in pairs(v) do
        if a == "Name" then
            e:Button(b, function()
                game:GetService("ReplicatedStorage").Remotes.Fly:FireServer(b)
            end)
        end
    end
end
