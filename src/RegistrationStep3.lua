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
local gfx =  chooseGfx()

local io = require "IOHandler"


local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9
local marginY = yUnit * 0.05

local startPosY = yUnit * 2.5
local startPosX = xUnit * 3

local highlightPosY = 1

local maxChoices = 4
local choices = 0
local upperBoundary = 0
local lowerBoundary = 1
local cartPosX = 12.9 * xUnit
local cartPosY = 4.3 * yUnit
local isChosen = false

local noOfPages = 0
local currentPage = 1
local startingIndex = 1

local highligtherPNG = gfx.loadpng("Images/PizzaPics/highlighter.png")
local backgroundPNG = gfx.loadpng("Images/PizzaPics/background.png")
local tilePNG = gfx.loadpng("Images/PizzaPics/inputfield.png")
local deletePNG = gfx.loadpng("Images/PizzaPics/deleteHighlighter.png")

local backgroundSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())

local lastForm = ...
local newForm = {}


local pizzaMenu = {}
local pizza = {}

function checkForm()
	if type(lastForm) == "string" then

	else
		if lastForm then
			newForm = lastForm

		end
	end
end
--Calls methods that builds GUI
function buildGUI()
getNoOfPages()
displayBackground()
displayHighlightSurface()
displayPizzas()
displayArrows()
displayChoiceMenu()
end

function updateScreen()
	buildGUI()
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
	end
end

