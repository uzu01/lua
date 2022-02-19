repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local isTriple = "Single"

function GetNearestEgg()
    local nearr = math.huge
    local near
    local plr = Player.Character.HumanoidRootPart

    for i, v in pairs(game:GetService("Workspace").Scripts.Eggs:GetChildren()) do
        if (plr.CFrame.p - v.Egg.Egg.CFrame.p).Magnitude < nearr then
            near = v.Name
            nearr = (plr.CFrame.p - v.Egg.Egg.CFrame.p).Magnitude
        end
    end
    return near
end

local lib = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Wait = lib.subs.Wait

local w = lib:CreateWindow({
    Name = "Rebirth Champions X",
    Themeable = {
       Info = "Script by Uzu#6389"
    }
})

local GeneralTab = w:CreateTab({
    Name = "General"
})

local FarmingSection = GeneralTab:CreateSection({
    Name = "Farming"
})

local PetSection = GeneralTab:CreateSection({
    Name = "Pets"
})

local ShopSection = GeneralTab:CreateSection({
    Name = "Shop"
})

local TeleSection = GeneralTab:CreateSection({
    Name = "Teleports",
    Side = "Right"
})

local MiscSection = GeneralTab:CreateSection({
    Name = "Misc",
    Side = "Right"
})

FarmingSection:AddToggle({
    Name = "Auto Click",
    Callback = function(v)
        _G.autoclick = v

        task.spawn(function()
            while task.wait() do
                if not _G.autoclick then break end
                ReplicatedStorage.Events.Click:FireServer()
            end
        end)
    end
})

FarmingSection:AddButton({
    Name = "Rebirth Gamepass",
    Callback = function()
        for i, v in pairs(Player.Passes:GetChildren()) do
            v.Value = true
        end
    end
})

PetSection:AddToggle({
    Name = "Open Nearest Egg",
    Callback = function(v)
        _G.autoegg = v

        task.spawn(function()
            while task.wait() do
                if not _G.autoegg then break end
                print(isTriple)
                ReplicatedStorage.Functions.Unbox:InvokeServer(GetNearestEgg(),isTriple)
            end
        end)
    end
})

PetSection:AddToggle({
    Name = "Triple Egg",
    Callback = function(v)
        asd = v

        if asd then
            isTriple = "Triple"
        else
            isTriple = "Single"
        end
    end
})

PetSection:AddToggle({
    Name = "Equip Best (10 sec)",
    Callback = function(v)
        _G.autobest = v

        task.spawn(function()
            while task.wait(10) do
                if not _G.autobest then break end
                firesignal(Player.PlayerGui.MainUI.PetsFrame.Additional.EquipBest.Click.MouseButton1Up)
            end
        end)
    end
})

PetSection:AddToggle({
    Name = "Craft All (3 sec)",
    Callback = function(v)
        _G.autocraft = v

        task.spawn(function()
            while task.wait(3) do
                if not _G.autocraft then break end
                firesignal(Player.PlayerGui.MainUI.PetsFrame.Additional.CraftAll.Click.MouseButton1Up)
            end
        end)
    end
})

ShopSection:AddToggle({
    Name = "Auto Upgrade",
    Callback = function(v)
        _G.autoupgrade = v

        task.spawn(function()
            while task.wait() do
                if not _G.autoupgrade then break end
                for i, v in pairs(require(ReplicatedStorage.Modules.UpgradesShop)) do
                    ReplicatedStorage.Functions.Upgrade:InvokeServer(tostring(i))
                end
            end
        end)
    end
})

ShopSection:AddToggle({
    Name = "Auto Buy Potion",
    Callback = function(v)
        _G.autopotion = v

        task.spawn(function()
            while task.wait() do
                if not _G.autopotion then break end
                for i, v in pairs(require(ReplicatedStorage.Modules.Potions)) do
                    ReplicatedStorage.Events.Potion:FireServer(tostring(i))
                end
            end
        end)
    end
})

for i, v in pairs(game:GetService("Workspace").Scripts.TeleportTo:GetChildren()) do
    TeleSection:AddButton({
        Name = v.Name,
        Callback = function()
            Player.Character.HumanoidRootPart.CFrame = v.CFrame
        end
    })
end

MiscSection:AddButton({
    Name = "Script by Uzu",
    Callback = function()
        setclipboard("Uzu#6389")
    end
})

MiscSection:AddButton({
    Name = "Discord Link",
    Callback = function()
        setclipboard("discord.gg/waAsQFwcBn")
    end
})
