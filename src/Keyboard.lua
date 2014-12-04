--- Tells if the program shall be run on the box or not
local runningOnBox = true

--- Checks if the program is run on the box or not
if runningOnBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/KeyboardPics/?.png'
  dir = sys.root_path()
else
gfx = require "gfx"
  	sys = {}
  	sys.root_path = function () return '' end
  	dir = ""
end

--- Variable to use when displaying printed text on the screen
--- Determine whether to use the stub or to run the actual file
local text = require "write_text"

--- variable for checking which state the keyboard is in
local keyboardState = "SHIFT"

--- surfaces that saves parts of gfx.screen for faster computation
local keyboardSurface = nil
local textAreaSurface = nil

--- Declare units in variables
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

--- Declare different keyboard units used in keyboard
local keyboardWidth = 10 * xUnit
local keyboardHeight = 4 * yUnit
local keyboardXUnit = keyboardWidth/10
local keyboardYUnit = keyboardHeight/4
local keyboardPosX = 3 * xUnit
local keyboardPosY = 3 * yUnit

--- Declare the highlight position
local highlightPosX = 1
local highlightPosY = 1

--- Declare the text that the keyboard will write to
local inputText = ""

--- the data (varargs)
local lastForm = ...

--- init the mapelements that will be the key in keyboard
local mapElement = {}

--- Function that creates a new mapelement
-- @return setsmetatable the function to the mapElement table
-- @param #string key. what letter the key will have
-- @param #integer row. what row mapelement will be in
-- @param #integer column. what column the mapelement will be in
-- @param #number posx. what position on X-axis the key is mapped on
-- @param #number posy. what position on y-axis the key is mapped on
-- @param #integer upMove. what is legitimate upmove from key
-- @param #integer downMove. what is legitimate downmove from key
-- @param #integer leftmove. what is legitimate leftmove from key
-- @param #integer rightmove. what is legitimate rightmove from key
function mapElement:new(key,row,column,posX,posY,upMove,downMove,leftMove,rightMove)
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

--- init the map with the keys of smallcase
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

	p14 = mapElement:new("symbols",1,4,keyboardPosX + 1 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,1,1),
	p24 = mapElement:new(",",2,4,keyboardPosX +3 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,2,3),
	p34 = mapElement:new(" ",3,4,keyboardPosX +4 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,5,5),
	p44 = mapElement:new(".",4,4,keyboardPosX +8 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,8,8),
	p54 = mapElement:new("ENTER",5,4,keyboardPosX +9 * keyboardXUnit, keyboardPosY +4 * keyboardYUnit,9,10)
}

--- Function that sets the keyboard to lower case
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

--- Function that sets the keyboard to upper case
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

--- Function that sets the keyboard to symbols
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

--- Main method that starts when the box runs
function onStart()
	setInputText(lastForm[lastForm.currentInputField])
	createWhiteBackground()
	keyboardState = getState()
	createKeyboardSurface(keyboardState)
	updateScreen()
end

--- function that updates the whole screen in the correct order
function updateScreen()
	displayKeyboardSurface()
	displayInput()
	displayHighlightSurface()
	gfx.update()
end

--- function that inits the inputText to a value
-- @param #string the text to be saved on inputText
function setInputText(text)
	inputText = text
end

--- display keyboardsurface on gfx
function displayKeyboardSurface()
	gfx.screen:copyfrom(keyboardSurface,nil,{x=keyboardPosX,y = keyboardPosY, w= keyboardWidth,h = keyboardHeight},true)
end

--- creates the white background
function createWhiteBackground()
	local whiteBackgroundPNG = gfx.loadpng("Images/KeyboardPics/keyboardbackgroundwhite.png")
	whiteBackgroundPNG:premultiply()
	gfx.screen:copyfrom(whiteBackgroundPNG,nil,{x=0 , y= 0 , w=16*xUnit, h=9*yUnit},true)
	whiteBackgroundPNG:destroy()
end

--- creates the keyboardsurface with correct casing
-- @param #string state for creating correct keyboard
function createKeyboardSurface(state)
	local coord = {x=keyboardPosX,y = keyboardPosY, w= keyboardWidth,h = keyboardHeight}
	local letters = nil
	local keyboardPNG = gfx.loadpng("Images/KeyboardPics/keyboardblank.png")
	
	keyboardPNG:premultiply()
	gfx.screen:copyfrom(keyboardPNG,nil, coord,true)
	keyboardPNG:destroy()
	if state == "shift" then
		letters = gfx.loadpng("Images/KeyboardPics/upperCase.png")
	elseif state == "SHIFT" then
		letters = gfx.loadpng("Images/KeyboardPics/lowerCase.png")
	elseif state == "symbols" then
		letters = gfx.loadpng("Images/KeyboardPics/symbols.png")
	elseif state == "SYMBOLS" then
		letters = gfx.loadpng("Images/KeyboardPics/lowerCase.png")
	elseif state == "SIGNS" then
		letters = gfx.loadpng("Images/KeyboardPics/lowerCase.png") --incorrect!
	end
	letters:premultiply()
	gfx.screen:copyfrom(letters,nil,{x=3 * xUnit, y= 3 * yUnit, w=keyboardWidth, h=keyboardHeight},true)
	letters:destroy()
	if keyboardSurface == nil then
		keyboardSurface = gfx.new_surface(coord.w, coord.h)
	end
		keyboardSurface:copyfrom(gfx.screen,coord,nil)
