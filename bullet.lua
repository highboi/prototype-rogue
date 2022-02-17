vars = require("vars")
tmap = require("tmap")
general = require("general")

local bullet = {}

function bullet.shootBullet(start_x, start_y, direction, spd)
	local speed = spd or 500

	if direction == "up" then
		table.insert(vars.bullets, {x = start_x, y = start_y, dx = 0, dy = -speed, image = tmap.quads[15]})
	elseif direction == "down" then
		table.insert(vars.bullets, {x = start_x, y = start_y, dx = 0, dy = speed, image = tmap.quads[15]})
	elseif direction == "left" then
		table.insert(vars.bullets, {x = start_x, y = start_y, dx = -speed, dy = 0, image = tmap.quads[14]})
	elseif direction == "right" then
		table.insert(vars.bullets, {x = start_x, y = start_y, dx = speed, dy = 0, image = tmap.quads[14]})
	end
end

function bullet.updateBullets(dt)
	for i,v in ipairs(vars.bullets) do
		v.x = v.x + v.dx * dt
		v.y = v.y + v.dy * dt

		for y=1,general.getLength(vars.tilemap) do --looping through y coords
			for x=1,general.getLength(vars.tilemap[vars.currentlevel]) do --looping through x coords
				currentSquare = {tile_x = x, tile_y = y}
				local amnt = 0
				for i,v in ipairs(vars.whitelist) do
					if vars.tilemap[y][x] ~= v then
						amnt = amnt + 1
					end
				end
				if general.checkIntersection(v, currentSquare) and vars.tilemap[y][x] ~= 0 and amnt == general.getLength(vars.whitelist) then
					table.remove(vars.bullets, i)
				end
			end
		end
	end
end

function bullet.drawBullets()
	for i,v in ipairs(vars.bullets) do
		love.graphics.draw(vars.image, v.image, v.x, v.y)
	end
end

return bullet
