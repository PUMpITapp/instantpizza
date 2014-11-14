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

local text = chooseText(checkTestMode())
local gfx =  chooseGfx(checkTestMode())
local io = require "IOHandler"


local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9
local margin = yUnit * 0.05

local pizzaFieldY = yUnit * 2.5
local pizzaFieldX = xUnit * 3

local highlightPosX = 1
local highlightPosY = 1

local showLimit = 8
local maxChoices = 4
local choices = 0
local noOfPizzas = 0

local highligtherPNG = gfx.loadpng("Images/PizzaPics/highlighter.png")
local backgroundPNG = gfx.loadpng("Images/PizzaPics/background.png")
local tilePNG = gfx.loadpng("Images/PizzaPics/inputfield.png")

local pizzaSurface = gfx.new_surface(10 * xUnit, 4 * yUnit)
local backgroundSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())

-- local lastForm = ...
local newForm = {}

local isChosen = false
local pizzaMenu = {}
local pizza = {}

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
--Calls methods that builds GUI
function updateScreen()
displayBackground()
displayHighlightSurface()
displayPizzas()
displayChoiceMenu()
gfx.update()
end

function displayBackground()
	backgroundSurface:clear()
	backgroundSurface:copyfrom(backgroundPNG)

	gfx.screen:copyfrom(backgroundSurface)
end
function getPizzas()
	if not checkTestMode() then -- Something about currentPizzeria doesnt work when running busted. Johan will fix it when reworking the io system
		currentPizzeria = newForm.pizzeria
		--currentPizzeria.pizzas = io.readPizzas(currentPizzeria.id)
	end
end

--Creates new surface and display pizzas
function displayPizzas()
	if not checkTestMode() then -- Something about currentPizzeria doesnt work when running busted. Johan will fix it when reworking the io system
		local pizzaPosX = pizzaFieldX
		local pizzaPosY = pizzaFieldY
		local ySpace = 0.5 * yUnit
		pizzaSurface:clear()
		for i,v in ipairs(currentPizzeria.pizzas) do
			gfx.screen:copyfrom(tilePNG, nil, {x =pizzaPosX, y =pizzaPosY + (i-1) * margin, w=xUnit*7 , h=ySpace})
			text.print(gfx.screen, arial, currentPizzeria.pizzas[i].name, pizzaPosX, pizzaPosY+ (i-1) * margin, xUnit*5, ySpace)
			text.print(gfx.screen, arial, tostring(currentPizzeria.pizzas[i].price) .. "kr", pizzaPosX + 6 * xUnit, pizzaPosY + (i-1) * margin, 2 * xUnit, ySpace)
			pizzaPosY = pizzaPosY + ySpace
			noOfPizzas = i
			if(i == showLimit)then 
				break
			end
		end
	end
end

function displayHighlightSurface()
	local pos = {x = pizzaFieldX + (highlightPosX -1)*xUnit, y = pizzaFieldY +(highlightPosY-1) * (yUnit *0.5 + margin), w = 9 * xUnit, h =0.5*yUnit}
	gfx.screen:copyfrom(highligtherPNG, nil , pos )
end

function getPizzaOnCoordinate(posY)

	return currentPizzeria.pizzas[posY]
end


function insertOnChoiceMenu(myPizza)
	isChosen = true
	if(choices < maxChoices) then
	choices = choices + 1
	pizza[choices] = myPizza
	end
	
end

function insertOnTable(pizzaTable)
	newForm.pizzeria["pizza"] = pizzaTable
	-- local i = 0
	-- for key, value in pairs(pizzaTable) do
	-- 	i = i + 1
	-- 	pos = "pizza"..i
	-- 	newForm[pos] = value.name
	-- end
end

function deleteOnChoiceMenu(myPizza)
	if pizza[myPizza.name] then
		choices = choices - 1
		pizza[myPizza.name] = nil
	end
end

function displayChoiceMenu()
	local x = 13 * xUnit
	local y = 1.5 * yUnit
	local menuItems = 0
	for k, v in pairs(pizza) do
	text.print(gfx.screen, arial, v.name, x, y + 0.5*menuItems*yUnit, pizzaCellX, pizzaCellY)
	menuItems = menuItems + 1
	end
end

--Moves the current inputField
function moveHighlight(key)

	--Up
	if(key == 'Up')then
		highlightPosY = highlightPosY - 1
		if(highlightPosY < 1) then
			highlightPosY = highlightPosY +1
		end
	--Down
	elseif(key == 'Down')then
		highlightPosY = highlightPosY + 1
		if(highlightPosY > noOfPizzas) then
			highlightPosY = highlightPosY -1
		end
	--Left
	elseif(key == 'Left')then
		
	--Right
	elseif(key == 'Right') then
		
	end
end

function onKey(key,state)
	--TODO
	if(state == 'up') then
	  	if(key == 'Up') then
	  		--Up
	  		moveHighlight(key)
	  		updateScreen()
	  		
	  	elseif(key == 'Down') then
	  		--Down
	  		moveHighlight(key)
	  		updateScreen()
	  		--Left
	  	elseif(key == 'Left') then
	  		moveHighlight(key)
	  		updateScreen()
	  		--Right
	  	elseif(key == 'Right') then
	  		moveHighlight(key)
			updateScreen()
	  	elseif(key == 'red') then
	  		-- insertOnTable(pizza)
	  		assert(loadfile("RegistrationStep2.lua"))(newForm)
	  	elseif(key == 'blue') then
	  		if isChosen then
	  			insertOnTable(pizza)
	  			assert(loadfile("RegistrationReview.lua"))(newForm)
	  		else
	  			text.print(gfx.screen, arial, "You need to choose at least one pizza!", xUnit*3, yUnit*6.5, xUnit*10, yUnit)
	  		end
	  	elseif(key == 'Return') then
	  		local choosenPizza = getPizzaOnCoordinate(highlightPosY)
	  		insertOnChoiceMenu(choosenPizza)
	  		updateScreen()
	  	elseif(key == 'Delete') then
	  		deleteOnChoiceMenu(getPizzaOnCoordinate(highlightPosY))
	  		updateScreen()
	  	end
	end
	gfx.update()
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
	getPizzas()
	updateScreen(q)
end
main()





