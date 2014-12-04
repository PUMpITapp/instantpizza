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
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/UserRegistrationPics/?.png'
  dir = sys.root_path()
else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
end

--- Variable to use when displaying printed text on the screen
--- Determine whether to use the stub or to run the actual file
local text = chooseText()

--- Declare units in variables
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

--- Start of inputFields
local startPosY = yUnit*2.5
local startPosX = 6*xUnit
local startPosXText = startPosX*1.01
local startPosYText = startPosY*0.97

--- Define the starting position of the highlight input field and the space between fields
local highlightPosY = 1
local marginY = yUnit*0.7

--- Declare the boundary levels for the input field set
local upperBoundary = 6
local lowerBoundary = 1

--- Used to control how many errors there are in the form validation
local errorCounter = 0

--- Tables used for form validation
local emptyTextFields = {}
local invalidFields = {}

--- Table to inform the user how the fields are labeled when displayed
local inputFieldTable = {}
inputFieldTable[1] = "name"
inputFieldTable[2] = "address"
inputFieldTable[3] = "zipCode"
inputFieldTable[4] = "city"
inputFieldTable[5] = "phone"
inputFieldTable[6] = "email"

--- Initiate look of the form that the user shall fill out
local newForm = {
	laststate = "RegistrationStep1.lua",
	currentInputField = "name",
	name = "",
	address= "",
	zipCode ="",
	city = "",
	phone="",
	email = "",
	pizzeria = {}
	}

--- Handle forms from other steps when directed to this step
local lastForm = ...

--- Variables to save the content of a certain field to display it again after highlighted
--- Used for memory optimization
local tempCopy = nil
local tempCoord = {}

--- Checks if there is a form sent from a previous step that needs to be considerd in this Step
function checkForm()
	newForm.currentInputField = "name"
	if type(lastForm) == "string" then
	else
		if lastForm then
				newForm = lastForm
		end
	end
end

--- Checks if this is editing of an existing user or if it is the creation of a new user
function checkEditMode()
	if(newForm.editMode == "true")then
		newForm.laststate = "RegistrationStep1.lua"
	end
end

--- Function that builds the GUI
function buildGUI()
	displayBackground()
	displayFormData()
	displayHighlighter()
	displayErrorData()
end

--- Function that displays the Background image of the application
function displayBackground()
	local backgroundPNG = gfx.loadpng("Images/UserRegistrationPics/background.png")
	backgroundPNG:premultiply()
	gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
	backgroundPNG:destroy()
end

