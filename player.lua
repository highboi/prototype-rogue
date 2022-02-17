vars = require("vars")
bullet = require("bullet")
general = require("general")
tmap = require("tmap")
levels = require("levels")
menu = require("menu")

local player = {}

function player.init(x, y, img, powup, bullamount)
	plyr = {
		image = img,
		tile_x = x,
		tile_y = y,
		powerup = powup,
		cooldown = 2,
		bullets = bullamount,
		gameover = true,
		won = false,
		dead = false,
		health = 10
	}

	player.initialBullamount = bullamount
	return plyr
end

function player.reset(plyr)
	plyr.tile_x = 2
	plyr.tile_y = 2
	plyr.powerup = nil
	plyr.bullets = player.initialBullamount
end

function player.powerups(plyr, key)
	if plyr.powerup == nil then
		if key == "w" then
			vars.fireSound:play()
			bullet.shootBullet(plyr.tile_x*vars.width, plyr.tile_y*vars.height, "up")
			if plyr.bullets ~= nil then
				plyr.bullets = plyr.bullets - 1
			end
		elseif key == "s" then
			vars.fireSound:play()
			bullet.shootBullet(plyr.tile_x*vars.width, plyr.tile_y*vars.height, "down")
			if plyr.bullets ~= nil then
				plyr.bullets = plyr.bullets - 1
			end
		elseif key == "a" then
			vars.fireSound:play()
			bullet.shootBullet(plyr.tile_x*vars.width, plyr.tile_y*vars.height, "left")
			if plyr.bullets ~= nil then
				plyr.bullets = plyr.bullets - 1
			end
		elseif key == "d" then
			vars.fireSound:play()
			bullet.shootBullet(plyr.tile_x*vars.width, plyr.tile_y*vars.height, "right")
			if plyr.bullets ~= nil then
				plyr.bullets = plyr.bullets - 1   
			end
		end
	end
end

function player.update(plyr, dt)
	local x = plyr.tile_x
	local y = plyr.tile_y

	plyr.cooldown = plyr.cooldown - 1

	if plyr.cooldown < 1 then
		if love.keyboard.isDown("left") then
			x = x - 1
		elseif love.keyboard.isDown("right") then
			x = x + 1
		elseif love.keyboard.isDown("up") then
			y = y - 1
		elseif love.keyboard.isDown("down") then
			y = y + 1
		end
		plyr.cooldown = 2
	end

	if plyr.bullets == 0 then
		vars.playing = false
		plyr.gameover = true
		plr.dead = true
		vars.bullets = {}
		vars.menuBtn = menu.makeBtn("MENU", 550, 370, 100, 40, 255, 20, 147)
	end

	for i,v in ipairs(vars.enemies) do
		if general.checkCollision(plyr, v) then
			plyr.health = plyr.health - 1
			love.graphics.setColor(1, 0, 0)

			if v.tile_x == plyr.tile_x then
				if v.tile_y < plyr.tile_y then
					v.tile_y = v.tile_y - 2
				elseif v.tile_y > plyr.tile_y then
					v.tile_y = v.tile_y + 2
				end
			elseif v.tile_y == plyr.tile_y then
				if v.tile_x < plyr.tile_x then
					v.tile_x = v.tile_x - 2
				elseif v.tile_x > plyr.tile_x then
					v.tile_x = v.tile_x + 2
				end
			else
				if v.tile_x < plyr.tile_x and v.tile_y < plyr.tile_y then
					v.tile_x = v.tile_x - 2
					v.tile_y = v.tile_y - 2
				elseif v.tile_x > plyr.tile_x and v.tile_y > plyr.tile_y then
					v.tile_x = v.tile_x + 2
					v.tile_y = v.tile_y + 2
				elseif v.tile_x > plyr.tile_x and v.tile_y < plyr.tile_y then
					v.tile_x = v.tile_x + 2
					v.tile_y = v.tile_y - 2
				elseif v.tile_x < plyr.tile_x and v.tile_y > plyr.tile_y then
					v.tile_x = v.tile_x - 2
					v.tile_y = v.tile_y + 2
				end
			end
		else
			love.graphics.setColor(1, 1, 1)
		end
	end

	if plyr.health <= 0 then
		vars.playing = false
		plyr.gameover = true
		plyr.dead = true
		vars.bullets = {}
		vars.menuBtn = menu.makeBtn("MENU", 550, 370, 100, 40, 255, 20, 147)
	end

	if general.isEmpty(x, y) then
		plyr.tile_x = x
		plyr.tile_y = y
	end

	if general.hasElement(x, y, plyr) and vars.tilemap[y][x] == 24 and general.getLength(vars.enemies) == 0 then
		general.nextLevel(levels, tmap, player, plyr, enemy)
	end
end

function player.drawPlayer(plyr)
	love.graphics.draw(vars.image, plyr.image, plyr.tile_x * vars.width, plyr.tile_y * vars.height)
end

function player.camera(plyr, x, y)
	love.graphics.translate(-plyr.tile_x * vars.width + x, -plyr.tile_y * vars.height + y)
end

return player
