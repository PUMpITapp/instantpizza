--- Set if the program is running on the box or not
local onBox = true

--- Checks if the file was called from a test file.
-- @return true if called from a test file, indicating the file is being tested, else false 
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
-- @return tempGfx Returns dummy gfx if the file is being tested, returns actual gfx if the file is being run.
function chooseGfx()
  if not checkTestMode() then
    tempGfx = require "gfx"
  elseif checkTestMode() then
    tempGfx = require "gfx_stub"
  end
  return tempGfx
end

--- Chooses the text
-- @return tempText Returns write_text_stub if the file is being tested, returns actual write_text if the file is being run.
function chooseText()
  if not checkTestMode() then
    tempText = require "write_text"
  elseif checkTestMode() then
    tempText = require "write_text_stub"
  end
  return tempText
end

--- Change the path system if the app runs on the box comparing to the emulator
if onBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/PizzeriaPics/?.png'
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/PizzeriaPics/Pizzerias/?.png'
  dir = sys.root_path()
else
  gfx =  chooseGfx()
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
end

--- Variable to use when handling tables that are stored in the system
local io = require "IOHandler"

--- Variable to use when displaying printed text on the screen
--- Determine whether to use the stub or to run the actual file
local text = chooseText()

--- Declare units in variables
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

--- Start of inputFields
local startPosY = yUnit*2.5
local startPosX = 5*xUnit
local startPosPicX = xUnit*2.8

--- Define the starting position of the highlight input field and the space between fields
local highlightPosY = 1
local marginY = yUnit*1.2

--- Declare the boundary levels for the input field set
local lowerBoundary = 1
local upperBoundary = 0

--- Handle forms from last step and initiate a new form for this step
local lastForm = ...
local newForm = {}

--- Pizzeria tables
local pizzerias = {}
local chosenPizzeria = {}

--- Page counter variables to display a varying number of pizzerias in several pages
local noOfPages = 0
local currentPage = 1
local startingIndex = 1
local lastPage = currentPage

--- Variables to save the content of a certain field to display it again after highlighted
--- Used for memory optimization
local tempCopy = nil
local coord = {}

--- Checks if there is a form sent from a previous step that needs to be considerd in this Step
function checkForm()
	if type(lastForm) == "string" then
		-- Nothing
	else
		if lastForm then
				newForm = lastForm
		end
	end
end

--- Reads pizzerias from file and puts them in the pizzeria table.
function readPizzeriaFromFile()
	-- Uncomment if pizzeria_data is empty
	--io.addTestPizzerias()
	if checkTestMode() then
		pizzerias = io.readPizzerias_test()
	else
		pizzerias = io.readPizzerias()
	end
end

