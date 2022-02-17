general = require("general")

local menu = {}

menu.buttons = {}

menu.pink = {255/255, 113/255, 206/255}
menu.darkpink = {255/255, 20/255, 147/255}
menu.blue = {1/255, 205/255, 254/255}
menu.purple = {125/255, 53/255, 195/255}
menu.grey = {50/255, 50/255, 50/255}
menu.orange = {255/255, 96/255, 67/255}
menu.red = {255/255, 0/255, 0/255}

function menu.makeBtn(text, xcoord, ycoord, w, h, red, green, blue)
	table.insert(menu.buttons, {label = text, x = xcoord, y = ycoord, width = w, height = h, r = red, g = green, b = blue, origr = red, origg = green, origb = blue})
	return {label = text, x = xcoord, y = ycoord, width = w, height = h, r = red, g = green, b = blue, origr = red, origg = green, origb = blue}
end

function menu.removeBtn(btn)
	local len = 0
	for i,button in ipairs(menu.buttons) do
		for j,attr in ipairs(button) do
			io.write(string.format("%s\n", attr))
			if btn[j] == attr then
				len = len + 1
			end
		end

		if len == general.getLength(btn) then
			table.remove(menu.buttons, i)
			len = 0
			return true
		end
	end
end

function menu.drawTitle(label, x, y, fontsize)
	local font = love.graphics.newFont("font.ttf", fontsize)
	love.graphics.setFont(font)
	love.graphics.setColor(menu.purple)
	love.graphics.rectangle("fill", x-15, y-15, fontsize*(string.len(label)/1.5)+10, fontsize*1.6+15)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", x-15, y-15, fontsize*(string.len(label)/1.5)+10, fontsize*1.6+15)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(label, x, y)
end

function menu.drawBtn(btn)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", btn.x, btn.y, btn.width, btn.height)
	love.graphics.setColor(btn.r/255, btn.g/255, btn.b/255)
	love.graphics.rectangle("fill", btn.x, btn.y, btn.width, btn.height)
	love.graphics.setColor(0, 0, 0)
	local font = love.graphics.newFont("font.ttf", btn.height/1.6)
	love.graphics.setFont(font)
	love.graphics.print(btn.label, btn.x + (btn.width/6), btn.y + (btn.height/6))
end

function menu.updateButtons()
	love.graphics.setBackgroundColor(menu.grey)
	for i,v in ipairs(menu.buttons) do
		if love.mouse.getX() >= v.x and love.mouse.getX() <= v.x + v.width and love.mouse.getY() >= v.y and love.mouse.getY() <= v.y + v.height then
			if v.r < v.origr + 70 then
				v.r = v.r + 70
				v.g = v.g + 70
				v.b = v.b + 70
			end

			if love.mouse.isDown(1) then
				if v.label == "PLAY" then
					vars.playing = true
					plyr.health = 10
					love.graphics.setColor(1, 1, 1)
				elseif v.label == "MENU" then
					plyr.dead = false
					plyr.won = false
					menu.removeBtn(vars.menuBtn)
					vars.playBtn = menu.makeBtn("PLAY", 550, 230, 100, 40, 255, 20, 147)
					vars.exitBtn = menu.makeBtn("EXIT", 550, 300, 100, 40, 255, 20, 147)
				elseif v.label == "EXIT" then
					love.event.quit()
				end
			end
		else
			v.r = v.origr
			v.g = v.origg
			v.b = v.origb
		end
	end
end

function menu.drawButtons()
        for i,v in ipairs(menu.buttons) do
		menu.drawBtn(v)
        end
end

return menu
