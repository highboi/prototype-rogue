vars = require("vars")
menu = require("menu")
tmap = require("tmap")
bullet = require("bullet")
general = require("general")
enemy = require("enemy")
player = require("player")
levels = require("levels")

function love.load()
	--stop anti-aliasing
	love.graphics.setDefaultFilter("nearest", "nearest")

	--set the screen title
	love.window.setTitle("Ghosts and Demon Heads")

	--resize the window
	love.window.setMode(1200, 800)

	--the tile width and height is imported from the tmap library
	width = vars.width
	height = vars.height

	--the tileset image
	image = vars.image

	vars.playBtn = menu.makeBtn("PLAY", 550, 230, 100, 40, 255, 20, 147)
	vars.exitBtn = menu.makeBtn("EXIT", 550, 300, 100, 40, 255, 20, 147)

	plyr = player.init(2, 2, tmap.quads[1], nil, nil)

	enemy.generateEnemies(vars.enemyAmount, plyr)
end

function love.keypressed(key)
	if vars.playing then
		player.powerups(plyr, key)
	end
end

function nextLevel()
	levels.nextLevel(plyr)
	tmap.updateMap()
	player.reset(plyr)
	vars.enemies = {}
	enemy.generateEnemies(vars.enemyAmount, plyr)
end

function resetAll()
	vars.playing = false
	vars.currentlevel = 1
	tmap.updateMap()
	player.reset(plyr)
	vars.enemies = {}
	enemy.generateEnemies(vars.enemyAmount, plyr)
	plyr.gameover = true
end

function love.update(dt)
	if vars.playing then
		player.update(plyr, dt)

		bullet.updateBullets(dt)

		enemy.updateEnemies(plyr)

		if plyr.gameover then
			resetAll()
		end
	else
		menu.updateButtons()
	end
end

function displayText()
	love.graphics.print(string.format("LEVEL %s", vars.currentlevel), 0, 0)
	local font = love.graphics.newFont("font.ttf", 15)
	love.graphics.setFont(font)
	love.graphics.print(string.format("HEALTH: %s", plyr.health), (plyr.tile_x * vars.width)-15, (plyr.tile_y * vars.height)-15)
	local font = love.graphics.newFont("font.ttf", 30)
	love.graphics.setFont(font)
end

function love.draw()
	if vars.playing then
		plyr.gameover = false

		love.graphics.setBackgroundColor(50/255, 50/255, 50/255, 1)

		player.camera(plyr, 600, 400)

		tmap.drawMap()

		bullet.drawBullets()

		player.drawPlayer(plyr)

		enemy.drawEnemies()

		displayText()
	elseif not vars.playing and plyr.dead then
		menu.drawTitle("DEAD!", 560, 150, 30)
		menu.drawButtons()
	elseif not vars.playing and plyr.won then --if the player is alive and the game is over
		menu.drawTitle("WIN!", 570, 150, 30)
		menu.drawButtons()
	elseif not vars.playing and plyr.gameover then
		menu.drawTitle("GHOSTS and DEMONHEADS", 400, 150, 30)
		menu.drawButtons()
		menu.drawTitle("Rules:", 560, 390, 25)
		menu.drawTitle("1. Arrows to move", 530, 460, 15)
		menu.drawTitle("2. WASD to shoot", 530, 510, 15)
		menu.drawTitle("3. Shoot all demons", 530, 560, 15)
		menu.drawTitle("4. Get to the exit", 530, 610, 15)
	end
end

