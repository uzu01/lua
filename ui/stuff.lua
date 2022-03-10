local TeleportService = game:GetService("TeleportService")

local Util = {}

function Util:Rejoin()
    TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,game.Players.LocalPlayer)
end

function Util:ServerHop()
    while task.wait() do
        local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for i,v in pairs(Servers.data) do
            if v.id ~= game.JobId then
                task.wait()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end
end

function Util:ServerhopLow()
    while task.wait() do
        local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for i,v in pairs(Servers.data) do
            if v.id ~= game.JobId and v.playing <= 3 then
                task.wait()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end
end

return Util
