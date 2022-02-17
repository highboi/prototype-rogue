vars = require("vars")

local levels = {}

function levels.nextLevel(plyr)
	if vars.levels[vars.currentlevel+1] ~= nil then
		vars.currentlevel = vars.currentlevel + 1
	else
		vars.playing = false
		plyr.dead = false
		plyr.gameover = true
		plyr.won = true
		vars.currentlevel = 1
		vars.menuBtn = menu.makeBtn("MENU", 550, 370, 100, 40, 255, 20, 147)
	end
end

return levels
