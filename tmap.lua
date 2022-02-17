vars = require("vars")

local tmap = {}

--loop through the rows and columns of the tileset
function tmap.addQuads()
	quads = {}

	for i=0,5 do
		for j=0,3 do
			table.insert(quads,
				love.graphics.newQuad(
					1 + j * (vars.width + 2),
					1 + i * (vars.height + 2),
					vars.width, vars.height,
					vars.image_width, vars.image_height))
		end
	end

	return quads
end

tmap.quads = tmap.addQuads()

function tmap.updateMap()
	vars.tilemap = vars.levels[vars.currentlevel]
end

function tmap.drawMap()
	for i,row in ipairs(vars.tilemap) do
		for j,tile in ipairs(row) do
			if tile ~= 0 then
				love.graphics.draw(vars.image, tmap.quads[tile], j * vars.width, i * vars.height)
			end
		end
	end
end

return tmap