end
--- gets what kind of state the keyboard should be in
-- @return states for keyboard
function getState()
	if lastForm.currentInputField ~= nil then
		if lastForm.currentInputField == "zipCode" or lastForm.currentInputField == "phone" then
			return "symbols"
		else	
			return "SHIFT"
		end
	else
		return "SHIFT"
	end
end

--- displays the correct highlight over the correct key
function displayHighlightSurface()

	local coordinates = getCoordinates(highlightPosX,highlightPosY)
	local width = xUnit
	local height = yUnit
	local highlighter = nil
	local currentKey = getKeyboardChar(highlightPosX, highlightPosY)

	if string.upper(currentKey) == "SHIFT" then
		highlighter = gfx.loadpng("Images/KeyboardPics/shiftPressed.png")
	elseif currentKey == "DELETE" then
		highlighter = gfx.loadpng("Images/KeyboardPics/deletePressed.png")
	elseif string.upper(currentKey) == "SYMBOLS" then
		highlighter = gfx.loadpng("Images/KeyboardPics/symbolPressed.png")
	elseif currentKey == " " then
		highlighter = gfx.loadpng("Images/KeyboardPics/spacePressed.png")
	elseif currentKey == "ENTER" then
		highlighter = gfx.loadpng("Images/KeyboardPics/enterPressed.png")
	elseif currentKey == "SIGNS" then
		highlighter = gfx.loadpng("Images/KeyboardPics/shiftPressed.png")
	else
		highlighter = gfx.loadpng("Images/KeyboardPics/standKeyPressed.png")
	end
	
	if (highlightPosX == 1 or highlightPosX == 9) and highlightPosY ==3 then
		width = 1.5 * xUnit
	elseif (highlightPosX == 1 or highlightPosX == 5) and highlightPosY == 4 then
		width = 2 * xUnit
	elseif highlightPosX == 3 and highlightPosY ==4 then
		width = 4 * xUnit
	end

	highlighter:premultiply()
	local coord = {x= coordinates.x - keyboardXUnit, y=coordinates.y - keyboardYUnit, w=width, h=height}
	gfx.screen:copyfrom(highlighter, nil, coord,true)
	highlighter:destroy()
end


--- displays the  inputText on screen
function displayInput()
	if(textAreaSurface == nil) then
		local textAreaPNG = gfx.loadpng("Images/KeyboardPics/textArea.png")
		textAreaPNG:premultiply()
		gfx.screen:copyfrom(textAreaPNG, nil ,{x=2 * xUnit, y=2 * yUnit, w=12 * xUnit, h=yUnit},true) --colours the saved text field
		textAreaSurface = gfx.new_surface(12 * xUnit,yUnit)
		textAreaSurface:copyfrom(gfx.screen,{x=2 * xUnit, y=2 * yUnit, w=12 * xUnit, h=yUnit},nil)
		textAreaPNG:destroy()
	else
		gfx.screen:copyfrom(textAreaSurface, nil ,{x=2 * xUnit, y=2 * yUnit, w=12 * xUnit, h=yUnit},true) --colours the saved text field
	end
	text.print(gfx.screen, "lato","black","medium", inputText.."|", 2.5 * xUnit, 2.2 * yUnit, 12 * xUnit, yUnit)
end

--- gets the map coordingates from the key position
-- @return pos if coordinate exists, else nil
-- @param #integer posx for getting coordinates
-- @param #integer posy for getting coordinates
function getCoordinates(posX, posY)
	local pos = "p"..posX..posY
	if map[pos] then
		return map[pos]
	else
		return nil
	end
end

--- gets the correct movement of cursor when moving in y-axis
-- @returns the correct move for y-axis
-- @param #integer xVal for getting correct ymove
-- @param #integer yVal for getting correct ymove
-- @param #string move for getting correct ymove
function getYmove(xVal,yVal,move)
	local coordinates = "p"..xVal..yVal
	return map[coordinates][move]
end

--- gets the char that is highlighted
-- @return the letter on highlighted key
-- @param #integer row for getting the correct key
-- @param #integer column for getting the correct key
function getKeyboardChar(row, column)
	local coordinates = "p"..row..column
	return map[coordinates].letter
end

