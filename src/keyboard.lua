local gfx = require "gfx"
local text = require "write_text"
local keyboardPNG = gfx.loadpng("keyboardblank.png")
local keyboardPressedPNG = gfx.loadpng("standKeyPressed.png")

--what do these actually do?!
--
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9
local keyboardWidth = 10 * xUnit	-- puts boundaries for highlight
local keyboardHeight = 4 * yUnit	-- puts boundaries for highlight
local keyboardXUnit = keyboardWidth/10 -- margin in x for keyboard keys. 10 keys each row
local keyboardYUnit = keyboardHeight/4 -- margin in y for keyboard keys. 4 keys each column
local lastInputX = keyboardXUnit	-- last input of x
local lastInputY = keyboardYUnit	-- last input of y
local keyboardPosX = 3 * xUnit 		-- keyboard start posx
local keyboardPosY = 3 * yUnit 		-- keyboard start posy
local highlightPosX = 1 			-- pos on keyboard posx
local highlightPosY = 1 			-- pos on keyboard posy
local savedText = ""	-- text to display
local lastStateInfo = ...


local keyboardSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())
local highlightSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())
gfx.screen:fill({0,0,0,0}) --colours the screen black
gfx.update()

local mapElement = {}

function mapElement:new(key,row,column,posX,posY)
	pos = {
	letter = key,
	row = row,
	column = column,
	x = posX,
	y = posY
	}
	self.__index = self
	return setmetatable(pos, self)
end

local map = {
--first row
	p11 = mapElement:new("Q",1,1,keyboardPosX + xUnit, keyboardPosY + yUnit),
	p21 = mapElement:new("W",2,1,keyboardPosX +2 * xUnit, keyboardPosY +yUnit),
	p31 = mapElement:new("E",3,1,keyboardPosX +3 * xUnit, keyboardPosY +yUnit),
	p41 = mapElement:new("R",4,1,keyboardPosX +4 * xUnit, keyboardPosY +yUnit),
	p51 = mapElement:new("T",5,1,keyboardPosX +5 * xUnit, keyboardPosY +yUnit),
	p61 = mapElement:new("Y",6,1,keyboardPosX +6 * xUnit, keyboardPosY +yUnit),
	p71 = mapElement:new("U",7,1,keyboardPosX +7 * xUnit, keyboardPosY +yUnit),
	p81 = mapElement:new("I",8,1,keyboardPosX +8 * xUnit, keyboardPosY +yUnit),
	p91 = mapElement:new("O",9,1,keyboardPosX +9 * xUnit, keyboardPosY +yUnit),
	p101 = mapElement:new("P",10,1,keyboardPosX +10 *xUnit,keyboardPosY +yUnit),

	p12 = mapElement:new("A",1,2,keyboardPosX + 1.5 *xUnit, keyboardPosY + 2*yUnit),
	p22 = mapElement:new("S",2,2,keyboardPosX +2.5 * xUnit, keyboardPosY + 2*yUnit),
	p32 = mapElement:new("D",3,2,keyboardPosX +3.5 * xUnit, keyboardPosY +2*yUnit),
	p42 = mapElement:new("F",4,2,keyboardPosX +4.5 * xUnit, keyboardPosY +2*yUnit),
	p52 = mapElement:new("G",5,2,keyboardPosX +5.5 * xUnit, keyboardPosY +2*yUnit),
	p62 = mapElement:new("H",6,2,keyboardPosX +6.5 * xUnit, keyboardPosY +2*yUnit),
	p72 = mapElement:new("J",7,2,keyboardPosX +7.5 * xUnit, keyboardPosY +2*yUnit),
	p82 = mapElement:new("K",8,2,keyboardPosX +8.5 * xUnit, keyboardPosY +2*yUnit),
	p92 = mapElement:new("L",9,2,keyboardPosX +9.5 * xUnit, keyboardPosY +2*yUnit),

	p13 = mapElement:new("SH",1,3,keyboardPosX + 1 *xUnit, keyboardPosY +3*yUnit),
	p23 = mapElement:new("Z",2,3,keyboardPosX +2.5 * xUnit, keyboardPosY +3*yUnit),
	p33 = mapElement:new("X",3,3,keyboardPosX +3.5 * xUnit, keyboardPosY +3*yUnit),
	p43 = mapElement:new("C",4,3,keyboardPosX +4.5 * xUnit, keyboardPosY +3*yUnit),
	p53 = mapElement:new("V",5,3,keyboardPosX +5.5 * xUnit, keyboardPosY +3*yUnit),
	p63 = mapElement:new("B",6,3,keyboardPosX +6.5 * xUnit, keyboardPosY +3*yUnit),
	p73 = mapElement:new("N",7,3,keyboardPosX +7.5 * xUnit, keyboardPosY +3*yUnit),
	p83 = mapElement:new("M",8,3,keyboardPosX +8.5 * xUnit, keyboardPosY +3*yUnit),
	p93 = mapElement:new("DEL",9,3,keyboardPosX +9.5 * xUnit, keyboardPosY +3*yUnit),

	p14 = mapElement:new("?123",1,4,keyboardPosX + 1 * xUnit, keyboardPosY +4 * yUnit),
	p24 = mapElement:new(",",2,4,keyboardPosX +3 * xUnit, keyboardPosY +4 * yUnit),
	p34 = mapElement:new("__",3,4,keyboardPosX +4 * xUnit, keyboardPosY +4 * yUnit),
	p44 = mapElement:new(".",4,4,keyboardPosX +8 * xUnit, keyboardPosY +4 * yUnit),
	p54 = mapElement:new("ENTER",5,4,keyboardPosX +9 * xUnit, keyboardPosY +4 * yUnit)

}

