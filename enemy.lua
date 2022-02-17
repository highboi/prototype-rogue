vars = require("vars")
general = require("general")
tmap = require("tmap")

local enemy = {}

--spawns an enemy on the tilemap
function enemy.spawnEnemy(x, y, speed, plyr)
	if speed == nil then
		speed = 1
	end
	if general.isEmpty(x, y) and not general.hasElement(x, y, plyr) and x > 5 and y > 5 then
		table.insert(vars.enemies, {image = tmap.quads[13], tile_x = x, tile_y = y, speed = speed, direction = love.math.random(1, 4)})
	end
end

--generates a certain amount of enemies
function enemy.generateEnemies(num, plyr)
	repeat
		enemy.spawnEnemy( love.math.random(1, general.getLength(vars.tilemap)), love.math.random(1, general.getLength(vars.tilemap)), 1, plyr )
	until(general.getLength(vars.enemies) == num)
end

--update each enemy sprite
function enemy.updateEnemies(plyr)
	vars.enemyCooldown = vars.enemyCooldown - 1

	for i,v in ipairs(vars.enemies) do
		for j,b in ipairs(vars.bullets) do
			if general.checkIntersection(b, v) then
				table.remove(vars.enemies, i)
				vars.dieSound:play()
			end
		end
		if vars.enemyCooldown < 1 then
			if v.direction == 1 then
				if general.isEmpty(v.tile_x, v.tile_y - v.speed) and not general.hasElement(v.tile_x, v.tile_y - v.speed, plyr) then
					v.tile_y = v.tile_y - v.speed
				else
					v.direction = 3
				end
			elseif v.direction == 3 then
				if general.isEmpty(v.tile_x, v.tile_y + v.speed) and not general.hasElement(v.tile_x, v.tile_y + v.speed, plyr) then
					v.tile_y = v.tile_y + v.speed
				else
					v.direction = 1
				end
			elseif v.direction == 2 then
				if general.isEmpty(v.tile_x - v.speed, v.tile_y) and not general.hasElement(v.tile_x - v.speed, v.tile_y, plyr) then
					v.tile_x = v.tile_x - v.speed
				else
					v.direction = 4
				end
			elseif v.direction == 4 then
				if general.isEmpty(v.tile_x + v.speed, v.tile_y) and not general.hasElement(v.tile_x + v.speed, v.tile_y, plyr) then
					v.tile_x = v.tile_x + v.speed
				else
					v.direction = 2
				end
			end
		end

		if general.getDist(plyr.tile_x, plyr.tile_y, v.tile_x, v.tile_y) <= 5 then
			xdist = v.tile_x - plyr.tile_x
			ydist = v.tile_y - plyr.tile_y

			if xdist > 0 and ydist > 0 and general.isEmpty(plyr.tile_x+1, plyr.tile_y+1) then
				if math.abs(xdist) > math.abs(ydist) then
					v.direction = 2
				elseif math.abs(xdist) < math.abs(ydist) then
					v.direction = 1
				end
			elseif xdist < 0 and ydist > 0 and general.isEmpty(plyr.tile_x-1, plyr.tile_y+1) then
				if math.abs(xdist) > math.abs(ydist) then
					v.direction = 4
				elseif math.abs(xdist) < math.abs(ydist) then
					v.direction = 1
				end
			elseif xdist > 0 and ydist < 0 and general.isEmpty(plyr.tile_x+1, plyr.tile_y-1) then
				if math.abs(xdist) > math.abs(ydist) then
					v.direction = 2
				elseif math.abs(xdist) < math.abs(ydist) then
					v.direction = 3
				end
			elseif xdist < 0 and ydist < 0 and general.isEmpty(plyr.tile_x-1, plyr.tile_y-1) then
				if math.abs(xdist) > math.abs(ydist) then
					v.direction = 4
				elseif math.abs(xdist) < math.abs(ydist) then
					v.direction = 3
				end
			end

			if xdist == 0 and general.isEmpty(plyr.tile_x, plyr.tile_y+1) then
				v.direction = 1
			elseif xdist == 0 and general.isEmpty(plyr.tile_x, plyr.tile_y-1) then
				v.direction = 3
			end

			if ydist == 0 and general.isEmpty(plyr.tile_x+1, plyr.tile_y) then
				v.direction = 2
			elseif ydist == 0 and general.isEmpty(plyr.tile_x-1, plyr.tile_y) then
				v.direction = 4
			end
		end
	end

	if vars.enemyCooldown < 1 then
		vars.enemyCooldown = vars.enemyoriginal
	end
end

--draw the enemies in the game
function enemy.drawEnemies()
	for i,v in ipairs(vars.enemies) do
		love.graphics.draw(vars.image, v.image, v.tile_x * vars.width, v.tile_y * vars.height)
	end
end

return enemy
