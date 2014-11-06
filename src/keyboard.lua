local gfx = require "gfx"
local text = require "write_text"
local keyboardPNG = gfx.loadpng("images/keyboard/keyboardblank.png")
local keyboardPressedPNG = gfx.loadpng("images/keyboard/standKeyPressed.png")
local inputFieldPNG = gfx.loadpng("images/keyboard/standKeyPressed.png")

local xUnit = gfx.screen:get_width()/16	-- units of the screen. based on 16:9 ratio
local yUnit = gfx.screen:get_height()/9	-- units of the screen. based on 16:9 ratio
local keyboardWidth = 10 * xUnit 	-- width of keyboard. can be changed to fit
local keyboardHeight = 4 * yUnit 	-- height of keyabord. can be changed to fit
local keyboardXUnit = keyboardWidth/10 -- margin in x for keyboard keys. 10 keys each row
local keyboardYUnit = keyboardHeight/4 -- margin in y for keyboard keys. 4 keys each column
local keyboardPosX = 3 * xUnit 		-- keyboard start posx. can be changed
local keyboardPosY = 3 * yUnit 		-- keyboard start posy. can be changed
local highlightPosX = 1 			-- pos on keyboard posx
local highlightPosY = 1 			-- pos on keyboard posy
local inputText = ""	-- text to display
local lastStateForm = ...	-- gets last state form

local keyboardSurface = gfx.new_surface(keyboardWidth,keyboardHeight)
local highlightSurface = gfx.new_surface(keyboardXUnit,keyboardYUnit)
local inputSurface = gfx.new_surface(12 * xUnit, yUnit)

local mapElement = {}

function mapElement:new(key,row,column,posX,posY,upMove,downMove)
	pos = {
	letter = key,
	row = row,
	column = column,
	x = posX,
	y = posY,
	up = upMove,
	down = downMove
	}
	self.__index = self
	return setmetatable(pos, self)
end

local map = {
--first row
	p11 = mapElement:new("Q",1,1,keyboardPosX + keyboardXUnit, keyboardPosY + keyboardYUnit,1,1),
	p21 = mapElement:new("W",2,1,keyboardPosX +2 * keyboardXUnit, keyboardPosY +keyboardYUnit,2,2),
	p31 = mapElement:new("E",3,1,keyboardPosX +3 * keyboardXUnit, keyboardPosY +keyboardYUnit,3,3),
	p41 = mapElement:new("R",4,1,keyboardPosX +4 * keyboardXUnit, keyboardPosY +keyboardYUnit,4,4),
	p51 = mapElement:new("T",5,1,keyboardPosX +5 * keyboardXUnit, keyboardPosY +keyboardYUnit,5,5),
	p61 = mapElement:new("Y",6,1,keyboardPosX +6 * keyboardXUnit, keyboardPosY +keyboardYUnit,6,6),
	p71 = mapElement:new("U",7,1,keyboardPosX +7 * keyboardXUnit, keyboardPosY +keyboardYUnit,7,6),
	p81 = mapElement:new("I",8,1,keyboardPosX +8 * keyboardXUnit, keyboardPosY +keyboardYUnit,8,7),
	p91 = mapElement:new("O",9,1,keyboardPosX +9 * keyboardXUnit, keyboardPosY +keyboardYUnit,9,8),
	p101 = mapElement:new("P",10,1,keyboardPosX +10 *keyboardXUnit,keyboardPosY +keyboardYUnit,10,9),
 
	p12 = mapElement:new("A",1,2,keyboardPosX + 1.5 *keyboardXUnit, keyboardPosY + 2*keyboardYUnit,1,1),
	p22 = mapElement:new("S",2,2,keyboardPosX +2.5 * keyboardXUnit, keyboardPosY + 2*keyboardYUnit,2,2),
	p32 = mapElement:new("D",3,2,keyboardPosX +3.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,3,3),
	p42 = mapElement:new("F",4,2,keyboardPosX +4.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,4,4),
	p52 = mapElement:new("G",5,2,keyboardPosX +5.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,5,5),
	p62 = mapElement:new("H",6,2,keyboardPosX +6.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,6,6),
	p72 = mapElement:new("J",7,2,keyboardPosX +7.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,7,7),
	p82 = mapElement:new("K",8,2,keyboardPosX +8.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,9,8),
	p92 = mapElement:new("L",9,2,keyboardPosX +9.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,10,9),

	p13 = mapElement:new("SH",1,3,keyboardPosX + 1 *keyboardXUnit, keyboardPosY +3*keyboardYUnit,1,1),
	p23 = mapElement:new("Z",2,3,keyboardPosX +2.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,2,2),
	p33 = mapElement:new("X",3,3,keyboardPosX +3.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,3,3),
	p43 = mapElement:new("C",4,3,keyboardPosX +4.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,4,3),
	p53 = mapElement:new("V",5,3,keyboardPosX +5.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,5,3),
	p63 = mapElement:new("B",6,3,keyboardPosX +6.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,6,3),
	p73 = mapElement:new("N",7,3,keyboardPosX +7.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,7,3),
	p83 = mapElement:new("M",8,3,keyboardPosX +8.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,8,4),
	p93 = mapElement:new("DEL",9,3,keyboardPosX +9.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,9,5),

	p14 = mapElement:new("?123",1,4,keyboardPosX + 1 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,1,1),
	p24 = mapElement:new(",",2,4,keyboardPosX +3 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,2,2),
	p34 = mapElement:new("__",3,4,keyboardPosX +4 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,5,3),
	p44 = mapElement:new(".",4,4,keyboardPosX +8 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,8,4),
	p54 = mapElement:new("ENTER",5,4,keyboardPosX +9 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,9,5)
}


