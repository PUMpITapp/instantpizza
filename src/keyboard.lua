local gfx = require "gfx"
gfx.screen:fill({255,255,255,255})
gfx.update()

local keyboardSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())

png_numbers = {
	  num1 = 'images/1.png',
	  num2 = 'images/2.png',
	  num3 = 'images/3.png',
	  num4 = 'images/4.png',
	  num5 = 'images/5.png',
	  num6 = 'images/6.png',
	  num7 = 'images/7.png',
	  num8 = 'images/8.png',
	  num9 = 'images/9.png',
	  num0 = 'images/0.png',
}

function main()
	buildKeyboard()
end
--build keyboard
function buildKeyboard()
	displayKeyboard()
end
--display keyboard
function displayKeyboard()
	keyboardSurface:clear()
	keyboardSurface:fill({255,255,255})
	gfx.screen:copyfrom(keyboardSurface, nil, {x=0, y=200})
	local button1 = gfx.loadpng(png_numbers.num1)
	printPicture(button1, 20, 300)

	gfx.update()
end
--print the picture
function printPicture(pic, xx, yy)
	gfx.screen:copyfrom(pic, nil, {x=xx, y=yy})
end
--checks pushed key
function onKey(key, state)

end

main()