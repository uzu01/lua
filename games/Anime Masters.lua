repeat wait() until game:IsLoaded()
 
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.autofarm = false
_G.autoenergy = false
_G.autorebirth = false

local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
local selected_enemy = workspace.Punchable.NeonDummies.NeonDummy:FindFirstChild("Meshes/Dum4")
local selected_egg = "CommonEgg"
local mob = {}
local egg = {}

for i, v in pairs(game.Workspace.Punchable:GetChildren()) do
    for i2, v2 in pairs(v:GetChildren()) do
        if not table.find(mob,v2.Name) then
            table.insert(mob,v2.Name)
        end
    end
end

for i, v in pairs(game:GetService("Workspace").Map.Eggs:GetChildren()) do
    if v:IsA("Model") then
        table.insert(egg,v.Name)
    end
end

function getNear()
    local nearr,near = math.huge
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart

    for i, v in pairs(game.Workspace.Punchable:GetChildren()) do
        for i2, v2 in pairs(v:GetChildren()) do
            if v2.Name == selected_mob and (plr.CFrame.p - v2.Hitbox.CFrame.p).Magnitude < nearr then
                near = v2.Hitbox
                nearr = (plr.CFrame.p - v2.Hitbox.CFrame.p).Magnitude
            end
        end
    end
    return near
end

function teleport(mob)
    local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
    plr.CFrame = mob.CFrame * CFrame.new(0,0,5)
end

local library = loadstring(game:HttpGetAsync("https://pastebin.com/raw/znibQh36"))()
local window = library:CreateWindow("Anime Punching")
local farming_folder = window:AddFolder('Farming')
local egg_folder = window:AddFolder('Pets')
local misc_folder = window:AddFolder('Misc')

farming_folder:AddToggle({
    text = "Auto Farm", 
    state = false,
    callback = function(v) 
        _G.autofarm = v

        task.spawn(function()
            while task.wait() do
                if not _G.autofarm then break end
                teleport(getNear())
                game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.3").knit.Services.PlayerService.RE.DealDamage:FireServer(getNear())
            end
        end) 
    end
})

farming_folder:AddList({
    text = "Select Mob", 
    values = mob, 
    callback = function(v) 
        selected_mob = v
    end
})

farming_folder:AddToggle({
    text = "Farm Energy", 
    state = false,
    callback = function(v) 
        _G.farmenergy = v

        task.spawn(function()
            while task.wait() do
                if not _G.farmenergy then break end
                game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.3").knit.Services.PlayerService.RE.Punch:FireServer()
            end
        end) 
    end
})

farming_folder:AddToggle({
    text = "Auto Rebirth", 
    state = false,
    callback = function(v) 
        _G.autorebirth = v

        task.spawn(function()
            while task.wait() do
                if not _G.autorebirth then break end
                game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.3").knit.Services.PlayerService.RE.Rebirth:FireServer()
            end
        end) 
    end
})

egg_folder:AddToggle({
    text = "Open Egg", 
    state = false,
    callback = function(v) 
        _G.openegg = v

        task.spawn(function()
            while task.wait() do
                if not _G.openegg then break end
                game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.4.3").knit.Services.PetService.RF.Hatch:InvokeServer(selected_egg,false)
            end
        end) 
    end
})

egg_folder:AddList({
    text = "Select Mob", 
    values = egg, 
    callback = function(v) 
        selected_egg = v
    end
})

misc_folder:AddButton({
    text = "Delete Nametag",
    callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Head.PlayerOverhead:Destroy()
        end)
    end
})

misc_folder:AddBind({
    text = "Toggle GUI", 
    key = "LeftControl", 
    callback = function() 
        library:Close()
    end
})

misc_folder:AddButton({
    text = "Script by Uzu",
    callback = function()
        print("A")
    end
})

misc_folder:AddButton({
    text = "discord.gg/waAsQFwcBn",
    callback = function()
        setclipboard("discord.gg/waAsQFwcBn")
    end
})

library:Init()