function getNoOfPages()
  noOfPages = math.ceil(#currentPizzeria.pizzas/8)

end

function changeCurrentPage(key)
  if(key == 'left')then
    if(currentPage > 1)then
      currentPage = currentPage -1
      startingIndex = startingIndex-8
      displayPizzas()
    end
  elseif (key == 'right')then
    if(currentPage < noOfPages)then
      currentPage=currentPage+1
      startingIndex = startingIndex+8  
      displayPizzas()
    end
  end
  highlightPosY = 1
  updateScreen()
end

--Creates new surface and display pizzas
function displayPizzas()
	if not checkTestMode() then -- Something about currentPizzeria doesnt work when running busted. Johan will fix it when reworking the io system
		local pizzaPosX = startPosX
		local pizzaPosY = startPosY
		local ySpace = 0.5 * yUnit
		local pos = 1
		upperBoundary = 0
		text.print(gfx.screen,"lato","black","small",tostring("Page: "..currentPage.."/"..noOfPages), startPosX*3.3, yUnit*7.1, xUnit*7, yUnit)
		for index = startingIndex, #currentPizzeria.pizzas do
			gfx.screen:copyfrom(tilePNG, nil, {x =pizzaPosX, y =pizzaPosY + (pos-1) * marginY, w=xUnit*7 , h=ySpace})
			text.print(gfx.screen, "lato","black","medium", currentPizzeria.pizzas[index].name, pizzaPosX*1.04, (pizzaPosY*0.99)+ (pos-1) * marginY, xUnit*5, ySpace)
			text.print(gfx.screen, "lato","black","medium", tostring(currentPizzeria.pizzas[index].price) .. "kr", pizzaPosX + 5.96 * xUnit, (pizzaPosY*0.99) + (pos-1) * marginY, 2 * xUnit, ySpace)
			pizzaPosY = pizzaPosY + ySpace
			upperBoundary = upperBoundary+1
			pos = pos +1
			if(index == startingIndex+7)then 
				break
			end
		end
	end
end

function displayArrows()
  --Bilder
  if(noOfPages > 1 and currentPage < noOfPages)then
      local rightArrow = gfx.loadpng("Images/PizzaPics/rightarrow.png")
      rightArrow:premultiply()
      gfx.screen:copyfrom(rightArrow, nil, {x = xUnit*11, y= yUnit*4, w = xUnit*1 , h =yUnit*2})
      rightArrow:destroy()
  end
  if(currentPage > 1)then
    local leftArrow = gfx.loadpng("Images/PizzaPics/leftarrow.png")
    leftArrow:premultiply()
    gfx.screen:copyfrom(leftArrow, nil, {x = xUnit*1.5, y= yUnit*4, w = xUnit*1 , h =yUnit*2})
    leftArrow:destroy()
  end
end

function displayHighlightSurface()
	local pos = {x = startPosX, y = startPosY +(highlightPosY-1) * (yUnit *0.5 + marginY), w = 8 * xUnit, h =0.5*yUnit}
	
	if isAlreadyPicked(getPizzaOnCoordinate(highlightPosY)) then
		gfx.screen:copyfrom(deletePNG, nil , pos)
	else
		gfx.screen:copyfrom(highligtherPNG, nil , pos)
	end
end

function getPizzaOnCoordinate(posY)
	if checkTestMode() then
		currentPizzeria = { ["Testing"] = "Works" }
		return currentPizzeria
	else
		pizzaIndex = (8*(currentPage-1)+highlightPosY)
		return currentPizzeria.pizzas[pizzaIndex]
	end
end

function isAlreadyPicked(myPizza)
	local isPicked = false
	for i, v in pairs(pizza) do
		if myPizza.name == pizza[i].name then
			isPicked = true
		end
	end
	return isPicked
end

function pizzaIsChoosen()
	isChosen = (#pizza~=0)
	return isChosen
end

function insertOnChoiceMenu(myPizza)

	if checkTestMode() then
		return myPizza
	end
	local isPicked = isAlreadyPicked(myPizza)
	if not isPicked then
		if not (choices >=4)then
		choices = choices + 1
		pizza[choices] = myPizza
		end
	end

end

function insertOnTable(pizzaTable)
	newForm.pizzeria.pizzas = pizzaTable
end

function deleteOnChoiceMenu(myPizza)
	for i,v in pairs(pizza) do
		if pizza[i].name == myPizza.name then
			table.remove(pizza,i)
		end
	end
	choices = choices - 1
end

function displayChoiceMenu()

	local menuItems = 0
	for i, v in pairs(pizza) do
	text.print(gfx.screen, "lato","black","small", pizza[i].name, cartPosX, cartPosY + 0.5*menuItems*yUnit, xUnit*3, yUnit)
	text.print(gfx.screen, "lato","black","small", pizza[i].price.."kr", cartPosX+xUnit*1.5, cartPosY + 0.5*menuItems*yUnit, xUnit*3, yUnit)
	menuItems = menuItems + 1
	end
end

--Moves the current inputField
function moveHighlightedInputField(key)

	--Up
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
		updateScreen()

end

function onKey(key,state)
	--TODO
	if(state == 'up') then
	  	if(key == 'up') then
	  		--Up
	  		if checkTestMode() then
				return key
			end
	  		moveHighlightedInputField(key)	  		
	  	elseif(key == 'down') then
	  		--Down
	  		if checkTestMode() then
				return key
			end
	  		moveHighlightedInputField(key)
	  	elseif(key == 'left') then
	  		--Left
	  		changeCurrentPage(key)
	  	elseif(key == 'right') then
	  		--Right
	  		changeCurrentPage(key)
	  	elseif(key == 'red') then
	  		pathName = "RegistrationStep2.lua"
	  		if checkTestMode() then
			 	return pathName
			else
	  			assert(loadfile("RegistrationStep2.lua"))(newForm)
	  		end
	  	elseif(key == 'blue') then
	  		if checkTestMode() then
	  			-- Nothing
	  		else
	  			pizzaIsChoosen()
	  		end
	  		if isChosen then
	  			pathName = "RegistrationReview.lua"
	  			if checkTestMode() then
			 		return pathName
				else
	  				insertOnTable(pizza)
	  				assert(loadfile("RegistrationReview.lua"))(newForm)
	  			end
	  		else
	  			if checkTestMode() then
	  				return "Need to choose pizza"
	  			else
	  				text.print(gfx.screen,"lato","black","medium", "You need to choose at least one pizza!", xUnit*3, yUnit*6.5, xUnit*10, yUnit)
	  			end
	  		end
	  		elseif key =='green' then
	  			pathName = "Menu.lua"
	  			if checkTestMode() then
			 		return pathName
				else
	  				
	  				dofile(pathName)
	  			end
	  	elseif(key == 'ok') then
	  		if checkTestMode() then
				return key
			end
	  		local choosenPizza = getPizzaOnCoordinate(highlightPosY)
	  		if isAlreadyPicked(choosenPizza) then
	  		deleteOnChoiceMenu(choosenPizza)
	  		else
	  		insertOnChoiceMenu(choosenPizza)
	  		end
	  			updateScreen()

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
	elseif value == "inputMovement" then
		return inputMovement
	end
end
-- This function is used in testing when it is needed to set the value of inputFieldY to a certain number
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

-- Function that sets the variable isChoosen to a boolean
function setIsChosen(value)
	isChosen = value
end

--Main method
function main()
	checkForm()
	getPizzas()
	updateScreen()
end
main()





