repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Hey"; 
    Text = "Make sure to use rasengan while farming";
    Duration = 20; 
}) 

_G.Damage = 9e9 

game:GetService("ReplicatedStorage").Event.Event_Summon:FireServer("GetFirstSkill","\232\158\186\230\151\139\228\184\184")
 
local player = game.Players.LocalPlayer
local plr = game.Players.LocalPlayer.Character.HumanoidRootPart
local library = loadstring(game:HttpGet("https://pastebin.com/raw/Uz6HijUN", true))()
local w = library:CreateWindow("APS")
 
w:Toggle("Enabled", {flag = "a"}, function(value)
    _G.farm = value
    
    task.spawn(function()      
        while task.wait() do
            if not _G.farm then break end
            game:GetService("ReplicatedStorage").Event.Event_Skills:FireServer({"UseSkill","\232\158\186\230\151\139\228\184\184",{10,_G.Damage,1},plr.CFrame.p,player})
        end
    end)
end)