--- Function that displays to the user if there is any faults in the inputfields for RegistrationStep1.
--  Both missing and invalid inputs are displayed using this function
function displayErrorData()
	local counter = 0
	if (#emptyTextFields) == 0 then
		-- Nothing
	else
		if (errorCounter == 0) then
			text.print(gfx.screen,"lato","black","small", "Please fill out all fields",startPosXText,startPosYText+marginY*6,500, 500)
		end
	end
	for k,v in pairs(invalidFields) do
		text.print(gfx.screen,"lato","black","small", v,startPosXText,startPosYText+marginY*(6+(counter*0.4)),500, 500)
		counter = counter + 1
	end
end

--- Displays which field the user is highlighting, using the markers x and y positions
function displayHighlighter()
	local highlighter = gfx.loadpng("Images/UserRegistrationPics/highlighter.png")
	highlighter:premultiply()
	local coord = {x = startPosX,  y= startPosY + (highlightPosY - 1) * marginY, w = xUnit * 8, h =yUnit*0.5}
	if tempCopy == nil then
    	tempCopy = gfx.new_surface(coord.w, coord.h)
    	tempCopy:copyfrom(gfx.screen,coord,nil)
    	tempCoord = coord
    else
    	gfx.screen:copyfrom(tempCopy, nil,tempCoord,true)
    	tempCopy:copyfrom(gfx.screen,coord,nil)
    	tempCoord = coord
    end

  	gfx.screen:copyfrom(highlighter, nil, coord,true)
  	highlighter:destroy()
end

--- Creates inputsurface and displays the highlighted input
function displayFormData()
	text.print(gfx.screen,"lato","black","medium", tostring(newForm.name),startPosXText,startPosYText, 500, 500)
	text.print(gfx.screen,"lato","black","medium", tostring(newForm.address),startPosXText,startPosYText+marginY,500,500)
	text.print(gfx.screen,"lato","black","medium", tostring(newForm.zipCode),startPosXText,startPosYText+marginY*2,500,500)
	text.print(gfx.screen,"lato","black","medium", tostring(newForm.city),startPosXText,startPosYText+marginY*3,500, 500)
	text.print(gfx.screen,"lato","black","medium", tostring(newForm.phone),startPosXText,startPosYText+marginY*4,500, 500)
	text.print(gfx.screen,"lato","black","medium", tostring(newForm.email),startPosXText,startPosYText+marginY*5,500, 500)
end

--- Deletes the currect surfaces from the box's RAM memory, clearing up space for new surfaces
function destroyTempSurfaces()
	tempCopy:destroy()
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
	      highlightPosY = lowerBoundary
	    end
	end
	newForm.currentInputField = inputFieldTable[highlightPosY]
	displayHighlighter()
	gfx.update()
end

--- Function that that updates the current screen to be able to show new or changed information to the user
function updateScreen()
	buildGUI()
	gfx.update()
end


--- Gets input from user and re-directs according to input
-- @param key The key that has been pressed
-- @param state The state of the key-press
-- @return pathName The path that the program shall be directed to
function onKey(key,state)
	if(state == 'up') then
		if(key == 'up')then
			if checkTestMode() then
				return key
			end
			moveHighlightedInputField(key)
	 	elseif(key == 'down')then
	 		if checkTestMode() then
	 			return key
	 		end
	 		moveHighlightedInputField(key)
		elseif(key == "ok") then
			-- Open keyboard
			pathName = dir .. "Keyboard.lua"
			if checkTestMode() then
			 	return pathName
			else
				destroyTempSurfaces()
				assert(loadfile(pathName))(newForm)
			end
	  	elseif(key == 'green') then
	  		-- Go Back to menu
	  		pathName = dir .. "Menu.lua"
	  		if checkTestMode() then
	  			return pathName
	  		else
	  			destroyTempSurfaces()
	  			assert(loadfile(pathName))(newForm)
	  		end
	  	elseif(key == 'blue') then
	  		-- Next Step
	  		emptyFormValidation(newForm)
	  		if ((#emptyTextFields) == 0) and (errorCounter == 0) then
	  			pathName = dir .. "RegistrationStep2.lua"
	  			if checkTestMode() then
	  				return pathName
	  			else
	  				destroyTempSurfaces()
	  				assert(loadfile(pathName))(newForm)
	  			end
	  		else
	  			-- displayErrorData()
	  			updateScreen()
	  		end
	  	-- elseif(key == 'yellow') then
	  	-- 	pathName = dir .. "RegistrationStep2.lua"
	  	-- 	destroyTempSurfaces()
	  	-- 	assert(loadfile(pathName))(newForm)
	  	else
	  		-- TODO:
	  		-- More options for buttonpress?
	  		-- Test cases needs to be written if more options for onKey is added
	  	end
	end
end
--- Function that checks if the form that the user has written is empty or not
-- @param form Takes in a form to check status of it
function emptyFormValidation(form)
	emptyTextFields = {}
	-- Checks if a textfield is empty
	for k,v in pairs(form) do
		if k == "pizzeria" then
		else
			if string.len(form[k]) == 0 then
				table.insert(emptyTextFields, k)
			else
				-- Nothing
			end
		end

	end
end

--- Function that checks if the form that the user has written has any invalid inputs
-- @param form Takes in a form to check status of it
function invalidFormValidation(form)
	invalidFields = {}
	errorCounter = 0
	-- Checks if zipcode is 5 digits (Swedish standard)
	if (not string.match(form.zipCode, '^%d%d%d%d%d$') and string.len(form.zipCode) ~= 0) then
		-- print("Incorrect zip-code, write five digits(no spaces)")		
		invalidFields["zipCode"] = "Incorrect zip-code, write five digits(no spaces)"
		errorCounter = errorCounter + 1
	else
		
	end
	-- Checks if phone number is 10 digits (Swedish standard)
	if (not string.match(form.phone, '^%d%d%d%d%d%d%d%d%d%d$') and  string.len(form.phone) ~= 0) then
		-- print("Incorrect phone number, write ten digits(no spaces)")		
		invalidFields["phone"] = "Incorrect phone number, write ten digits(no spaces)"
		errorCounter = errorCounter + 1
	else
		
	end
	-- Checks if the input email is on the correct form (SomeCharacters@Something.Short)
	if (not string.match(form.email, '[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?') and  string.len(form.email) ~= 0) then
		-- print("Incorrect email, use valid characters")		
		invalidFields["email"] = "Incorrect email, use valid characters"
		errorCounter = errorCounter + 1		
	else		
	end
end

--- Below are functions that is required for the testing of this file

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

-- Main method
function onStart()
	checkForm()
	checkEditMode()
	newForm.currentInputField = "name"
	invalidFormValidation(newForm)
	updateScreen()
end
onStart()