function main()
	displayKeyboardSurface()
	displayHighlightSurface()
	displaySavedText()
	printKeyboardLetters()
end


--display keyboard
function displayKeyboardSurface()
	keyboardSurface:clear()
	gfx.screen:copyfrom(keyboardPNG, nil, {x=3 * xUnit, y= 3 * yUnit, w=keyboardWidth, h=keyboardHeight})
	gfx.update()
end

-- displays the highlight
-- TODO
-- needs to change position of copyfrom. (0,0) now writes over keyboard 
function displayHighlightSurface()
	local coordinates = getCoordinates(highlightPosX,highlightPosY)
	local width = xUnit
	local height = yUnit
	displayKeyboardSurface()
	printKeyboardLetters()
	highlightSurface:clear()
	-- highlightSurface:fill({255,145,145,0}) 
	
	if (highlightPosX == 1 or highlightPosX == 9) and highlightPosY ==3 then
		width = 1.5 * xUnit
	elseif (highlightPosX == 1 or highlightPosX == 5) and highlightPosY == 4 then
		width = 2 * xUnit
	elseif highlightPosX == 3 and highlightPosY ==4 then
		width = 4 * xUnit
	end

	gfx.screen:copyfrom(keyboardPressedPNG, nil ,{x= coordinates.x - keyboardXUnit, y=coordinates.y - keyboardYUnit, w=width, h=height})
	gfx.update()
end

--gets the coordinate of arguments
function getCoordinates(posX, posY)
	local pos = "p"..posX..posY
	if map[pos] then
	return map[pos]
	else
	return nil
	end
end

function printKeyboardLetters()
	for k,v in pairs(map)do
		text.print(gfx.screen, arial, v.letter, v.x-xUnit/1.5, v.y-yUnit/1.5, xUnit*2, yUnit*2)
	end
end



-- moves the highligther around
-- TODO:
-- needs to have proper boundaries
function movehighlightKey(key)
	keyboardPressedPNG = gfx.loadpng("standKeyPressed.png")
	if(key == 'Down')then
		--down
		highlightPosX = highlightPosX + 0
		highlightPosY = highlightPosY + 1
		-- local coordinates = getCoordinates(highlightPosX,highlightPosY)
		if not(getCoordinates(highlightPosX,highlightPosY))then
			highlightPosY = highlightPosY-1
			displayHighlightSurface()
		else
			displayHighlightSurface()
			-- highlightPosY = highlightPosY -1
			print("xInput: ".. lastInputX .. "yInput: ".. lastInputY)
		end
	end
	if(key == 'Up')then
		--up
		highlightPosX = highlightPosX + 0
		highlightPosY = highlightPosY - 1
		-- local coordinates = getCoordinates(highlightPosX,highlightPosY)
		if not(getCoordinates(highlightPosX,highlightPosY))then
			highlightPosY = highlightPosY + 1
			displayHighlightSurface()
		else
			displayHighlightSurface()
			-- highlightPosY = highlightPosY +1
			print("xInput: ".. lastInputX .. "yInput: ".. lastInputY)
		end

	end
	if(key == 'Left')then
		--left
		highlightPosX = highlightPosX - 1
		highlightPosY = highlightPosY + 0

		if not(getCoordinates(highlightPosX,highlightPosY))then
			highlightPosX = highlightPosX + 1
			displayHighlightSurface()
		else
			displayHighlightSurface()
			print("xInput: ".. lastInputX .. "yInput: ".. lastInputY)

		end

	end
	if(key == 'Right')then
		--right
		highlightPosX = highlightPosX + 1
		highlightPosY = highlightPosY + 0
		if not(getCoordinates(highlightPosX,highlightPosY))then
			highlightPosX = highlightPosX - 1
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
		if(key == 'Up') then
			movehighlightKey(key)
		elseif(key == 'Down') then
			movehighlightKey(key)
		elseif(key == 'Left') then
			movehighlightKey(key)
		elseif(key == 'Right') then
			movehighlightKey(key)
		elseif(key == 'Return') then
		-- print("lastInputX: "..lastInputX.."lastInputY: "..lastInputY)
			local letterToDisplay = getKeyboardChar(highlightPosX,highlightPosY)
			if (letterToDisplay == "ENTER") then
				sendInfoBackToState(lastStateInfo.laststate, lastStateInfo)
			else 
				saveText(letterToDisplay)
				displaySavedText()
			end
		elseif(key == 'B' and lastStateInfo) then
			-- sendInputToState(lastState, savedText)
			sendInfoBackToState(lastStateInfo.state, lastStateInfo)

		end
	end
	gfx.update()

end

-- gets the char that is highlighted
function getKeyboardChar(row, column)

	for key, value in pairs(map) do

		if(row == value.row) and (column==value.column)then
			print(value.letter)
			return value.letter
		
		end
	end
end

--saves all input and can display them by pressing S
function saveText(character)
	if character then
	savedText = savedText .. character
	end
end

function getSavedText()
	return savedText
end
-- displays the saved text on screen
function displaySavedText()
	gfx.screen:fill({r=255, g=255, b=255, a=0}, {x=2 * xUnit, y=2 * yUnit, w=12 * xUnit, h=yUnit}) --colours the saved text field

	text.print(gfx.screen, arial, savedText, 2 * xUnit, 2 * yUnit, 12 * xUnit, yUnit)
	gfx.update()
end

-- saves the text to the info form to be sent back to last state
function saveInfo(myText)
	local inputField = lastStateInfo.currentInputField
	lastStateInfo[inputField] = myText
end

-- send info back to state
function sendInfoBackToState(state, info)
	saveInfo(getSavedText())
	assert(loadfile(state))(info)
end

main()