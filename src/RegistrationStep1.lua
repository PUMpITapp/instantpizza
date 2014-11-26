--TODO:
--Another background and text font/color
--Real graphic components
--Inputs from user, read and write
--Create user from input
--Buttons
--Transparency not working


-- These three functions below are required for running tests on this file
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
local text = chooseText()
--print("inReg")
local gfx =  chooseGfx()
local lastForm = ...
--local account = ...

--Position variables
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9
local startPosY = yUnit*2.5
local startPosX = 6*xUnit
local startPosXText = startPosX*1.01
local startPosYText = startPosY*0.97
local highlightPosY = 1
local marginY = yUnit*0.7
local upperBoundary = 6
local lowerBoundary = 1
local errorCounter = 0

local emptyTextFields = {}
local invalidFields = {}
local inputFieldTable = {}
inputFieldTable[1] = "name"
inputFieldTable[2] = "address"
inputFieldTable[3] = "zipCode"
inputFieldTable[4] = "city"
inputFieldTable[5] = "phone"
inputFieldTable[6] = "email"
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

local background = gfx.loadpng("Images/UserRegistrationPics/background.png")
local highlight = gfx.loadpng("Images/UserRegistrationPics/highlighter.png")

function checkForm()
	newForm.currentInputField = "name"
	if type(lastForm) == "string" then
	else
		if lastForm then
				newForm = lastForm
		end
	end
end

function checkEditMode()
	if(newForm.editMode == "true")then
		newForm.laststate = "RegistrationStep1.lua"
	end
end
--Calls methods that builds GUI
function buildGUI()
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
displayFormData()
displayHighlighter()
displayErrorData()
end

function displayErrorData()
	local counter = 0
	if (#emptyTextFields) == 0 then
		--Nothing
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


function displayHighlighter()
  gfx.screen:copyfrom(highlight, nil, {x = startPosX,  y= startPosY + (highlightPosY - 1) * marginY, w = xUnit * 8, h =yUnit*0.5})
end

--Creates inputsurface and displays "highlighted" input
function displayFormData()
	--print("print")
	text.print(gfx.screen,"lato","black","medium", tostring(newForm.name),startPosXText,startPosYText, 500, 500)
	text.print(gfx.screen,"lato","black","medium", tostring(newForm.address),startPosXText,startPosYText+marginY,500,500)
	text.print(gfx.screen,"lato","black","medium", tostring(newForm.zipCode),startPosXText,startPosYText+marginY*2,500,500)
	text.print(gfx.screen,"lato","black","medium", tostring(newForm.city),startPosXText,startPosYText+marginY*3,500, 500)
	text.print(gfx.screen,"lato","black","medium", tostring(newForm.phone),startPosXText,startPosYText+marginY*4,500, 500)
	text.print(gfx.screen,"lato","black","medium", tostring(newForm.email),startPosXText,startPosYText+marginY*5,500, 500)
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
      highlightPosY = lowerBoundary
    end
end
newForm.currentInputField = inputFieldTable[highlightPosY]
end

function updateScreen()
	buildGUI()
	gfx.update()
end

function onKey(key,state)
	if(state == 'up') then
		--print(key)
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
			pathName = "Keyboard.lua"
			if checkTestMode() then
			 	return pathName
			else
				--print(newForm.laststate)
				assert(loadfile(pathName))(newForm)
			end
	  	elseif(key == 'green') then
	  		--Go Back to menu
	  		pathName = "Menu.lua"
	  		if checkTestMode() then
	  			return pathName
	  		else
	  			assert(loadfile(pathName))(newForm)
	  		end
	  	elseif(key == 'blue') then
	  		pathName = "RegistrationStep2.lua"
	  		if checkTestMode() then
	  			return pathName
	  		end
	  		-- Next Step
	  		emptyFormValidation(newForm)
	  		if ((#emptyTextFields) == 0) and (errorCounter == 0) then
	  			assert(loadfile(pathName))(newForm)
	  		else
	  			--Nothing
	  		end
	  	else
	  		--More options for buttonpress?
	  		--Test cases needs to be written if more options for onKey is added
	  	end
	  	updateScreen()
	end
end

function emptyFormValidation(form)
	emptyTextFields = {}

	--Checks if a textfield is empty
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

function invalidFormValidation(form)
	invalidFields = {}
	errorCounter = 0
	--for k,v in pairs(emptyTextFields) do print(k,v) end
	--Checks if zipcode is 5 digits (Swedish standard)
	if (not string.match(form.zipCode, '^%d%d%d%d%d^') and string.len(form.zipCode) ~= 0) then
		invalidFields["zipCode"] = "Incorrect zip-code, write five digits(no spaces)"
		errorCounter = errorCounter + 1
	else
		
	end
	--Checks if phone number is 10 digits (Swedish standard)
	if (not string.match(form.phone, '^%d%d%d%d%d%d%d%d%d%d^') and  string.len(form.phone) ~= 0) then
		invalidFields["phone"] = "Incorrect phone number, write ten digits(no spaces)"
		errorCounter = errorCounter + 1
	else
		
	end
	--Checks if the input email is valid
	if (not string.match(form.email, '[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?') and  string.len(form.email) ~= 0) then
		invalidFields["email"] = "Incorrect email, use valid characters"
		errorCounter = errorCounter + 1
		
	else
		
	end
	--for k,v in pairs(invalidFields) do print(k,v) end

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

-- Function that returns the errorforms so that they can be used in testing
function returnForms(String)
	if String == "invalidFields" then
		return invalidFields
	elseif String == "emptyTextFields" then
		return emptyTextFields
	end
end


--Main method
function main()
	checkForm()
	checkEditMode()
	updateScreen()
	newForm.currentInputField = "name"
	invalidFormValidation(newForm)
end
main()





