vars = require("vars")

local general = {}

function general.sleep(a) 
	local sec = tonumber(os.clock() + a); 
	while (os.clock() < sec) do 
	end 
end

function general.isEmpty(x, y)
	if x <= general.getLength(vars.tilemap[1]) and y <= general.getLength(vars.tilemap) and x > 0 and y > 0 then
		for i,v in ipairs(vars.whitelist) do
			if vars.tilemap[y][x] == v then
				return true
			end
		end
		return vars.tilemap[y][x] == 0
	else
		return false
	end
end

function general.getLength(tab)
	length = 0
	for i,v in ipairs(tab) do
		length = length + 1
	end
	return length
end

function general.getDist(x1,y1, x2,y2)
	xcoord1 = x1 + (vars.width/2)
	xcoord2 = x2 + (vars.width/2)
	ycoord1 = y1 + (vars.height/2)
	ycoord2 = y2 + (vars.height/2)
	return ((xcoord2-xcoord1)^2+(ycoord2-ycoord1)^2)^0.5
end

function general.nextLevel(levels, tmap, player, plyr, enemy)
	levels.nextLevel(plyr)
	tmap.updateMap()
	player.reset(plyr)
	vars.enemies = {}
	enemy.generateEnemies(vars.enemyAmount, plyr)
end

function general.hasElement(x, y, plyr)
	for i,v in ipairs(vars.enemies) do
		if x == v.tile_x and y == v.tile_y then
			return true
		end
	end

	if x == plyr.tile_x and y == plyr.tile_y then
		return true
	end
end

function general.checkIntersection(obj1, obj2)
	if obj1.tile_x ~= nil and obj1.tile_y ~= nil then
		obj1.x = obj1.tile_x * vars.width
		obj1.y = obj1.tile_y * vars.height
	end

	if obj2.tile_x ~= nil and obj2.tile_y ~= nil then
		obj2.x = obj2.tile_x * vars.width
		obj2.y = obj2.tile_y * vars.height
	end

	--check collisions with the bottom right corner of the first object and the top left corner of the second object
	if (obj1.x <= obj2.x and obj1.y <= obj2.y and obj1.x + vars.width > obj2.x and obj1.y + vars.height > obj2.y) then
 		return true
	end

	if (obj1.x < obj2.x and obj1.y > obj2.y and obj1.x + vars.width > obj2.x and obj1.y < obj2.y + vars.height) then
		return true
	end

	if (obj1.x > obj2.x and obj1.y < obj2.y and obj1.x < obj2.x + vars.width and obj1.y + vars.height > obj2.y) then
		return true
	end

	if (obj1.x > obj2.x and obj1.y > obj2.y and obj1.x < obj2.x + vars.width and obj1.y < obj2.y + vars.height) then
		return true
	end
end

function general.checkCollision(obj1, obj2)
	if obj1.tile_x ~= nil and obj1.tile_y ~= nil then
		obj1.x = obj1.tile_x * vars.width
		obj1.y = obj1.tile_y * vars.height
	end

	if obj2.tile_x ~= nil and obj2.tile_y ~= nil then
		obj2.x = obj2.tile_x * vars.width
		obj2.y = obj2.tile_y * vars.height
	end

	if (obj1.x <= obj2.x and obj1.y <= obj2.y and obj1.x + vars.width >= obj2.x and obj1.y + vars.height >= obj2.y) then
		return true
	end

	if (obj1.x <= obj2.x and obj1.y >= obj2.y and obj1.x + vars.width >= obj2.x and obj1.y <= obj2.y + vars.height) then
		return true
	end

	if (obj1.x >= obj2.x and obj1.y <= obj2.y and obj1.x <= obj2.x + vars.width and obj1.y + vars.height >= obj2.y) then
		return true
	end

	if (obj1.x >= obj2.x and obj1.y >= obj2.y and obj1.x <= obj2.x + vars.width and obj1.y <= obj2.y + vars.height) then
		return true
	end
end

return general
