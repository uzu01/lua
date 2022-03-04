loadstring(game:HttpGet("https://rawscripts.net/raw/loader_1038"))()

game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
    Text = "Check Your Clipboard for New Script Link",
    Color = Color3.new(0, 191, 255),
    Font = Enum.Font.Cartoon,
    TextSize = 16,
})

setclipboard('loadstring(game:HttpGet("https://rawscripts.net/raw/loader_1038"))()')