--- saves character to string
-- @param #string saves the character to the string
function setToString(character)
	if character then
	inputText = inputText .. character
	end
end

--- saves the text to the form to be sent back to last state
-- @param #string mytext saved to the form
function saveToForm(myText)
	local inputField = lastForm.currentInputField
	lastForm[inputField] = myText
end

--- send form back to state and destroys all the surfaces 
-- @param #string state which state the form is sent back to
-- @param #table form the form that is sended back
function sendFormBackToState(state, form)
	saveToForm(inputText)
	destroyTempSurfaces()
	assert(loadfile(state))(form)
end

--- destroys all the surfaces
function destroyTempSurfaces()
	keyboardSurface:destroy()
	textAreaSurface:destroy()
end

--- removes the last char in the argument
-- @return the modified strings
-- @param #string input to be moved from
function removeLastChar(input)
	return string.sub(input, 1, #input-1)
end

--- moves the highligther around
-- @param #string key that is pressed on
function movehighlightKey(key)
	if(key == 'down')then
		--down
		highlightPosX = getYmove(highlightPosX,highlightPosY,"down")
		highlightPosY = highlightPosY + 1
		if highlightPosY > 4 then
			highlightPosY = 1
		end
	elseif(key == 'up')then
		--up
		highlightPosX = getYmove(highlightPosX,highlightPosY,"up")
		highlightPosY = highlightPosY - 1
		if highlightPosY < 1 then
			highlightPosY = 4
		end
	elseif(key == 'left')then
		--left
		highlightPosX = highlightPosX - 1
		highlightPosY = highlightPosY + 0

		if not(getCoordinates(highlightPosX,highlightPosY))then
			if highlightPosY == 1 then
				highlightPosX = 10
			elseif highlightPosY == 2 or highlightPosY == 3 then
				highlightPosX = 9
			else
				highlightPosX = 5
			end
		end
	elseif(key == 'right')then
		--right
		highlightPosX = highlightPosX + 1
		highlightPosY = highlightPosY + 0
		if not(getCoordinates(highlightPosX,highlightPosY))then
			highlightPosX = 1
		end
	end
		displayKeyboardSurface()
		displayHighlightSurface()
		gfx.update()
end

--- calls functions on keys
-- @param #string key that is pushed on
-- @param #string state that the key pushed on is at
function onKey(key, state)
	if(state == 'up')then
		if(key == 'up') then
			movehighlightKey(key)
		elseif(key == 'down') then
			movehighlightKey(key)
		elseif(key == 'left') then
			movehighlightKey(key)
		elseif(key == 'right') then
			movehighlightKey(key)
		elseif(key == 'blue') then
			sendFormBackToState(dir..lastForm.laststate, lastForm)
		elseif(key == 'red') then
			inputText = removeLastChar(inputText)
			displayInput()
			gfx.update()
		elseif(key == 'green') then
			keyboardState = map.p14.letter
			if keyboardState == "symbols" then
				setKeyboardToSymbols()
				createKeyboardSurface(keyboardState)
			else
				setKeyboardToLowerCase()
				createKeyboardSurface(keyboardState)
			end
				updateScreen()
		elseif(key == 'yellow') then
			keyboardState = map.p13.letter
			if keyboardState == "shift" then
				setKeyboardToUpperCase()
				createKeyboardSurface(keyboardState)
			else
				setKeyboardToLowerCase()
				createKeyboardSurface(keyboardState)
			end
			updateScreen()
		elseif(key == 'ok') then

			local letterToDisplay = getKeyboardChar(highlightPosX,highlightPosY)
			if (letterToDisplay == "ENTER") then
				sendFormBackToState(dir..lastForm.laststate, lastForm)
			elseif(letterToDisplay == "DELETE") then
				inputText = removeLastChar(inputText)
				displayInput()
				gfx.update()
			elseif letterToDisplay == "shift" then
				keyboardState = letterToDisplay
				setKeyboardToUpperCase()
				createKeyboardSurface(keyboardState)
				updateScreen()
			elseif letterToDisplay == "SHIFT" then
				keyboardState = letterToDisplay
				setKeyboardToLowerCase()
				createKeyboardSurface(keyboardState)
				updateScreen()

			elseif letterToDisplay == "symbols" then
				keyboardState = letterToDisplay
				setKeyboardToSymbols()
				createKeyboardSurface(keyboardState)
				updateScreen()

			elseif letterToDisplay == "SYMBOLS" then
				keyboardState = letterToDisplay
				setKeyboardToLowerCase()
				createKeyboardSurface(keyboardState)
				updateScreen()

			elseif letterToDisplay == "SIGNS" then
				keyboardState = letterToDisplay
				setKeyboardToLowerCase()
				createKeyboardSurface(keyboardState)
				updateScreen()
			else 
				setToString(letterToDisplay)
				displayInput()
				gfx.update()
			end
		end
	end
end

onStart()