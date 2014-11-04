local gfx = require "gfx"
local text = require "write_text"
local keyboardPNG = gfx.loadpng("images/keyboard/keyboardblank.png")
local keyboardPressedPNG = gfx.loadpng("images/keyboard/standKeyPressed.png")
local inputFieldPNG = gfx.loadpng("images/keyboard/standKeyPressed.png")

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

local keyboardSurface = gfx.new_surface(keyboardWidth,keyboardHeight)
local highlightSurface = gfx.new_surface(keyboardXUnit,keyboardYUnit)
local inputSurface = gfx.new_surface(12 * xUnit, yUnit)

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
	p11 = mapElement:new("Q",1,1,keyboardPosX + keyboardXUnit, keyboardPosY + keyboardYUnit),
	p21 = mapElement:new("W",2,1,keyboardPosX +2 * keyboardXUnit, keyboardPosY +keyboardYUnit),
	p31 = mapElement:new("E",3,1,keyboardPosX +3 * keyboardXUnit, keyboardPosY +keyboardYUnit),
	p41 = mapElement:new("R",4,1,keyboardPosX +4 * keyboardXUnit, keyboardPosY +keyboardYUnit),
	p51 = mapElement:new("T",5,1,keyboardPosX +5 * keyboardXUnit, keyboardPosY +keyboardYUnit),
	p61 = mapElement:new("Y",6,1,keyboardPosX +6 * keyboardXUnit, keyboardPosY +keyboardYUnit),
	p71 = mapElement:new("U",7,1,keyboardPosX +7 * keyboardXUnit, keyboardPosY +keyboardYUnit),
	p81 = mapElement:new("I",8,1,keyboardPosX +8 * keyboardXUnit, keyboardPosY +keyboardYUnit),
	p91 = mapElement:new("O",9,1,keyboardPosX +9 * keyboardXUnit, keyboardPosY +keyboardYUnit),
	p101 = mapElement:new("P",10,1,keyboardPosX +10 *keyboardXUnit,keyboardPosY +keyboardYUnit),
 
	p12 = mapElement:new("A",1,2,keyboardPosX + 1.5 *keyboardXUnit, keyboardPosY + 2*keyboardYUnit),
	p22 = mapElement:new("S",2,2,keyboardPosX +2.5 * keyboardXUnit, keyboardPosY + 2*keyboardYUnit),
	p32 = mapElement:new("D",3,2,keyboardPosX +3.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit),
	p42 = mapElement:new("F",4,2,keyboardPosX +4.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit),
	p52 = mapElement:new("G",5,2,keyboardPosX +5.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit),
	p62 = mapElement:new("H",6,2,keyboardPosX +6.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit),
	p72 = mapElement:new("J",7,2,keyboardPosX +7.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit),
	p82 = mapElement:new("K",8,2,keyboardPosX +8.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit),
	p92 = mapElement:new("L",9,2,keyboardPosX +9.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit),

	p13 = mapElement:new("SH",1,3,keyboardPosX + 1 *keyboardXUnit, keyboardPosY +3*keyboardYUnit),
	p23 = mapElement:new("Z",2,3,keyboardPosX +2.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit),
	p33 = mapElement:new("X",3,3,keyboardPosX +3.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit),
	p43 = mapElement:new("C",4,3,keyboardPosX +4.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit),
	p53 = mapElement:new("V",5,3,keyboardPosX +5.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit),
	p63 = mapElement:new("B",6,3,keyboardPosX +6.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit),
	p73 = mapElement:new("N",7,3,keyboardPosX +7.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit),
	p83 = mapElement:new("M",8,3,keyboardPosX +8.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit),
	p93 = mapElement:new("DEL",9,3,keyboardPosX +9.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit),

	p14 = mapElement:new("?123",1,4,keyboardPosX + 1 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit),
	p24 = mapElement:new(",",2,4,keyboardPosX +3 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit),
	p34 = mapElement:new("__",3,4,keyboardPosX +4 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit),
	p44 = mapElement:new(".",4,4,keyboardPosX +8 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit),
	p54 = mapElement:new("ENTER",5,4,keyboardPosX +9 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit)

}

function main()
	updateScreen()
end

function updateScreen()
	displayKeyboardSurface()
	displayHighlightSurface()
	displayInputField()
	displayKeyboardLetters()