--- Function that determines total number of pages with pizzerias
function getNoOfPages()
  noOfPages = math.ceil(#pizzerias/4)
end

--- Changes to the next or previous page of pizzerias to display
-- @param key The key that has been pressed
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

--- Function that determines which arrows that shall be shown depending on the current page of pizzerias
function displayArrows()
  if(noOfPages > 1 and currentPage < noOfPages)then
  	local rightArrow = gfx.loadpng("Images/PizzaPics/rightarrow.png")
  	rightArrow:premultiply()
    gfx.screen:copyfrom(rightArrow, nil, {x = xUnit*14.7, y= yUnit*4, w = xUnit*1 , h =yUnit*2},true)
    rightArrow:destroy()
  end
  if(currentPage > 1)then
  	local leftArrow = gfx.loadpng("Images/PizzaPics/leftarrow.png")
  	leftArrow:premultiply()
    gfx.screen:copyfrom(leftArrow, nil, {x = xUnit*0.35, y= yUnit*4, w = xUnit*1 , h =yUnit*2},true)
    leftArrow:destroy()
  end
end

--- Function that builds the GUI
function buildGUI()
	displayBackground()
	getNoOfPages()
	displayPizzerias()
	displayArrows()
	displayHighlighter()
end

--- Function that displays the Background image of the application
function displayBackground()
	local backgroundPNG = gfx.loadpng("Images/PizzeriaPics/background.png")
	backgroundPNG:premultiply()
	gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
	backgroundPNG:destroy()
end

--- Display pizzerias. TODO: Add functionality to display more than four pizzerias. And display only in zip code area
function displayPizzerias()
	local inputField = gfx.loadpng("Images/PizzeriaPics/inputfield.png")
	inputField:premultiply()
	upperBoundary = 0
	yCoord = startPosY
	text.print(gfx.screen,"lato","black","small",tostring("Page: "..currentPage.."/"..noOfPages), startPosX*2.52, yCoord*2.85, xUnit*7, yUnit)
	-- Loops through all pizzerias that shall be displayed
	for index=startingIndex, #pizzerias do
		pngPath = pizzerias[index].imgPath
		pizzeriaImg = gfx.loadpng("Images/PizzeriaPics/Pizzerias/"..tostring(pngPath))
		gfx.screen:copyfrom(inputField,nil,{x=startPosX, y=yCoord, h=yUnit, w=xUnit*7},true)
		gfx.screen:copyfrom(pizzeriaImg,nil,{x=startPosPicX, y=yCoord, h=yUnit, w=xUnit*2},true)
		text.print(gfx.screen,"lato","black","medium",pizzerias[index].name, startPosX*1.05, yCoord+marginY*0.2, xUnit*6, yUnit*4)
		pizzeriaImg:destroy()
		upperBoundary = upperBoundary + 1
		yCoord = yCoord+marginY
		-- Stop displaying when the maximum number of pizzerias is shown
		if(index == startingIndex+3)then
			break
		end
	end
	inputField:destroy()
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
	local highlighter = gfx.loadpng("Images/PizzeriaPics/highlighter.png")
	highlighter:premultiply()
	local coord =  {x = startPosX, y= startPosY + (highlightPosY - 1) * marginY, w = xUnit*9 , h =yUnit}

    if tempCopy == nil then
      tempCopy = gfx.new_surface(coord.w, coord.h)
      tempCopy:copyfrom(gfx.screen,coord,nil)
      tempCoord = coord
    elseif lastPage == currentPage then
      gfx.screen:copyfrom(tempCopy, nil,tempCoord,true)
      tempCopy:copyfrom(gfx.screen,coord,nil)
      tempCoord = coord
    else
      tempCopy:copyfrom(gfx.screen,coord,nil)
      tempCoord = coord
      lastPage = currentPage
    end

	gfx.screen:copyfrom(highlighter, nil,coord,true)
	highlighter:destroy()
end

--- Moves the current inputField
-- @param key The key that has been pressed
function moveHighlightedInputField(key)
  	if(key == 'up')then
	    highlightPosY = highlightPosY - 1
	    if(highlightPosY < lowerBoundary) then
	      highlightPosY = upperBoundary
	    end
	  elseif(key == 'down')then
	    highlightPosY = highlightPosY + 1
	    if(highlightPosY > upperBoundary) then
	      highlightPosY = 1
	    end
	end
	displayHighlighter()
	gfx.update()
end

--- Function that that updates the current screen to be able to show new or changed information to the user
function updateScreen()
	buildGUI()
	gfx.update()
end

--- Deletes the currect surfaces from the box's RAM memory, clearing up space for new surfaces
function destroyTempSurfaces()
	tempCopy:destroy()
end

--- Gets input from user and re-directs according to input
-- @param key The key that has been pressed
-- @param state The state of the key-press
-- @return pathName The path that the program shall be directed to
function onKey(key,state)
	if(state == 'up') then
  		if(key == 'up') then
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
	  		-- Next step
	  		pathName = dir .. "RegistrationStep3.lua"
	  		if checkTestMode() then
	  			return pathName
	 		end
	  		addPizzeria()
	  		destroyTempSurfaces()
	  		assert(loadfile(pathName))(newForm)
	  	elseif(key == 'red')then
	  		-- Go back to last step
	  		pathName = dir .. "RegistrationStep1.lua"
	  		if checkTestMode() then
	  			return pathName
	  		else
	  			destroyTempSurfaces()
	  			assert(loadfile(pathName))(newForm)
	  		end
	  -- 	elseif key =='green' then
	  -- 		-- Go back to menu
	  -- 		pathName = dir .. "Menu.lua"
	  -- 		if checkTestMode() then
		 -- 		return pathName
			-- else
	  -- 			destroyTempSurfaces()
	  -- 			dofile(pathName)
	  -- 		end
	  	end
	  	  	
 	end
end

-- Below are functions that is required for the testing of this file

--- Creates a customized newForm and lastFrom to test the functionality of the function checkFrom()
-- @param String input from the Tester about what forms that should be created
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

--- Functions that returns some of the values on local variables to be used when testing
-- @param value Sets the different testing values
-- @return StartPosY Starting position of the marker for this page
-- @return HightlightPosY Current position of the marker
-- @return upperBoundary Value of the highest position the marker can go before going offscreen
-- @return lowerBoundary Value of the lowerst position the marker can go before going offscreen
-- @return height Height of the screen
-- @return marginY Space that the highlighter shall jump
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

--- Function that sets the markers position to a selected value
-- @param value Value that the user wants to set the marker on 
function setValuesForTesting(value)
	highlightPosY = value
end

--- Function that returns the newForm variable so that it can be used in testing
-- @return newForm Currect form being used by this Registration step
function returnNewForm()
	return newForm
end

--- Function that returns the lastForm variable so that it can be used in testing
-- @return newForm Currect form being used by the previous Registration step
function returnLastForm()
	return lastForm
end

--- Main method
function onStart()
	checkForm()
	readPizzeriaFromFile()
	updateScreen()	
end
onStart()





