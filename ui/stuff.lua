local TeleportService = game:GetService("TeleportService")
local playerr = 3
local PlaceID = game.PlaceId
local foundAnything = ""

function TPReturner()
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
		if v.playing <= playerr then
			pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
            end)
		end
	end
end
 
function Teleport()
	while task.wait() do
		pcall(function()
			TPReturner()
			if foundAnything ~= "" then
				TPReturner()
			end
		end)
	end
end

local Util = {}

function Util:Rejoin()
    TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,game.Players.LocalPlayer)
end

function Util:ServerHop()
	Teleport()
end

function Util:ServerhopLow()
	Teleport()
end

return Util
