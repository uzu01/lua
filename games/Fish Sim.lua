repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.autofarm = false
_G.autoEgg = false

local bb = game:GetService("VirtualUser")
local VIM = game:GetService('VirtualInputManager')
local tickk = tick()
local a = game.Players.LocalPlayer
local plr = game.Workspace.Players[a.Name].Root
local world = {}
local egg = {}

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    bb:CaptureController()
    bb:ClickButton2(Vector2.new())
end)

for i, v in pairs(game.Workspace.Worlds:GetChildren()) do
    if not table.find(world,v.Name) then
        table.insert(world,v.Name)
    end
end

for i, v in pairs(game.Workspace.Worlds:GetDescendants()) do
    if v.Name == "GUIPART" and not table.find(egg, v.Parent.Parent.Parent.Parent.Name.." "..v.SurfaceGui.TextLabel.Text) then
        table.insert(egg, v.Parent.Parent.Parent.Parent.Name.." "..v.SurfaceGui.TextLabel.Text)
    end
end

function getNear()
    local near;
    local nearr = math.huge
    
    for i, v in pairs(game.Workspace.Worlds:GetChildren()) do
        if _G.selectedWorld == v.Name then
            for i2, v2 in pairs(v:GetChildren()) do
                if v2.Name == 'Bubbles' then
                    for i3, v3 in pairs(v2:GetChildren()) do
                        for i4, v4 in pairs(v3:GetChildren()) do
                            if v4.ClassName == "Model" then
                                if (plr.Position - v4.Parent.InteractHitbox.Position).Magnitude < nearr then
                                    near = v4.Parent.InteractHitbox
                                    nearr = (plr.Position - v4.Parent.InteractHitbox.Position).Magnitude
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return near
end

function Tween(Enemy)
    local plr = game.Workspace.Players[a.Name].Root

    local t = game:GetService("TweenService"):Create(plr, TweenInfo.new(1, Enum.EasingStyle.Quad), {CFrame = Enemy.CFrame * CFrame.new(0,8,0)})
    t:Play()
end

game.Workspace.Players[a.Name].CharacterModel.Body.CanCollide = false

local name = "Fish Sim"
for i, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == name then
        v:Destroy()
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/VenyxUI/main/Reuploaded"))()
local venyx = library.new(tostring(name), 5012544693)

local themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(20, 20, 20),
    DarkContrast = Color3.fromRGB(14, 14, 14),  
    TextColor = Color3.fromRGB(255, 255, 255)
}

local page1 = venyx:addPage("Main", 5012544693)
local sec1 = page1:addSection("Farm")

sec1:addToggle("Farm Nearest", nil, function(v)
    _G.autofarm = v

    game:GetService("ReplicatedStorage").Events.Player.Portal:FireServer(_G.selectedWorld)
    
    task.spawn(function()
        while task.wait(.8) do
            if not _G.autofarm then break end
            pcall(function()
                local coral = getNear()

                Tween(coral)
                VIM:SendKeyEvent(true, "E", false, game)
                VIM:SendKeyEvent(false, "E", false, game)
            end)
        end
    end)
end)

sec1:addDropdown("Select World", world, function(v)
    _G.selectedWorld = v
end)

sec1:addToggle("Buy Egg", nil, function(v)
    _G.autoEgg = v

    game:GetService("ReplicatedStorage").Events.Player.Portal:FireServer(_G.selectedEgg.Parent.Parent.Parent.Parent.Name)

    task.spawn(function()
        while task.wait() do
            if not _G.autoEgg then break end
            Tween(_G.selectedEgg)
            game:GetService("ReplicatedStorage").Events.Game.Egg:FireServer(_G.selectedEgg.Parent.Parent,false)
        end
    end)
end)

sec1:addDropdown("Select Egg", egg, function(value)
    for i, v in pairs(game.Workspace.Worlds:GetDescendants()) do
        if v.Name == "GUIPART" and string.find(value,v.SurfaceGui.TextLabel.Text) then
            _G.selectedEgg = v
        end
    end
end)

local page2 = venyx:addPage("Misc", 5012544693)
local sec2 = page2:addSection("Local Player")
local sec3 = page2:addSection("Credits")

sec2:addButton("200x Swim Speed",function()
    local hat = require(game:GetService("ReplicatedStorage").Data.Hats)

    for i, v in pairs(hat.Data) do
        v.Speed = 200
    end
end)

sec3:addButton("Created by Uzu", function() 
    print("ASD")
end)

sec3:addButton("discord.gg/waAsQFwcBn", function()
    setclipboard(tostring("discord.gg/waAsQFwcBn"))
end)

sec3:addKeybind("Keybind", Enum.KeyCode.LeftControl, function()
    venyx:toggle()
end)

sec3:addButton("Delete Gui", function()
    for i, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == name then
            v:Destroy()
        end
    end
end)

venyx:SelectPage(venyx.pages[1], true)

print("script took",string.format("%.0f",tick()-tickk),"seconds to load")