local onBox = true
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
    underGoingTest = false
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

if onBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/PizzaPics/?.png'
  dir = sys.root_path()

else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
end

local text = chooseText()

local io = require "IOHandler"


local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9
local marginY = yUnit * 0.05

local startPosY = yUnit * 2.3
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
local lastPage = currentPage


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
displayPizzas()
displayArrows()
displayChoiceMenu()
displayHighlightSurface()
end

function updateScreen()
	buildGUI()
	gfx.update()
end

function displayBackground()
	local backgroundPNG = gfx.loadpng("Images/PizzaPics/background.png")
	backgroundPNG:premultiply()
	gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
	backgroundPNG:destroy()
end

function getPizzas()
	if not checkTestMode() then -- Something about currentPizzeria doesnt work when running busted. Johan will fix it when reworking the io system
		currentPizzeria = newForm.pizzeria
	end
end

function getNoOfPages()	
  print(#currentPizzeria.pizzas)
  noOfPages = math.ceil(#currentPizzeria.pizzas/6)
  print(noOfPages)

end

function changeCurrentPage(key)
  if(key == 'left')then
    if(currentPage > 1)then
      currentPage = currentPage -1
      startingIndex = startingIndex-6
    end
  elseif (key == 'right')then
    if(currentPage < noOfPages)then
      currentPage=currentPage+1
      startingIndex = startingIndex+6
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
		local ySpace = 0.75 * yUnit
		local pos = 1
		local tilePNG = gfx.loadpng("Images/PizzaPics/inputfield.png")
		tilePNG:premultiply()
		upperBoundary = 0
		text.print(gfx.screen,"lato","black","small",tostring("Page: "..currentPage.."/"..noOfPages), startPosX*3.3, yUnit*7.1, xUnit*7, yUnit)
		for index = startingIndex, #currentPizzeria.pizzas do
			gfx.screen:copyfrom(tilePNG, nil, {x =pizzaPosX, y =pizzaPosY + (pos-1) * marginY, w=xUnit*7 , h=ySpace},true)
			text.print(gfx.screen, "lato","black","medium", currentPizzeria.pizzas[index].name, pizzaPosX*1.04, (pizzaPosY*0.99)+ (pos-1) * marginY, xUnit*5, ySpace)
			text.print(gfx.screen, "lato","black","medium", tostring(currentPizzeria.pizzas[index].price) .. "kr", pizzaPosX + 5.96 * xUnit, (pizzaPosY*0.99) + (pos-1) * marginY, 2 * xUnit, ySpace)
			local pizzaIngredients = ""
            for i = 1, #currentPizzeria.pizzas[index].ingredients do
             	pizzaIngredients = pizzaIngredients..tostring(currentPizzeria.pizzas[index].ingredients[i])..", "
	        end
	        ingredientsText = 0.45*yUnit
	       	text.print(gfx.screen, "lato","black","small", pizzaIngredients, pizzaPosX*1.05 ,pizzaPosY + (pos-1) * marginY+(0.45*yUnit), 5 * xUnit, ySpace)
	        pizzaPosY = pizzaPosY + ySpace
	        upperBoundary = upperBoundary+1	                        
	        pos = pos +1
			if(index == startingIndex+5)then 
				break
			end
		end
		tilePNG:destroy()
	end
end

function displayArrows()
  --Bilder
  if(noOfPages > 1 and currentPage < noOfPages)then
      local rightArrow = gfx.loadpng("Images/PizzaPics/rightarrow.png")
      rightArrow:premultiply()
      gfx.screen:copyfrom(rightArrow, nil, {x = xUnit*11, y= yUnit*4, w = xUnit*1 , h =yUnit*2},true)
      rightArrow:destroy()
  end
  if(currentPage > 1)then
    local leftArrow = gfx.loadpng("Images/PizzaPics/leftarrow.png")
    leftArrow:premultiply()
    gfx.screen:copyfrom(leftArrow, nil, {x = xUnit*1.5, y= yUnit*4, w = xUnit*1 , h =yUnit*2},true)
    leftArrow:destroy()
  end
end

local tempCopy = nil
local tempCoord = {}

function displayHighlightSurface()
	local highligtherPNG = nil
	
	local coord = {x = startPosX, y = startPosY +(highlightPosY-1) * (yUnit *0.75 + marginY), w = 9.3 * xUnit, h =0.75*yUnit}
	
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

	if isAlreadyPicked(getPizzaOnCoordinate(highlightPosY)) then
		highligtherPNG = gfx.loadpng("Images/PizzaPics/deleteHighlighter.png")
		highligtherPNG:premultiply()
		gfx.screen:copyfrom(highligtherPNG, nil , coord,true)
	else
		highligtherPNG = gfx.loadpng("Images/PizzaPics/highlighter.png")
		highligtherPNG:premultiply()
		gfx.screen:copyfrom(highligtherPNG, nil , coord,true)
	end
		highligtherPNG:destroy()
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
	newForm.pizzeria.userPizzas = pizzaTable
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

function destroyTempSurfaces()
	tempCopy:destroy()
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
	displayHighlightSurface()
	gfx.update()
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
	  		pathName = dir.."RegistrationStep2.lua"
	  		if checkTestMode() then
			 	return pathName
			else

				destroyTempSurfaces()
	  			assert(loadfile(pathName))(newForm)
	  		end
	  	elseif(key == 'blue') then
	  		if checkTestMode() then
	  			-- Nothing
	  		else
	  			pizzaIsChoosen()
	  		end
	  		if isChosen then
	  			pathName = dir.."RegistrationReview.lua"
	  			if checkTestMode() then
			 		return pathName
				else
	  				insertOnTable(pizza)
	  				destroyTempSurfaces()
	  				assert(loadfile(pathName))(newForm)
	  			end
	  		else
	  			if checkTestMode() then
	  				return "Need to choose pizza"
	  			else
	  				text.print(gfx.screen,"lato","black","medium", "You need to choose at least one pizza!", xUnit*3, yUnit*6.5, xUnit*10, yUnit)
	  			end
	  		end
	  		elseif key =='green' then
	  			pathName = dir.."Menu.lua"
	  			if checkTestMode() then
			 		return pathName
				else
					destroyTempSurfaces()
	  				
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
	  		updateScreen() -- can still be optimized

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
function onStart()
	checkForm()
	getPizzas()
	updateScreen()
end
onStart()





