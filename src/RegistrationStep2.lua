--- Checks if the file was called from a test file.
-- @return #boolean true if called from a test file, indicating the file is being tested, else false 
function checkTestMode()
  runFile = debug.getinfo(2, "S").source:sub(2,3)
  if (runFile ~= './' ) then
    underGoingTest = false
  elseif (runFile == './') then
    underGoingTest = true
  end
  return underGoingTest
end

--- Chooses either the actual or the dummy gfx.
-- @return #string tempGfx Returns dummy gfx if the file is being tested, returns actual gfx if the file is being run.
function chooseGfx()
  if not checkTestMode() then
    tempGfx = require "gfx"
  elseif checkTestMode() then
    tempGfx = require "gfx_stub"
  end
  return tempGfx
end

--- Chooses the text
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
local startPosPicX = xUnit*2.8
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

local noOfPages = 0
local currentPage = 1
local startingIndex = 1

function checkForm()
	if type(lastForm) == "string" then

	else
		if lastForm then
				newForm = lastForm
		end
	end
end

--- Reads pizzerias from file and puts them in the pizzeria table.
function readPizzeriaFromFile()
	io.addTestPizzerias()
	if checkTestMode() then
		pizzerias = io.readPizzerias_test()
	else
		pizzerias = io.readPizzerias()
	end
end

function getNoOfPages()
  noOfPages = math.ceil(#pizzerias/4)
end

function changeCurrentPage(key)
  if(key == 'left')then
    if(currentPage > 1)then
      currentPage = currentPage -1
      startingIndex = startingIndex-4
      displayPizzerias()
    end
  elseif (key == 'right')then
    if(currentPage < noOfPages)then
      currentPage=currentPage+1
      startingIndex = startingIndex+4  
      displayPizzerias()
    end
  end
  highlightPosY = 1
  updateScreen()
end

function displayArrows()
  if(noOfPages > 1 and currentPage < noOfPages)then
  	local rightArrow = gfx.loadpng("Images/PizzaPics/rightarrow.png")
  	rightArrow:premultiply()
    gfx.screen:copyfrom(rightArrow, nil, {x = xUnit*14.7, y= yUnit*4, w = xUnit*1 , h =yUnit*2})
    rightArrow:destroy()
  end
  if(currentPage > 1)then
  	local leftArrow = gfx.loadpng("Images/PizzaPics/leftarrow.png")
  	leftArrow:premultiply()
    gfx.screen:copyfrom(leftArrow, nil, {x = xUnit*0.35, y= yUnit*4, w = xUnit*1 , h =yUnit*2})
    leftArrow:destroy()
  end
end

--Builds GUI
function buildGUI()
	gfx.screen:fill({241,248,233})
	gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
	displayHighlighter()
	getNoOfPages()
	displayPizzerias()
	displayArrows()

end

--- Display pizzerias. TODO: Add functionality to display more than four pizzerias. And display only in zip code area
function displayPizzerias()
	upperBoundary = 0
	yCoord = startPosY
	text.print(gfx.screen,"lato","black","small",tostring("Page: "..currentPage.."/"..noOfPages), startPosX*2.52, yCoord*2.85, xUnit*7, yUnit)
	for index=startingIndex, #pizzerias do
		pngPath = pizzerias[index].imgPath
		pizzeriaImg = gfx.loadpng("Images/PizzeriaPics/Pizzerias/"..tostring(pngPath))
		gfx.screen:copyfrom(inputField,nil,{x=startPosX, y=yCoord, h=yUnit, w=xUnit*7})
		gfx.screen:copyfrom(pizzeriaImg,nil,{x=startPosPicX, y=yCoord, h=yUnit, w=xUnit*2})
		text.print(gfx.screen,"lato","black","medium",pizzerias[index].name, startPosX*1.05, yCoord+marginY*0.2, xUnit*6, yUnit*4)
		upperBoundary = upperBoundary + 1
		yCoord = yCoord+marginY
		if(index == startingIndex+3)then
			break
		end
	end
end

--Finds the selected pizzeria and sends i to addToForm()
-- @return pizzerias Returns the pizzerias table
function addPizzeria()
	if checkTestMode() then
		return pizzerias
	else
		pizzeriaIndex = (4*(currentPage-1)+highlightPosY)
		chosenPizzeria = pizzerias[pizzeriaIndex]
		addToForm(chosenPizzeria)
	end
end

--- Adds a pizzeria to form
-- @param chosenPizzeria The pizzeria chosen by the user
function addToForm(chosenPizzeria)
	newForm.pizzeria = chosenPizzeria
end

--- Displays the highlighter that highlights different choices
function displayHighlighter()
  gfx.screen:copyfrom(highlight, nil, {x = startPosX, y= startPosY + (highlightPosY - 1) * marginY, w = xUnit*9 , h =yUnit})
end

--- Moves the current inputField
-- @param #string key The key that has been pressed
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

--- Updates the screen.
function updateScreen()
	buildGUI()
	gfx.update()
end

--- Gets input from user and re-directs according to input
-- @param #string key The key that has been pressed
-- @param #string state The state of the key-press
-- @return #String pathName The path that the program shall be directed to
function onKey(key,state)
	--TODO”
	if(state == 'up') then
  		if(key == 'up') then
	  		--Up
	  		if checkTestMode() then
				return key
			end
	  		moveHighlightedInputField(key)

	  	elseif(key == 'down') then
	  		if checkTestMode() then
	 			return key
	 		end
	  	  	moveHighlightedInputField(key)
	  	elseif(key == 'left') then
	  		if checkTestMode() then
	 			return key
	 		end
	  	  	changeCurrentPage(key)
	  	elseif(key == 'right') then
	  		if checkTestMode() then
	 			return key
	 		end
	  	  	changeCurrentPage(key)
	  	elseif(key=='ok')then
	  		pathName = "RegistrationStep3.lua"
	  		if checkTestMode() then
	  			return pathName
	 		end
	  		addPizzeria()
	  		assert(loadfile(pathName))(newForm)
	  	elseif(key == 'red')then
	  		pathName = "RegistrationStep1.lua"
	  		if checkTestMode() then
	  			return pathName
	  		else
	  			assert(loadfile(pathName))(newForm)
	  		end
	  	elseif key =='green' then
	  		pathName = "Menu.lua"
	  		if checkTestMode() then
		 		return pathName
			else
	  			
	  			dofile(pathName)
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
	elseif value == "lowerBoundary" then
		return lowerBoundary
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

--Main method
function main()
	checkForm()
	readPizzeriaFromFile()
	updateScreen()	
end
main()





