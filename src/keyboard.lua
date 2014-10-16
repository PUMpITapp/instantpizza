local gfx = require "gfx"
local text = require "write_text"
local keyboardPNG = gfx.loadpng("keyboard.png")
gfx.screen:fill({0,0,0,0})
gfx.update()


local keyboardSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())
local highlightSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())

local xMargin = 35 -- margin in x for keyboard keys
local yMargin = 35 -- margin in y for keyboard keys
local lastInputX = xMargin	-- last input of x
local lastInputY = yMargin	-- last input of y
local PosKey = {}

-- creates an object with position of the key
function PosKey:new(key, posX, posY)
	key = {	letter = key,
			row = posX,		-- what row the key is in
			column = posY,	-- what column the key is in
			x = xMargin * posX,	-- x starting position
			y = yMargin * posY,	-- y starting position
			w = 200,		-- width
			h = 300			-- height
			}
	self.__index = self
	return setmetatable(key ,self)
end

local keyboard = {
	-- TODO
	-- the whole keyboard is not implemented yet

	--first row
		GraveAccent = PosKey:new("`",1,1),
		one = PosKey:new("1",2,1),
		two = PosKey:new("2",3,1),
		three = PosKey:new("3",4,1),
		four = PosKey:new("4",5,1),
		five = PosKey:new("5",6,1),
		six = PosKey:new("6",7,1),
		seven = PosKey:new("7",8,1),
		eight = PosKey:new("8",9,1),
		nine = PosKey:new("9",10,1),
		zero = PosKey:new("0",11,1),
		minus = PosKey:new("-",12,1),
		equal = PosKey:new("=",13,1),
		backspace1 = PosKey:new("BACKSPACE", 14,1),
		backspace2 = PosKey:new("BACKSPACE", 15,1),

	
	-- second row
		Tab = PosKey:new("TAB",1,2),
		Q = PosKey:new("Q",2,2),
		W = PosKey:new("W",3,2),
		E = PosKey:new("E",4,2),
		R = PosKey:new("R",5,2),
		T = PosKey:new("T",6,2),
		Y = PosKey:new("Y",7,2),
		U = PosKey:new("U",8,2),
		I = PosKey:new("I",9,2),
		O = PosKey:new("O",10,2),
		P = PosKey:new("P",11,2),
		leftbracket = PosKey:new("LEFTBRACKET",12 ,2),
		rightbracket= PosKey:new("RIGHTBRACKET",13 ,2),
	-- third row
		Caps = PosKey:new("CAPS",1,3),
		A = PosKey:new("A",2,3),
		S = PosKey:new("S",3,3),
		D = PosKey:new("D",4,3),
		F = PosKey:new("F",5,3),
		G = PosKey:new("G",6,3),
		H = PosKey:new("H",7,3),
		J = PosKey:new("J",8,3),
		K = PosKey:new("K",9,3),
		L = PosKey:new("L",10,3),
	-- fourth row
		
		Lshift1 = PosKey:new("Lshift",1,4),
		Lshift2 = PosKey:new("Lshift",2,4),
		Z = PosKey:new("Z",3,4),
		X = PosKey:new("X",4,4),
		C = PosKey:new("C",5,4),
		V = PosKey:new("V",6,4),
		B = PosKey:new("B",7,4),
		N = PosKey:new("N",8,4),
		M = PosKey:new("M",9,4),
		Colon = PosKey:new(",",10,4),
		Period = PosKey:new(".",11,4),
		Question = PosKey:new("?",12,4),
		Rshift1 = PosKey:new("Rshift", 13, 4),
		Rshift2 = PosKey:new("Rshift", 14, 4),
		Rshift3 = PosKey:new("Rshift", 15, 4)
	}


function main()
	displayKeyboard()
	displayHighlightSurface()
end


--display keyboard
function displayKeyboard()
	keyboardSurface:clear()
	keyboardSurface:fill({0,0,0})
	gfx.screen:copyfrom(keyboardPNG, nil, {x=xMargin, y=yMargin})
	-- for key, value in pairs(keyboard)do
	-- 	text.print(gfx.screen, arial, value.letter, value.x, value.y, value.w, value.h)
	-- end
	gfx.update()
end

-- displays the highlight
-- TODO
-- needs to change position of copyfrom. (0,0) now writes over keyboard 
function displayHighlightSurface()
	-- highlightX = 0 + posX
	-- highlightY = 0 + posY

	highlightSurface:clear()
	highlightSurface:fill({255,0,0,0})
	--gfx.screen:copyfrom(keyboardSurface, nil, {x=600, y=600})
	displayKeyboard()
	gfx.screen:fill({r=255, g=0, b=0, a=0}, {x=lastInputX, y=lastInputY, w=35, h=35})
--	text.print(gfx.screen, arial, "+", lastInputX, lastInputY, 200, 300)
	gfx.update()
end

-- moves the highligther around
-- TODO:
-- needs to have proper boundaries
function movehighlightKey(key)
	if(key == 'green')then
		--down
		lastInputX = lastInputX + 0
		lastInputY = lastInputY + yMargin
		if(lastInputY>520)then
			lastInputY = 520
			displayHighlightSurface()
		else
			displayHighlightSurface()
			print("xInput: ".. lastInputX .. "yInput: ".. lastInputY)

		end
	end
	if(key == 'red')then
		--up
		lastInputX = lastInputX + 0
		lastInputY = lastInputY - yMargin
		if(lastInputY<yMargin)then
			lastInputY = yMargin
			displayHighlightSurface()
		else
			displayHighlightSurface()
			print("xInput: ".. lastInputX .. "yInput: ".. lastInputY)
		end

	end
	if(key == 'yellow')then
		--left
		lastInputX = lastInputX - xMargin
		lastInputY = lastInputY + 0
		if(lastInputX<xMargin)then
			lastInputX = xMargin
			displayHighlightSurface()
		else
			displayHighlightSurface()
			print("xInput: ".. lastInputX .. "yInput: ".. lastInputY)

		end

	end
	if(key == 'blue')then
		--right
		lastInputX = lastInputX + xMargin
		lastInputY = lastInputY + 0
		if(lastInputX>600)then
			lastInputX = 600
			displayHighlightSurface()
		else
			displayHighlightSurface()
			print("xInput: ".. lastInputX .. "yInput: ".. lastInputY)

		end

	end
end

-- calls functions on keys
function onKey(key, state)
	if(state == 'up')then
		if(key == 'red') then
			movehighlightKey(key)
		elseif(key == 'green') then
			movehighlightKey(key)
		elseif(key == 'yellow') then
			movehighlightKey(key)
		elseif(key == 'blue') then
			movehighlightKey(key)
		elseif(key == 'Return') then
			getKeyboardChar(lastInputX,lastInputY)
		end
	end
	gfx.update()

end

-- gets the char that is highlighted
function getKeyboardChar(posX, posY)
	local letter = nil
	for key, value in pairs(keyboard) do
		if(posX == value.x) and (posY==value.y)then
			print(value.letter)
		end
	end
end

main()