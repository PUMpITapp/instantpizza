local gfx = require "gfx"
local text = require "write_text"
local keyboardPNG = gfx.loadpng("keyboard2.png")

--what do these actually do?!
local keyboardSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())
local highlightSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())
local inputSurface = gfx.new_surface(gfx.screen:get_width()/10, gfx.screen:get_height()/10)
--

local screenWidth = gfx.screen:get_width()
local screenHeight = gfx.screen:get_height()

local inputSurfaceX = 0	-- used for writing letters after each other in inputdisplay
local inputSurfaceY = 0	-- used for writing letters after each other in inputdisplay
local xMargin = screenWidth * 8/10/10 -- margin in x for keyboard keys. 10 keys each row
local yMargin = screenHeight * 6/10/4 -- margin in y for keyboard keys. 4 keys each column
local keyboardWidth = 10 * xMargin	-- puts boundaries for highlight
local keyboardHeight = 4 * yMargin	-- puts boundaries for highlight
local lastInputX = xMargin	-- last input of x
local lastInputY = yMargin	-- last input of y

gfx.screen:fill({0,0,0,0}) --colours the screen black
gfx.screen:fill({r=255, g=255, b=255, a=0}, {x=screenWidth/10, y=screenHeight/10, w=screenWidth * 8/10, h=screenHeight/10}) --colours the input field
gfx.update()

local PosKey = {}

-- creates an object with position of the key
function PosKey:new(key, posX, posY)
	key = {	letter = key,
			row = posX,		-- what row the key is in
			column = posY,	-- what column the key is in
			x = math.floor(xMargin * posX),	-- x starting position. making it an int for precision
			y = math.floor(yMargin * posY),	-- y starting position. making it an int for precision
			w = 200,		-- width not used
			h = 300			-- height not used
			}
	self.__index = self
	return setmetatable(key ,self)
end
-- creates the keyboard
local keyboard = {
	-- TODO
	-- the whole keyboard is not implemented yet

	--first row

		one = PosKey:new("1",1,1),
		two = PosKey:new("2",2,1),
		three = PosKey:new("3",3,1),
		four = PosKey:new("4",4,1),
		five = PosKey:new("5",5,1),
		six = PosKey:new("6",6,1),
		seven = PosKey:new("7",7,1),
		eight = PosKey:new("8",8,1),
		nine = PosKey:new("9",9,1),
		zero = PosKey:new("0",10,1),
	
	-- second row

		Q = PosKey:new("Q",1,2),
		W = PosKey:new("W",2,2),
		E = PosKey:new("E",3,2),
		R = PosKey:new("R",4,2),
		T = PosKey:new("T",5,2),
		Y = PosKey:new("Y",6,2),
		U = PosKey:new("U",7,2),
		I = PosKey:new("I",8,2),
		O = PosKey:new("O",9,2),
		P = PosKey:new("P",10,2),
	-- third row

		A = PosKey:new("A",1,3),
		S = PosKey:new("S",2,3),
		D = PosKey:new("D",3,3),
		F = PosKey:new("F",4,3),
		G = PosKey:new("G",5,3),
		H = PosKey:new("H",6,3),
		J = PosKey:new("J",7,3),
		K = PosKey:new("K",8,3),
		L = PosKey:new("L",9,3),
		Shift = PosKey:new("Shift",10,3),
	-- fourth row
		
		Z = PosKey:new("Z",1,4),
		X = PosKey:new("X",2,4),
		C = PosKey:new("C",3,4),
		V = PosKey:new("V",4,4), 
		B = PosKey:new("B",5,4),
		N = PosKey:new("N",6,4),
		M = PosKey:new("M",7,4),
		Colon = PosKey:new(",",8,4),
		Period = PosKey:new(".",9,4),
		Question = PosKey:new("?",10,4)
	}


function main()
	displayKeyboardSurface()
	displayHighlightSurface()
	-- displayInputSurface()
end


--display keyboard
function displayKeyboardSurface()
	local width = gfx.screen:get_width()
	local height = gfx.screen:get_height()
	keyboardSurface:clear()
	keyboardSurface:fill({0,0,0})
	gfx.screen:copyfrom(keyboardPNG, nil, {x=screenWidth/10, y=screenHeight * 3/10, w=screenWidth * 8/10, h=screenHeight * 6/10})
	gfx.update()
end

-- displays the highlight
-- TODO
-- needs to change position of copyfrom. (0,0) now writes over keyboard 
function displayHighlightSurface()
	local width = gfx.screen:get_width()
	local height = gfx.screen:get_height()

	highlightSurface:clear()
	highlightSurface:fill({255,0,0,0})
	--gfx.screen:copyfrom(keyboardSurface, nil, {x=600, y=600})
	displayKeyboardSurface()
	gfx.screen:fill({r=255, g=0, b=0, a=0}, {x=screenWidth * 1/10 + lastInputX - xMargin, y=screenHeight * 3/10 + lastInputY - yMargin, w=xMargin, h=yMargin})
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
		if(lastInputY>keyboardHeight)then
			lastInputY = keyboardHeight
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
		if(lastInputX>keyboardWidth)then
			lastInputX = keyboardWidth
			displayHighlightSurface()
		else
			displayHighlightSurface()
			print("xInput: ".. lastInputX .. "yInput: ".. lastInputY)

		end

	end
end


-- temporarely displays the letter on screen.
function displayInputSurface(letter)
	local startX = screenWidth/10
	local startY = screenHeight * 1/10

	text.print(gfx.screen, arial, letter, screenWidth/10 + inputSurfaceX, screenHeight * 1/10 + inputSurfaceY, screenWidth * 8/10, screenHeight/10)

	inputSurfaceX = inputSurfaceX + 30

	if(inputSurfaceX>(screenWidth * 8/10)) then
	inputSurfaceY = inputSurfaceY + 30
	inputSurfaceX = 0
	end

	-- inputSurface:clear()
	-- inputSurface:fill({255,255,255,0})


	gfx.update()
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
		-- print("lastInputX: "..lastInputX.."lastInputY: "..lastInputY)
			local letterToDisplay = getKeyboardChar(lastInputX,lastInputY)
			displayInputSurface(letterToDisplay)
		end
	end
	gfx.update()

end

-- gets the char that is highlighted
function getKeyboardChar(posX, posY)
	local letter = nil
	local cursorPosX = math.floor(posX)	--int for precision
	local cursorPosY = math.floor(posY) --int for precision

	for key, value in pairs(keyboard) do
		if(cursorPosX == value.x) and (cursorPosY==value.y)then

			print(value.letter)
			return value.letter
		-- else
		-- 	print("posX: "..posX.."value.x: "..value.x)
		-- 	print("posY: "..posY.."value.y: "..value.y)
		-- 	return "not mapped"
		end
	end
end



main()