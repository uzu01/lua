if game.GameId == 2655311011 then -- Anime Dimension
    a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Anime%20Dimension.lua"
elseif game.PlaceId == 8448735476 then -- DBZ Unleashed 
    a = "https://raw.githubusercontent.com/uzu01/lua/main/games/DBZ%20Unleashed.lua"
elseif game.PlaceId == 8592863835 then -- Magnet Simulator 2
    if game:GetService("UserInputService").TouchEnabled and game:GetService("UserInputService").KeyboardEnabled == false then
        a = "https://raw.githubusercontent.com/uzu01/lua/main/games/mobile/Magnet%20Simulator%202%20Mobile.lua"
    else
        a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Magnet%20Simulator%202.lua"
    end
elseif game.PlaceId == 6329844902 then -- Last Pirates
    a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Last%20Pirates.lua"
elseif game.PlaceId == 8140820363 then -- Anime Heroes
    a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Anime%20Heroes%20.lua" 
elseif game.PlaceId == 7560156054 then -- Clicker Simulator
    a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Clicker%20Simulator.lua" 
elseif game.PlaceId == 8649665676 then -- Anime Punching Simulator New World
    a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Anime%20Punching%20Simulator%20New%20World.lua" 
elseif game.PlaceId == 7549520141 then -- Anime Power Simulator
    a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Anime%20Power%20Simulator.lua"
elseif game.PlaceId == 8554378337 then -- Weapon Fighting Simulator
    if game:GetService("UserInputService").TouchEnabled and game:GetService("UserInputService").KeyboardEnabled == false then
        a = "https://raw.githubusercontent.com/uzu01/lua/main/games/mobile/Weapon%20Fighting%20Simulator%20Mobile.lua"
    else
        a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Weapon%20Fighting%20Simulator.lua" 
    end
elseif game.PlaceId == 8357510970 then -- Anime Punching Simulator
    if game:GetService("UserInputService").TouchEnabled and game:GetService("UserInputService").KeyboardEnabled == false then
        a = "https://raw.githubusercontent.com/uzu01/lua/main/games/mobile/Anime%20Punching%20Simulator%20Mobile.lua"
    else
        a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Anime%20Punching%20Simulator.lua"
    end
elseif game.PlaceId == 7363858705 then -- Fish Sim
    a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Fish%20Sim.lua" 
elseif game.PlaceId == 7989049516 then -- Anime Masters
    a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Anime%20Masters.lua" 
elseif game.PlaceId == 8311081337 then -- One Piece:Bursting Rage
    a = "https://raw.githubusercontent.com/uzu01/lua/main/games/One%20Piece%3A%20Bursting%20Rage.lua" 
elseif game.PlaceId == 8607531509 then -- Rap Simulator
    a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Rap%20Simulator.lua" 
elseif game.PlaceId == 7114303730 then -- Dragon Orbz
    a = "https://raw.githubusercontent.com/uzu01/lua/main/games/Dragon%20Orbz.lua"
end

loadstring(game:HttpGet(a))()
