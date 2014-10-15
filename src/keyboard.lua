local gfx = require "gfx"
local text = require "write_text"
gfx.screen:fill({0,0,0,0})
gfx.update()


local keyboardSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())
local highlightSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())

local xMargin = 30 -- margin in x for keyboard keys
local yMargin = 40 -- margin in y for keyboard keys
local lastInputX = xMargin	-- last input of x
local lastInputY = yMargin	-- last input of y
local PosKey = {}
local keyboard = {}

-- creates the position of the key
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

function main()
	buildKeyboard()
	displayKeyboard()
	displayHighlightSurface()
end

--build keyboard
function buildKeyboard()
	-- TODO
	-- the whole keyboard is not implemented yet
	keyboard = {
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

	-- second row
		-- Tab = PosKey:new("TAB",1,2),
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
	-- third row
		-- Caps = PosKey:new("CAPS",1,3),
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
		-- Lshift = PosKey:new("Lshift"1,4),
		-- the<key = PosKey:new("<"2,4),
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
}
end

--display keyboard
function displayKeyboard()
	keyboardSurface:clear()
	keyboardSurface:fill({0,0,0})
	gfx.screen:copyfrom(keyboardSurface, nil, {x=0, y=200})
	for key, value in pairs(keyboard)do
		text.print(gfx.screen, arial, value.letter, value.x, value.y, value.w, value.h)
	end
	gfx.update()
end

function displayHighlightSurface()
	-- highlightX = 0 + posX
	-- highlightY = 0 + posY

	highlightSurface:clear()
	highlightSurface:fill({255,0,0,0})
	gfx.screen:copyfrom(keyboardSurface, nil, {x=200, y=150})
	text.print(gfx.screen, arial, "O", lastInputX, lastInputY, 200, 300)
	gfx.update()
end

function movehighlightKey(key)
	
	if(key == 'green')then
		--down
		lastInputX = lastInputX + 0
		lastInputY = lastInputY + yMargin
		if(lastInputY>500)then
			lastInputY = 500
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
		if(lastInputX>500)then
			lastInputX = 500
			displayHighlightSurface()
		else
			displayHighlightSurface()
			print("xInput: ".. lastInputX .. "yInput: ".. lastInputY)

		end

	end
end

function onKey(key, state)
	if(key == 'red') then
		movehighlightKey(key)
	elseif(key == 'green') then
		movehighlightKey(key)
	elseif(key == 'yellow') then
		movehighlightKey(key)
	elseif(key == 'blue') then
		movehighlightKey(key)
	end
	gfx.update()

end

main()