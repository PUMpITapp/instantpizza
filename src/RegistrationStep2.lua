--- Checks if the file was called from a test file.
-- Returs true if it was, 
--   - which would mean that the file is being tested.
-- Returns false if it was not,
--   - which wold mean that the file was being used.  
function checkTestMode()
  runFile = debug.getinfo(2, "S").source:sub(2,3)
  if (runFile ~= './' ) then
    underGoingTest = false
  elseif (runFile == './') then
    underGoingTest = true
  end
  return underGoingTest
end

--- Chooses either the actual or he dummy gfx.
-- Returns dummy gfx if the file is being tested.
-- Rerunes actual gfx if the file is being run.
function chooseGfx()
  if not checkTestMode() then
    tempGfx = require "gfx"
  elseif checkTestMode() then
    tempGfx = require "gfx_stub"
  end
  return tempGfx
end

function chooseText()
  if not checkTestMode() then
    tempText = require "write_text"
  elseif checkTestMode() then
    tempText = require "write_text_stub"
  end
  return tempText
end
local io = require "IOHandler"
local text = chooseText(checkTestMode())
local gfx =  chooseGfx(checkTestMode())

--Declare units i variables
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9


 --Start of inputFields. Needed for 
local inputMovement = yUnit*1.2
local inputFieldX = gfx.screen:get_width()/8
local inputFieldY = yUnit*2.5
local inputFieldStart = yUnit*2.5
local inputFieldEnd = 0
local isChoosen = false
local pizzeriaToAdd = ""

local background = gfx.loadpng("Images/PizzeriaPics/background.png")
local inputField = gfx.loadpng("Images/PizzeriaPics/inputfield.png")
local highlight = gfx.loadpng("Images/PizzeriaPics/highlighter.png")

local lastForm = ...
local newForm = {}

--Pizzeria tables
local pizzerias = {}
local pizzeria = {}
local highlightFieldPos = 1

function checkForm()
	if type(lastForm) == "string" then

	else
		if lastForm then
			if lastForm.laststate == newForm.laststate then
				newForm = lastForm
			else
				for k,v in pairs(lastForm) do
					if not newForm[k] then
						newForm[k] = v
					end
				end
			end
		end
	end
end
--Reads pizzerias from file. Returns a table containing pizzeria objects. 
function readPizzeriaFromFile()
	pizzerias = io.readPizzerias()

end
--Builds GUI
function buildGUI()
	gfx.screen:fill({241,248,233})
	gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
	displayHighlightSurface()
	displayPizzerias()
	displayisChoosen()
end
--Displays chosen pizzeria in cart
function displayisChoosen()
	if (isChoosen)then
		text.print(gfx.screen, arial,pizzeria.name, xUnit*13, yUnit*1.5, 5 * xUnit, 5 * yUnit)
	end
end
--Display pizzerias. TODO: Add functionality to display more than four pizzerias. And display only in zip code area
function displayPizzerias()
	yCoord = inputFieldStart
	counter = 1
	for index,value in ipairs(pizzerias) do

		pngPath = pizzerias[index].imgPath
		pizzeriaImg = gfx.loadpng("Images/PizzeriaPics/Pizzerias/"..tostring(pngPath))
		gfx.screen:copyfrom(inputField,nil,{x=xUnit*3, y=yCoord, h=xUnit, w=yUnit*7})
		gfx.screen:copyfrom(pizzeriaImg,nil,{x=xUnit*3, y=yCoord, h=xUnit, w=yUnit*2})
		text.print(gfx.screen, arial,pizzerias[index].name, xUnit*5.1, yCoord*1.1, xUnit*6, yUnit*4)
		inputFieldEnd = yCoord
		yCoord = yCoord+inputMovement
		if(counter == 4)then
			break
		end
		counter = counter+1

	end
end
--Find the selected pizzeria and send i to addToForm()
function addPizzeria()
	pizzeria = pizzerias[highlightFieldPos]
	addToForm(pizzeria)
	isChoosen = true
end
--Adds pizzeria to form
function addToForm(pizzeria)
	newForm["pizzeria"] = pizzeria
end

function displayHighlightSurface()
	gfx.screen:copyfrom(highlight,nil,{x=xUnit*3, y=inputFieldY, h=xUnit, w=yUnit*9})
end

--Moves the current inputField
function moveHighlightedInputField(key)
	--Starting coordinates for current inputField
	if(key == 'Up') then
		if(inputFieldY > inputFieldStart) then
			inputFieldY = inputFieldY - inputMovement
			highlightFieldPos = highlightFieldPos -1
		end
		-- No functionality written for when user is at the top position and pressing 'Up'
	end
	--Down
	if(key == 'Down') then
		if(inputFieldY < inputFieldEnd) then
			inputFieldY = inputFieldY + inputMovement
			highlightFieldPos = highlightFieldPos + 1
		
		elseif(inputFieldY == inputFieldEnd) then
			inputFieldY = inputFieldStart
			highlightFieldPos = 1
		end
	end
