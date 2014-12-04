--- Set if the program is running on the box or not
local onBox = true

--- Checks if the file was called from a test file.
-- @return true if called from a test file, indicating the file is being tested, else false  
function checkTestMode()
  runFile = debug.getinfo(2, "S").source:sub(2,3)
  if (runFile ~= './' ) then
    underGoingTest = false
  elseif (runFile == './') then
    underGoingTest = false
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
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/PizzaPics/?.png'
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
local startPosY = yUnit * 2.3
local startPosX = xUnit * 3

--- Define the starting position of the highlight input field and the space between fields
local highlightPosY = 1
local marginY = yUnit * 0.05

--- Declare the boundary levels for the input field set
local upperBoundary = 0
local lowerBoundary = 1

--- Define the starting position of the shopping cart
local cartPosX = 12.9 * xUnit
local cartPosY = 4.3 * yUnit


--- Determine if a pizza has been chosen and the lower and upper limit of choices
local isChosen = false
local maxChoices = 4
local choices = 0

--- Page counter variables to display a varying number of pizza pages depending on the number of pizzas
local noOfPages = 0
local currentPage = 1
local startingIndex = 1
local lastPage = currentPage

--- Variable to determine the maximum number of pizzas per page
local pizzasPerPage = 6

--- Variables to save the content of a certain field to display it again after highlighted
--- Used for memory optimization
local tempCopy = nil
local tempCoord = {}

--- Handle table form from last step and initiate a new table form for this step
local lastForm = ...
local newForm = {}

--- Pizza tables
local pizza = {}
local pizzaMenu = {}

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

--- Function that builds the GUI
function buildGUI()
getNoOfPages()
displayBackground()
displayPizzas()
displayArrows()
displayChoiceMenu()
displayHighlightSurface()
end

--- Function that that updates the current screen to be able to show new or changed information to the user
function updateScreen()
	buildGUI()
	gfx.update()
end

--- Function that displays the Background image of the application
function displayBackground()
	local backgroundPNG = gfx.loadpng("Images/PizzaPics/background.png")
	backgroundPNG:premultiply()
	gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
	backgroundPNG:destroy()
end

--- Function that fetches the pizzeria chosen by the user
function getPizzas()
	-- The call on the newForm table cannot be done in test mode
	if not checkTestMode() then
		currentPizzeria = newForm.pizzeria
	end
end

