local gfx = require "gfx"
local text = require "write_text"
local keyboardPNG = gfx.loadpng("Images/KeyboardPics/keyboardblank.png")
local textAreaPNG = gfx.loadpng("Images/KeyboardPics/textArea.png") -- change this to correct
local lowerCasePNG = gfx.loadpng("Images/KeyboardPics/lowerCase.png")
local upperCasePNG = gfx.loadpng("Images/KeyboardPics/upperCase.png")
local symbolsPNG = gfx.loadpng("Images/KeyboardPics/symbols.png")
local keyPressedPNG = gfx.loadpng("Images/KeyboardPics/standKeyPressed.png")
local deletePressedPNG = gfx.loadpng("Images/KeyboardPics/deletePressed.png")
local enterPressedPNG = gfx.loadpng("Images/KeyboardPics/enterPressed.png")
local shiftPressedPNG = gfx.loadpng("Images/KeyboardPics/shiftPressed.png")
local symbolPressedPNG = gfx.loadpng("Images/KeyboardPics/symbolPressed.png")
local spacePressedPNG = gfx.loadpng("Images/KeyboardPics/spacePressed.png")
local keyboardState = lowerCasePNG

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
local letterSurface = gfx.new_surface(keyboardWidth,keyboardHeight)
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
	p11 = mapElement:new("q",1,1,keyboardPosX + keyboardXUnit, keyboardPosY + keyboardYUnit,1,1),
	p21 = mapElement:new("w",2,1,keyboardPosX +2 * keyboardXUnit, keyboardPosY +keyboardYUnit,1,2),
	p31 = mapElement:new("e",3,1,keyboardPosX +3 * keyboardXUnit, keyboardPosY +keyboardYUnit,2,3),
	p41 = mapElement:new("r",4,1,keyboardPosX +4 * keyboardXUnit, keyboardPosY +keyboardYUnit,3,4),
	p51 = mapElement:new("t",5,1,keyboardPosX +5 * keyboardXUnit, keyboardPosY +keyboardYUnit,3,5),
	p61 = mapElement:new("y",6,1,keyboardPosX +6 * keyboardXUnit, keyboardPosY +keyboardYUnit,3,6),
	p71 = mapElement:new("u",7,1,keyboardPosX +7 * keyboardXUnit, keyboardPosY +keyboardYUnit,3,6),
	p81 = mapElement:new("i",8,1,keyboardPosX +8 * keyboardXUnit, keyboardPosY +keyboardYUnit,4,7),
	p91 = mapElement:new("o",9,1,keyboardPosX +9 * keyboardXUnit, keyboardPosY +keyboardYUnit,5,8),
	p101 = mapElement:new("p",10,1,keyboardPosX +10 *keyboardXUnit,keyboardPosY +keyboardYUnit,5,9),
 
	p12 = mapElement:new("a",1,2,keyboardPosX + 1.5 *keyboardXUnit, keyboardPosY + 2*keyboardYUnit,1,1),
	p22 = mapElement:new("s",2,2,keyboardPosX +2.5 * keyboardXUnit, keyboardPosY + 2*keyboardYUnit,2,2),
	p32 = mapElement:new("d",3,2,keyboardPosX +3.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,3,3),
	p42 = mapElement:new("f",4,2,keyboardPosX +4.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,4,4),
	p52 = mapElement:new("g",5,2,keyboardPosX +5.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,5,5),
	p62 = mapElement:new("h",6,2,keyboardPosX +6.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,6,6),
	p72 = mapElement:new("j",7,2,keyboardPosX +7.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,7,7),
	p82 = mapElement:new("k",8,2,keyboardPosX +8.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,9,8),
	p92 = mapElement:new("l",9,2,keyboardPosX +9.5 * keyboardXUnit, keyboardPosY +2*keyboardYUnit,10,9),

	p13 = mapElement:new("shift",1,3,keyboardPosX + 1 *keyboardXUnit, keyboardPosY +3*keyboardYUnit,1,1),
	p23 = mapElement:new("z",2,3,keyboardPosX +2.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,2,2),
	p33 = mapElement:new("x",3,3,keyboardPosX +3.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,3,3),
	p43 = mapElement:new("c",4,3,keyboardPosX +4.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,4,3),
	p53 = mapElement:new("v",5,3,keyboardPosX +5.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,5,3),
	p63 = mapElement:new("b",6,3,keyboardPosX +6.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,6,3),
	p73 = mapElement:new("n",7,3,keyboardPosX +7.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,7,3),
	p83 = mapElement:new("m",8,3,keyboardPosX +8.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,8,4),
	p93 = mapElement:new("DELETE",9,3,keyboardPosX +9.5 * keyboardXUnit, keyboardPosY +3*keyboardYUnit,9,5),

	p14 = mapElement:new("SYMBOLS",1,4,keyboardPosX + 1 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,1,1),
	p24 = mapElement:new(",",2,4,keyboardPosX +3 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,2,3),
	p34 = mapElement:new(" ",3,4,keyboardPosX +4 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,5,5),
	p44 = mapElement:new(".",4,4,keyboardPosX +8 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,8,8),
	p54 = mapElement:new("ENTER",5,4,keyboardPosX +9 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,9,10)
}

