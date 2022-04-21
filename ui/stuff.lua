local TeleportService = game:GetService("TeleportService")
local foundAnything = ""

local function Serverhop1(PlaceID)
    local Site
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
        end)
    end
end

local function Serverhop2(PlaceID)
    while task.wait() do
        pcall(function()
            Serverhop1(PlaceID)
            if foundAnything ~= "" then
                Serverhop1(PlaceID)
            end
        end)
    end
end

local Util = {}

function Util:Rejoin()
    TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,game.Players.LocalPlayer)
end

function Util:ServerHop(a)
	local lol = a or game.PlaceId
	Serverhop2(lol)
end

function Util:ServerhopLow(a)
	local lol = a or game.PlaceId
	Serverhop2(lol)
end

return Util