function main()
	updateScreen()
end

function updateScreen()
	displayKeyboardSurface()
	displayHighlightSurface()
	displayInputField()
	displayKeyboardLetters()
	gfx.update()
end

--display keyboard
function displayKeyboardSurface()
	keyboardSurface:clear()
	keyboardSurface:copyfrom(keyboardPNG)
	gfx.screen:copyfrom(keyboardSurface,nil, {x=3 * xUnit, y= 3 * yUnit, w=keyboardWidth, h=keyboardHeight})
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
end

function displayKeyboardLetters()
	for k,v in pairs(map)do
		
		text.print(gfx.screen, arial, v.letter, v.x-xUnit/1.5, v.y-yUnit/1.5, xUnit*2, yUnit*2)
	end
end

-- displays the saved text on screen
function displayInputField()
	inputSurface:clear()
	-- inputSurface:copyfrom(inputFieldPNG)
	inputSurface:fill({r=255, g=255, b=255, a=0})
	-- gfx.screen:copyfrom(inputSurface, nil ,{x=2 * xUnit, y=2 *yUnit,w = 12* xUnit, h = yUnit})
	gfx.screen:copyfrom(inputSurface, nil ,{x=2 * xUnit, y=2 * yUnit, w=12 * xUnit, h=yUnit}) --colours the saved text field
	text.print(gfx.screen, arial, inputText, 2 * xUnit, 2 * yUnit, 12 * xUnit, yUnit)
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

--gets the correct movement of cursor when moving in y-axis
function getYmove(xVal,yVal,move)
	local coordinates = "p"..xVal..yVal
	print(coordinates)
	return map[coordinates][move]
end

-- gets the char that is highlighted
function getKeyboardChar(row, column)
	local coordinates = "p"..row..column
	return map[coordinates].letter
end

--saves character to string
function setToString(character)
	if character then
	inputText = inputText .. character
	end
end

-- saves the text to the form to be sent back to last state
function saveToForm(myText)
	local inputField = lastStateForm.currentInputField
	lastStateForm[inputField] = myText
end

-- send form back to state
function sendFormBackToState(state, form)
	saveToForm(inputText)
	assert(loadfile(state))(form)
end

-- removes the last char in argument
function removeLastChar(input)
	return string.sub(input, 1, #input-1)
end

-- moves the highligther around
function movehighlightKey(key)
	if(key == 'Down')then
		--down

		highlightPosX = getYmove(highlightPosX,highlightPosY,"down")
		highlightPosY = highlightPosY + 1
		if not(getCoordinates(highlightPosX,highlightPosY))then
			highlightPosY = highlightPosY-1
			updateScreen()
		else
			updateScreen()
		end
	end
	if(key == 'Up')then
		--up
		highlightPosX = getYmove(highlightPosX,highlightPosY,"up")
		highlightPosY = highlightPosY - 1
		if not(getCoordinates(highlightPosX,highlightPosY))then
			highlightPosY = highlightPosY + 1
			updateScreen()
		else
			updateScreen()
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

				sendFormBackToState(lastStateForm.laststate, lastStateForm)
			elseif(letterToDisplay == "DEL") then

				inputText = removeLastChar(inputText)
				displayInputField()
			else 
				setToString(letterToDisplay)
				displayInputField()
			end
		end
	end
	gfx.update()

end

main()