function setKeyboardToLowerCase()
	map.p11.letter = "q"
	map.p21.letter = "w"
	map.p31.letter = "e"
	map.p41.letter = "r"
	map.p51.letter = "t"
	map.p61.letter = "y"
	map.p71.letter = "u"
	map.p81.letter = "i"
	map.p91.letter = "o"
	map.p101.letter = "p"

	map.p12.letter = "a"
	map.p22.letter = "s"
	map.p32.letter = "d"
	map.p42.letter = "f"
	map.p52.letter = "g"
	map.p62.letter = "h"
	map.p72.letter = "j"
	map.p82.letter = "k"
	map.p92.letter = "l"

	map.p13.letter = "shift"
	map.p23.letter = "z"
	map.p33.letter = "x"
	map.p43.letter = "c"
	map.p53.letter = "v"
	map.p63.letter = "b"
	map.p73.letter = "n"
	map.p83.letter = "m"
	map.p93.letter = "DELETE"

	map.p14.letter = "symbols"
	map.p24.letter = ","
	map.p34.letter = " "
	map.p44.letter = "."
	map.p54.letter = "ENTER"
end

function setKeyboardToUpperCase()
	map.p11.letter = "Q"
	map.p21.letter = "W"
	map.p31.letter = "E"
	map.p41.letter = "R"
	map.p51.letter = "T"
	map.p61.letter = "Y"
	map.p71.letter = "U"
	map.p81.letter = "I"
	map.p91.letter = "O"
	map.p101.letter = "P"

	map.p12.letter = "A"
	map.p22.letter = "S"
	map.p32.letter = "D"
	map.p42.letter = "F"
	map.p52.letter = "G"
	map.p62.letter = "H"
	map.p72.letter = "J"
	map.p82.letter = "K"
	map.p92.letter = "L"

	map.p13.letter = "SHIFT"
	map.p23.letter = "Z"
	map.p33.letter = "X"
	map.p43.letter = "C"
	map.p53.letter = "V"
	map.p63.letter = "B"
	map.p73.letter = "N"
	map.p83.letter = "M"
	map.p93.letter = "DELETE"

	map.p14.letter = "symbols"
	map.p24.letter = ","
	map.p34.letter = " "
	map.p44.letter = "."
	map.p54.letter = "ENTER"
end

function setKeyboardToSymbols()
	map.p11.letter = "1"
	map.p21.letter = "2"
	map.p31.letter = "3"
	map.p41.letter = "4"
	map.p51.letter = "5"
	map.p61.letter = "6"
	map.p71.letter = "7"
	map.p81.letter = "8"
	map.p91.letter = "9"
	map.p101.letter = "0"

	map.p12.letter = "@"
	map.p22.letter = ":"
	map.p32.letter = ";"
	map.p42.letter = "_"
	map.p52.letter = "-"
	map.p62.letter = "#"
	map.p72.letter = "("
	map.p82.letter = ")"
	map.p92.letter = "/"

	map.p13.letter = "SIGNS"
	map.p23.letter = "\\"
	map.p33.letter = "?"
	map.p43.letter = "!"
	map.p53.letter = "'"
	map.p63.letter = "\""
	map.p73.letter = "="
	map.p83.letter = "+"
	map.p93.letter = "DELETE"

	map.p14.letter = "SYMBOLS"
	map.p24.letter = "%"
	map.p34.letter = " "
	map.p44.letter = "*"
	map.p54.letter = "ENTER"
