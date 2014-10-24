local text = {}

gfx = require "gfx"

arial = require "apple_symbols_regular_20"

font_spritesheet = gfx.loadpng(arial.file)

function text.print(surface, font, text, x, y, w, h)
	local sx = x -- Start x position on the surface
	local surface_w = surface:get_width()
	local surface_h = surface:get_height()
	if w == nil or w > surface_w then
		w = surface_w
	end
	if h == nil or h > surface_h then
		h = surface_h
	end

	for i = 1,#text do -- For each character in the text
		local c = text:sub(i,i) -- Get the character
		for j = 1,#font.chars do -- For each character in the font
			local fc = font.chars[j] -- Get the character information
			if fc.char == c then
				if x + fc.width > sx + w then -- If the text is gonna be out the surface, popup a new line
					x = sx
					y = y + font.height
				end
				dx = x + fc.ox -- dx is the x positon of the character, some characters need offset
				dy = y + font.metrics.ascender - fc.oy -- dy is the y position of the character, some characters need offset
				surface:copyfrom(font_spritesheet, {x=fc.x, y=fc.y, w=fc.w, h=fc.h}, {x=dx, y=dy})
				x = x + fc.width -- add offset for next character
				break
			end
		end
	end

	gfx.update()
end

--text.print(gfx.screen, arial, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi maximus auctor tellus. In interdum maximus odio consequat posuere. Suspendisse convallis condimentum pharetra. Ut luctus massa eget consequat iaculis. Nunc blandit semper odio, et tristique justo vestibulum nec. Donec ex justo, iaculis eget fringilla at, tempus sed justo. Pellentesque a odio orci. Integer vel lorem sodales, laoreet quam non, porta velit.", 10, 10, 400, 400)

return text