--- Function that determines total number of pages with pizzas
function getNoOfPages()	
  noOfPages = math.ceil(#currentPizzeria.pizzas/pizzasPerPage)
end

--- Changes to the next or previous page of pizzerias to display
-- @param key The key that has been pressed
function changeCurrentPage(key)
  if(key == 'left')then
    if(currentPage > 1)then
      currentPage = currentPage -1
      startingIndex = startingIndex-pizzasPerPage
    end
  elseif (key == 'right')then
    if(currentPage < noOfPages)then
      currentPage=currentPage+1
      startingIndex = startingIndex+pizzasPerPage
    end
  end
  highlightPosY = 1
  updateScreen()
end

--- Display pizzas in the input field
function displayPizzas()
	-- The call on the currentPizzeria table cannot be done in test mode
	if not checkTestMode() then
		local pizzaPosX = startPosX
		local pizzaPosY = startPosY
		local ySpace = 0.75 * yUnit
		local pos = 1
		local tilePNG = gfx.loadpng("Images/PizzaPics/inputfield.png")
		tilePNG:premultiply()
		upperBoundary = 0
		text.print(gfx.screen,"lato","black","small",tostring("Page: "..currentPage.."/"..noOfPages), startPosX*3.3, yUnit*7.1, xUnit*7, yUnit)
		-- Loops through all pizzas that shall be displayed
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
			-- Stop displaying when the maximum number of pizzas is shown
			if(index == startingIndex+5)then 
				break
			end
		end
		tilePNG:destroy()
	end
end

--- Function that determines which arrows that shall be shown depending on the current page of pizzeras
function displayArrows()
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

--- Displays the highlighter that highlights different choices
function displayHighlightSurface()
	local highligtherPNG = nil
	local coord = {x = startPosX, y = startPosY +(highlightPosY-1) * (yUnit *0.75 + marginY), w = 9 * xUnit, h =0.75*yUnit}
	
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
    -- The if statement below changes what highlighter to show depending on if a pizza already is chosen or not
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

--- Function fetches chosen pizza with help from the coordinates on the screen
-- @Param highlightPosY Checks what the current position of the highlighter is
-- @return currentPizzeria Returns what pizza that corresponds to the current coordinates
function getPizzaOnCoordinate(highlightPosY)
	if checkTestMode() then
		currentPizzeria = { ["Testing"] = "Works" }
		return currentPizzeria
	else
		pizzaIndex = (pizzasPerPage*(currentPage-1)+highlightPosY)
		return currentPizzeria.pizzas[pizzaIndex]
	end
end

--- Function checks if a pizza already has been chosen by the user or not
-- @param myPizza The pizza menu customized by the user in this step
-- @return isPicked Returns if pizza already chosen or not
function isAlreadyPicked(myPizza)
	local isPicked = false
	for i, v in pairs(pizza) do
		if myPizza.name == pizza[i].name then
			isPicked = true
		end
	end
	return isPicked
end

--- Function checks if a pizza has been chosen by the user of not
-- @return isChosen Returns if chosen or not
function pizzaIsChoosen()
	isChosen = (#pizza~=0)
	return isChosen
end

--- Function adds a pizza that is chosen by the user from the user pizza menu
-- @param pizzaTable Stores the pizzas chosen in this step
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

--- Function copies the content of the pizza table in current step to the user's account
-- @param pizzaTable Stores the pizzas chosen in this step
function insertOnTable(pizzaTable)
	newForm.pizzeria.userPizzas = pizzaTable
end

--- Function deletes a pizza that is chosen by the user from the user pizza menu
-- @param myPizza Used to compare current highlighted pizza with the complete pizza menu
function deleteOnChoiceMenu(myPizza)
	for i,v in pairs(pizza) do
		if pizza[i].name == myPizza.name then
			table.remove(pizza,i)
		end
	end
	choices = choices - 1
end

--- Displays the pizza(s) chosen by the user in the cart
function displayChoiceMenu()
	local menuItems = 0
	for i, v in pairs(pizza) do
	text.print(gfx.screen, "lato","black","small", pizza[i].name, cartPosX, cartPosY + 0.5*menuItems*yUnit, xUnit*3, yUnit)
	text.print(gfx.screen, "lato","black","small", pizza[i].price.."kr", cartPosX+xUnit*1.5, cartPosY + 0.5*menuItems*yUnit, xUnit*3, yUnit)
	menuItems = menuItems + 1
	end
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
	displayHighlightSurface()
	gfx.update()
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
	  		changeCurrentPage(key)
	  	elseif(key == 'right') then
	  		changeCurrentPage(key)
	  	elseif(key == 'red') then
	  		pathName = dir.."RegistrationStep2.lua"
	  		if checkTestMode() then
			 	return pathName
			else
				-- Go back to previous step including current form
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
	  				-- Go to next step including current form
	  				assert(loadfile(pathName))(newForm)
	  			end
	  		else
	  			if checkTestMode() then
	  				return "Need to choose pizza"
	  			else
	  				text.print(gfx.screen,"lato","black","small", "You need to choose at least one pizza!", xUnit*3, yUnit*7.1, xUnit*10, yUnit)
	  				gfx.update()
	  			end
	  		end
	  		elseif key =='green' then
	  			-- Go back to menu
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
			-- Add pizza if not already chosen, delete if chosen
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

--- CreateFormsForTest creates a customized newForm and lastFrom to test the functionality of the function checkFrom()
-- @param String Sets expected status from the testing function
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

--- This function is used in testing when it is needed to set the value of inputFieldY to a certain number
-- @param value Sets highlight position value in vertical direction
function setValuesForTesting(value)
	highlightPosY = value
end

--- Function that returns the newForm variable so that it can be used in testing
-- @return newForm Returns the form used in this step
function returnNewForm()
	return newForm
end

--- Function that returns the lastForm variable so that it can be used in testing
-- @return lastForm Returns the form used in another step
function returnLastForm()
	return lastForm
end

--- Function that sets the variable isChoosen to a boolean
-- @param vale Sets if a pizza is chosen or not
function setIsChosen(value)
	isChosen = value
end

--- Main method
function onStart()
	checkForm()
	getPizzas()
	updateScreen()
end
onStart()