end

--display keyboard
function displayKeyboardSurface()
	keyboardSurface:clear()
	keyboardSurface:copyfrom(keyboardPNG)
	gfx.screen:copyfrom(keyboardSurface,nil, {x=3 * xUnit, y= 3 * yUnit, w=keyboardWidth, h=keyboardHeight})
	gfx.update()
end

-- displays the highlight
-- TODO
-- needs to change position of copyfrom. (0,0) now writes over keyboard 
function displayHighlightSurface()
	local coordinates = getCoordinates(highlightPosX,highlightPosY)
	local width = xUnit
	local height = yUnit

	highlightSurface:clear()
	highlightSurface:copyfrom(keyboardPressedPNG)
	
	if (highlightPosX == 1 or highlightPosX == 9) and highlightPosY ==3 then
		width = 1.5 * xUnit
	elseif (highlightPosX == 1 or highlightPosX == 5) and highlightPosY == 4 then
		width = 2 * xUnit
	elseif highlightPosX == 3 and highlightPosY ==4 then
		width = 4 * xUnit
	end

	gfx.screen:copyfrom(highlightSurface, nil ,{x= coordinates.x - keyboardXUnit, y=coordinates.y - keyboardYUnit, w=width, h=height})
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

function displayKeyboardLetters()
	for k,v in pairs(map)do
		text.print(gfx.screen, arial, v.letter, v.x-xUnit/1.5, v.y-yUnit/1.5, xUnit*2, yUnit*2)
	end
end

-- displays the saved text on screen
function displayInputField()
	inputSurface:clear()
	-- inputSurface:copyfrom(inputFieldPNG,{x=2 * xUnit, y=2 * yUnit, w=12 * xUnit, h=yUnit})
	-- inputSurface:copyfrom(inputFieldPNG)
	inputSurface:fill({r=255, g=255, b=255, a=0})
	-- gfx.screen:copyfrom(inputSurface, nil ,{x=2 * xUnit, y=2 *yUnit,w = 12* xUnit, h = yUnit})
	gfx.screen:copyfrom(inputSurface, nil ,{x=2 * xUnit, y=2 * yUnit, w=12 * xUnit, h=yUnit}) --colours the saved text field
	text.print(gfx.screen, arial, savedText, 2 * xUnit, 2 * yUnit, 12 * xUnit, yUnit)
	gfx.update()
end

-- moves the highligther around
-- TODO:
-- needs to have proper boundaries
function movehighlightKey(key)
	if(key == 'Down')then
		--down
		highlightPosX = highlightPosX + 0
		highlightPosY = highlightPosY + 1
		if not(getCoordinates(highlightPosX,highlightPosY))then
			highlightPosY = highlightPosY-1
			updateScreen()
		else
			updateScreen()
			print("xInput: ".. lastInputX .. "yInput: ".. lastInputY)
		end
	end
	if(key == 'Up')then
		--up
		highlightPosX = highlightPosX + 0
		highlightPosY = highlightPosY - 1
		if not(getCoordinates(highlightPosX,highlightPosY))then
			highlightPosY = highlightPosY + 1
			updateScreen()
		else
			updateScreen()
			print("xInput: ".. lastInputX .. "yInput: ".. lastInputY)
		end

	end
	if(key == 'Left')then
		--left
		highlightPosX = highlightPosX - 1
		highlightPosY = highlightPosY + 0

		if not(getCoordinates(highlightPosX,highlightPosY))then
			highlightPosX = highlightPosX + 1
			updateScreen()
		else
			updateScreen()
			print("xInput: ".. lastInputX .. "yInput: ".. lastInputY)

		end

	end
	if(key == 'Right')then
		--right
		highlightPosX = highlightPosX + 1
		highlightPosY = highlightPosY + 0
		if not(getCoordinates(highlightPosX,highlightPosY))then
			highlightPosX = highlightPosX - 1
			updateScreen()
		else
			updateScreen()
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

			local letterToDisplay = getKeyboardChar(highlightPosX,highlightPosY)
			if (letterToDisplay == "ENTER") then
				sendInfoBackToState(lastStateInfo.laststate, lastStateInfo)
			else 
				saveText(letterToDisplay)
				displayInputField()
			end
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