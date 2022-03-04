local games = "https://raw.githubusercontent.com/uzu01/lua/main/games/"

local link = {
    [8739926633] = "https://rawscripts.net/raw/MWS-or-Tree-Farm_854",
    [2655311011] = games.."Anime%20Dimension.lua",
    [8357510970] = games.."Anime%20Punching%20Simulator.lua",
    [8592863835] = games.."Magnet%20Simulator%202.lua",
    [8554378337] = games.."Weapon%20Fighting%20Simulator.lua" ,
    [8448735476] = games.."DBZ%20Unleashed.lua" ,
    [6329844902] = games.."Last%20Pirates.lua" , 
    [8140820363] = games.."Anime%20Heroes%20.lua" , 
    [7560156054] = games.."Clicker%20Simulator.lua" ,
    [8649665676] = games.."Anime%20Punching%20Simulator%20New%20World.lua",
    [7549520141] = games.."Anime%20Power%20Simulator.lua",
    [7363858705] = games.."Fish%20Sim.lua",
    [7989049516] = games.."Anime%20Masters.lua",
    [8311081337] = games.."One%20Piece%3A%20Bursting%20Rage.lua",
    [8607531509] = games.."Rap%20Simulator.lua",
    [7114303730] = games.."Dragon%20Orbz.lua",
    [8540346411] = games.."RebirthChampionsX.lua",
    [7107498084] = games.."AnimeBattleTycoon.lua",
    [8357510970] = games.."Anime%20Punching%20Simulator.lua",
    [8472242071] = games.."HeroFightersSimulator.lua"
}

for i, v in pairs(link) do
    if i == game.PlaceId or i == game.GameId then
        loadstring(game:HttpGet(v))()
    end
end
