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
local startPosY = yUnit*2.5
local startPosX = 5*xUnit
local startPosPicX = xUnit*3
local marginY = yUnit*1.2
local lowerBoundary = 1
local upperBoundary = 0
local highlightPosY = 1
local background = gfx.loadpng("Images/PizzeriaPics/background.png")
local inputField = gfx.loadpng("Images/PizzeriaPics/inputfield.png")
local highlight = gfx.loadpng("Images/PizzeriaPics/highlighter.png")

local lastForm = ...
local newForm = {}

--Pizzeria tables
local pizzerias = {}
local chosenPizzeria = {}


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
	displayHighlighter()
	displayPizzerias()
end

--Display pizzerias. TODO: Add functionality to display more than four pizzerias. And display only in zip code area
function displayPizzerias()
	yCoord = startPosY
	for index,value in ipairs(pizzerias) do
		pngPath = pizzerias[index].imgPath
		pizzeriaImg = gfx.loadpng("Images/PizzeriaPics/Pizzerias/"..tostring(pngPath))
		gfx.screen:copyfrom(inputField,nil,{x=startPosX, y=yCoord, h=yUnit, w=xUnit*7})
		gfx.screen:copyfrom(pizzeriaImg,nil,{x=startPosPicX, y=yCoord, h=yUnit, w=xUnit*2})
		text.print(gfx.screen, arial,pizzerias[index].name, startPosX*1.05, yCoord+marginY*0.2, xUnit*6, yUnit*4)
		upperBoundary = index
		yCoord = yCoord+marginY
		if(index == 4)then
			break
		end

	end
end
--Find the selected pizzeria and send i to addToForm()
function addPizzeria()
	chosenPizzeria = pizzerias[highlightPosY]
	addToForm(chosenPizzeria)
end
--Adds pizzeria to form
function addToForm(chosenPizzeria)
	newForm["pizzeria"] = chosenPizzeria
end

function displayHighlighter()
  gfx.screen:copyfrom(highlight, nil, {x = startPosX, y= startPosY + (highlightPosY - 1) * marginY, w = xUnit*9 , h =yUnit})
end
--Moves the current inputField
function moveHighlightedInputField(key)
	--Starting coordinates for current inputField
  if(key == 'up')then
    highlightPosY = highlightPosY - 1

    if(highlightPosY < lowerBoundary) then
      highlightPosY = upperBoundary
    end
  --Down
  elseif(key == 'down')then
    highlightPosY = highlightPosY + 1
    if(highlightPosY > upperBoundary) then
      highlightPosY = 1
    end
end
updateScreen()
end

function updateScreen()
	buildGUI()
	gfx.update()
end

function onKey(key,state)
	--TODO”
	if(state == 'up') then
  		if(key == 'up') then
	  		--Up
	  		if checkTestMode() then
				return key
			end
	  		moveHighlightedInputField(key)
	  		updateScreen()
	  	elseif(key == 'down') then
	  		--Down
	  		if checkTestMode() then
	 			return key
	 		end
	  	  	moveHighlightedInputField(key)
	  	  	updateScreen()
	  	elseif(key=='ok')then
	  		pathName = "RegistrationStep3.lua"
	  		addPizzeria()
	  		assert(loadfile(pathName))(newForm)
	  		if checkTestMode() then
	 			return key
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

	if value == "startPosY" then
		return startPosY
	elseif value == "highlightPosY" then 
		return highlightPosY
	elseif value == "upperBoundary" then
		return upperBoundary
	elseif value == "height" then
		return gfx.screen:get_height()
	elseif value == "marginY" then
		return marginY
	end
end
-- This function is used in testing when it is needed to set the value of highlightPosY to a certain number
function setValuesForTesting(value)
	highlightPosY = value
end

-- Function that returns the newForm variable so that it can be used in testing
function returnNewForm()
	return newForm
end

-- Function that returns the lastForm variable so that it can be used in testing
function returnLastForm()
	return lastForm
end

--Ischoosen is not necessary anymore
-- Function that sets the variable isChoosen to a boolean
--function setIsChoosen(value)
--	isChoosen = value
--end

--Main method
function main()
	checkForm()
	readPizzeriaFromFile()
	updateScreen()	
end
main()