end

--Method that prints picture to screen. Takes picture and x,y coordinates as argument.
function printPicture(pic,xx,yy)
 	gfx.screen:copyfrom(pic, nil, {x=xx,y=yy})
end

function updateScreen()
	buildGUI()
	gfx.update()
end
function onKey(key,state)
	--TODO”
	if(state == 'up') then
  		if(key == 'Up') then
	  		--Up
	  		if checkTestMode() then
				return key
			end
	  		moveHighlightedInputField(key)
	  		updateScreen()
	  	elseif(key == 'Down') then
	  		--Down
	  		if checkTestMode() then
	 			return key
	 		end
	  	  	moveHighlightedInputField(key)
	  	  	updateScreen()
	  	elseif(key=='Return')then
	  		if checkTestMode() then
	 			return key
	 		end
	  		addPizzeria()
	  		updateScreen()
	  	elseif(key == 'blue') then
			if isChoosen then
				pathName = "RegistrationStep3.lua"
				if checkTestMode() then
					return pathName
				else
					assert(loadfile(pathName))(newForm)
				end
			else
				message = "Need pizzeria to proceed"
				if checkTestMode() then
					return message
				else
					text.print(gfx.screen, arial, message , xUnit*12, yUnit*4, xUnit*4, yUnit)
				end
			end
	  	elseif(key == 'red')then
	  		pathName = "RegistrationStep1.lua"
	  		if checkTestMode() then
	  			return pathName
	  		else
	  			assert(loadfile(pathName))(newForm)
	  		end
	  	end
 	end
end

-- Below are functions that is required for the testing of this file

-- CreateFormsForTest creates a customized newForm and lastFrom to test the functionality of the function checkFrom()
function createFormsForTest(String)
	if String == "Not equal, State equal" then
		lastForm = {currentInputField = "name",name = "Mikael", address = "Sveavagen", zipCode = "58439", city="Stockholm", phone="112", email="PUMpITapp@TDDC88.com"}
		newForm = {currentInputField = "name", name = "Mikael"}
		newForm.laststate = "1"
		lastForm.laststate = "1"
	elseif String == "Not equal, State not equal" then
		lastForm = {currentInputField = "name",name = "Mikael", address = "Sveavagen", zipCode = "58439", city="Stockholm", phone="112", email="PUMpITapp@TDDC88.com"}
		newForm = {currentInputField = "name", name = "Mikael"}
		newForm.laststate = "1"
		lastForm.laststate = "2"
	elseif String == "Equal, State equal" then
		lastForm = {currentInputField = "name",name = "Mikael", address = "Sveavagen", zipCode = "58439", city="Stockholm", phone="112", email="PUMpITapp@TDDC88.com"}
		newForm = {currentInputField = "name",name = "Mikael", address = "Sveavagen", zipCode = "58439", city="Stockholm", phone="112", email="PUMpITapp@TDDC88.com"}
		newForm.laststate = "1"
		lastForm.laststate = "1"
	elseif String == "Equal, State not equal" then
		lastForm = {currentInputField = "name",name = "Mikael", address = "Sveavagen", zipCode = "58439", city="Stockholm", phone="112", email="PUMpITapp@TDDC88.com"}
		newForm = {currentInputField = "name",name = "Mikael", address = "Sveavagen", zipCode = "58439", city="Stockholm", phone="112", email="PUMpITapp@TDDC88.com"}
		newForm.laststate = "1"
		lastForm.laststate = "2"
	end
end

-- This functions returns some of the values on local variables to be used when testing
function returnValuesForTesting(value)

	if value == "inputFieldStart" then
		return inputFieldStart
	elseif value == "inputFieldY" then 
		return inputFieldY
	elseif value == "inputFieldEnd" then
		return inputFieldEnd
	elseif value == "height" then
		return gfx.screen:get_height()
	elseif value == "inputMovement" then
		return inputMovement
	end
end
-- This function is used in testing when it is needed to set the value of inputFieldY to a certain number
function setValuesForTesting(value)
	inputFieldY = value
end

-- Function that returns the newForm variable so that it can be used in testing
function returnNewForm()
	return newForm
end

-- Function that returns the lastForm variable so that it can be used in testing
function returnLastForm()
	return lastForm
end

-- Function that sets the variable isChoosen to a boolean
function setIsChoosen(value)
	isChoosen = value
end

--Main method
function main()
	checkForm()
	readPizzeriaFromFile()
	updateScreen()	
end
main()