end


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
	-- gfx.screen:copyfrom(keyboardPNG,nil, {x=3 * xUnit, y= 3 * yUnit, w=keyboardWidth, h=keyboardHeight})
end

-- displays the highlight
-- TODO
-- needs to change position of copyfrom. (0,0) now writes over keyboard 
function displayHighlightSurface()
	local coordinates = getCoordinates(highlightPosX,highlightPosY)
	local width = xUnit
	local height = yUnit
	local highlighter = nil
	local currentKey = getKeyboardChar(highlightPosX, highlightPosY)
	print(currentKey)

	if string.upper(currentKey) == "SHIFT" then
		highlighter = shiftPressedPNG
	elseif currentKey == "DELETE" then
		highlighter = deletePressedPNG
	elseif string.upper(currentKey) == "SYMBOLS" then
		highlighter = symbolPressedPNG
	elseif currentKey == " " then
		highlighter = spacePressedPNG
	elseif currentKey == "ENTER" then
		highlighter = enterPressedPNG
	else
		highlighter = keyPressedPNG
	end

	-- highlightSurface:clear()
	-- highlightSurface:copyfrom(keyPressedPNG)
	
	if (highlightPosX == 1 or highlightPosX == 9) and highlightPosY ==3 then
		width = 1.5 * xUnit
	elseif (highlightPosX == 1 or highlightPosX == 5) and highlightPosY == 4 then
		width = 2 * xUnit
	elseif highlightPosX == 3 and highlightPosY ==4 then
		width = 4 * xUnit
	end

	-- gfx.screen:copyfrom(highlightSurface, nil ,{x= coordinates.x - keyboardXUnit, y=coordinates.y - keyboardYUnit, w=width, h=height})
	gfx.screen:copyfrom(highlighter, nil ,{x= coordinates.x - keyboardXUnit, y=coordinates.y - keyboardYUnit, w=width, h=height})
end

function displayKeyboardLetters()
	-- letterSurface:clear()
	-- letterSurface:copyfrom(lowerCasePNG)
	gfx.screen:copyfrom(keyboardState,nil,{x=3 * xUnit, y= 3 * yUnit, w=keyboardWidth, h=keyboardHeight})
end

-- displays the saved text on screen
-- TODO: change pictures to fit
function displayInputField()
	inputSurface:clear()
	inputSurface:copyfrom(textAreaPNG)
	-- inputSurface:fill({r=255, g=255, b=255, a=0})
	gfx.screen:copyfrom(inputSurface, nil ,{x=2 * xUnit, y=2 * yUnit, w=12 * xUnit, h=yUnit}) --colours the saved text field
	-- gfx.screen:copyfrom(textAreaPNG, nil ,{x=2 * xUnit, y=2 *yUnit,w = 12* xUnit, h = yUnit})
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
		if highlightPosY > 4 then
			highlightPosY = 1
			updateScreen()
		else
			updateScreen()
		end
	end
	if(key == 'Up')then
		--up
		highlightPosX = getYmove(highlightPosX,highlightPosY,"up")
		highlightPosY = highlightPosY - 1
		if highlightPosY < 1 then
			highlightPosY = 4
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
			elseif(letterToDisplay == "DELETE") then

				inputText = removeLastChar(inputText)
				displayInputField()
			elseif letterToDisplay == "shift" then
				keyboardState = upperCasePNG
				setKeyboardToUpperCase()
				updateScreen()
			elseif letterToDisplay == "SHIFT" then
				keyboardState = lowerCasePNG
				setKeyboardToLowerCase()
				updateScreen()

			elseif letterToDisplay == "symbols" then
				keyboardState = symbolsPNG
				setKeyboardToSymbols()
				updateScreen()

			elseif letterToDisplay == "SYMBOLS" then
				keyboardState = lowerCasePNG
				setKeyboardToLowerCase()
				updateScreen()
			else 
				setToString(letterToDisplay)
				displayInputField()
			end
		end
	end
	gfx.update()

end

main()