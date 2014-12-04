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
--- Change the path system if the app runs on the box comparing to the emulator
if onBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/OrderPics/?.png'
  dir = sys.root_path()
else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
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
--- Variable to use when displaying printed text on the screen
local text = chooseText()

--- Declare units in variables
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

---Highlight positions x and y
local highlightPosX = 1
local highlightPosY = 1

---
local column = 1
local row = 1

---Startposition on screen x and y.
local startPosX = 1*xUnit
local startPosY = 2.5 * yUnit

---Start position for highlightfield y position
local startHighlightY = startPosY

---Startposition for drinks, y and x position
local startDrinksY = startPosY
local startDrinksX = 6 * startPosX

---Startposition for sauces, y and x position
local startSauceY = 5.5 * yUnit
local startSauceX = startPosX

---Startposition for salads, y and x position
local startSaladY = 6.1 * yUnit
local startSaladX = 6 * startPosX

---Input movement x and y positions
local marginX = 5*xUnit
local marginY = 0.6*yUnit

---Width and height for the fields
local fieldWith = 3.5 * xUnit
local fieldHeight = 0.5 * yUnit

---Movement boundaries
local lowerBoundary = 1
local middleBoundary = 1
local upperBoundary = 1

---Temp save background
local tempCopy = nil
local tempCoord = {}

---Account from previous step
local account = ...
---editOrder gets values if user goes back to this step from OrderStep3
local editOrder = ...
---Creates a new order table from the account passed on from OrderStep1
local newOrder = {
	name = account.name,
	address = account.address,
	phone = account.phone,
	zipCode = account.zipCode,
  email = account.email,
  pizzeria = account.pizzeria,
	totalPrice = 0
}
---Table containing the users order
local order = {
  pizzas = {},
  sauces = {},
  drinks = {},
  salads = {}
}
---Table containing the pizzerias menu
local menu = {
  pizzas = {},
  drinks = {},
  sauces = {},
  salads = {}
}

---Table that references menu and order
local refToMenu = {}
local refToOrder = {}

--- Variable to use when handling tables that are stored in the system
local io = require "IOHandler"

---Calls methods that builds GUI
function updateScreen()
  displayBackground()
  displayMenu()
  displayCart()
  displayHighlighter()
  gfx.update()
end

---Function that displays the background
function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/OrderPics/orderstep2.png") 
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=16*xUnit, h=9*yUnit})
  backgroundPNG:destroy()
end

---Used to create an order when user presses confirm
function createOrder()
  newOrder["order"] = refToOrder
end

---Checks if there is a existing order. Only not nil if user goes back from OrderStep3 to this step. 
function checkExistingOrder()
  if not (editOrder.order == nil)then
    refToOrder[1] = editOrder.order[1]
    refToOrder[2] = editOrder.order[2]
    refToOrder[3] = editOrder.order[3]
    refToOrder[4] = editOrder.order[4]
    newOrder.totalPrice = editOrder.totalPrice
  end
end

---Function that creates the menu and sets references to refToOrder and refToMenu.
function createMenu()
  if checkTestMode() then
  else
    menu.pizzas = account.pizzeria.pizzas -- array with numbers

    menu.drinks[1] = {name = "Sprite", price = "10"}
    menu.drinks[2] = {name = "Coke", price = "10"}
    menu.drinks[3] = {name = "Beer", price = "10"}
    menu.drinks[4] = {name = "Fanta", price = "10"}
    menu.drinks[5] = {name = "Loka", price = "10"}

    menu.sauces[1] = {name = "Mild sauce", price = "5"}
    menu.sauces[2] = {name = "Mixed sauce", price = "5"}
    menu.sauces[3] = {name = "Hot sauce", price = "5"}

    menu.salads[1] = {name = "Pizza salad", price = "10"}
  --menu.salads[2] = {name = "pizzasalad", price = "10"}

    refToMenu[1] = menu.pizzas
    refToMenu[2] = menu.drinks
    refToMenu[3] = menu.sauces
    refToMenu[4] = menu.salads

    refToOrder[1] = order.pizzas
    refToOrder[2] = order.drinks
    refToOrder[3] = order.sauces
    refToOrder[4] = order.salads
  end
end
---Prints menu and tiles to screen
function displayMenu()
  local tilePNG = gfx.loadpng("Images/OrderPics/ordertile.png")
  tilePNG:premultiply()


  for i =1,#menu.pizzas do
  	gfx.screen:copyfrom(tilePNG, nil, {x = startPosX, y= startPosY+  (i-1)* marginY, w = fieldWith, h = fieldHeight},true)   
    text.print(gfx.screen,"lato","black","small", menu.pizzas[i].name,startPosX+(xUnit*0.1), startPosY+(yUnit*0.1)+ (i-1) * marginY, fieldWith, fieldHeight)
    text.print(gfx.screen,"lato","black","small", menu.pizzas[i].price.."kr", startPosX+(xUnit*2.94), startPosY+(yUnit*0.1)+ (i-1) * marginY, fieldWith, fieldHeight)

  end

  for i =1,#menu.drinks do
    gfx.screen:copyfrom(tilePNG, nil, {x = startDrinksX, y= startDrinksY+ (i-1)* marginY , w = fieldWith, h = fieldHeight},true)   
    text.print(gfx.screen,"lato","black","small", menu.drinks[i].name, startDrinksX+(xUnit*0.1), startDrinksY+(yUnit*0.1)+ (i-1) * marginY, fieldWith, fieldHeight)
    text.print(gfx.screen,"lato","black","small", menu.drinks[i].price.."kr", startDrinksX+(xUnit*2.94), startDrinksY+(yUnit*0.1)+ (i-1) * marginY, fieldWith, fieldHeight)

  end
  for i=1,#menu.sauces do
    gfx.screen:copyfrom(tilePNG, nil, {x = startSauceX, y= startSauceY+ (i-1) * marginY, w = fieldWith, h = fieldHeight},true)   
    text.print(gfx.screen,"lato","black","small", menu.sauces[i].name, startSauceX+(xUnit*0.1), startSauceY+(yUnit*0.1)+ (i-1) * marginY, fieldWith * 2, fieldHeight)
    text.print(gfx.screen,"lato","black","small", menu.sauces[i].price.."kr", startSauceX+(xUnit*2.94), startSauceY+(yUnit*0.1)+ (i-1) * marginY, fieldWith * 2, fieldHeight)

  end

  for i=1,#menu.salads do
    gfx.screen:copyfrom(tilePNG, nil, {x = startSaladX, y= startSaladY+ (i-1)* marginY, w = fieldWith, h = fieldHeight},true)   
    text.print(gfx.screen,"lato","black","small", menu.salads[i].name, startSaladX+(xUnit*0.1), startSaladY+(yUnit*0.1)+ (i-1)* marginY, fieldWith* 2, fieldHeight)
    text.print(gfx.screen,"lato","black","small", menu.salads[i].price.."kr", startSaladX+(xUnit*2.94), startSaladY+(yUnit*0.1)+ (i-1)* marginY, fieldWith* 2, fieldHeight)

  end
  tilePNG:destroy()

end
---Sets the upperboundary limit. 
--@param column is the active column (pizzas and sauces or drinks and salads)
function setUpperBoundary(column)
  if column == 1 then
    middleBoundary = #menu.pizzas
    upperBoundary = middleBoundary + #menu.sauces
    startHighlightY = startPosY
  elseif column == 2 then
  	middleBoundary = #menu.drinks
    upperBoundary = middleBoundary + #menu.salads
    startHighlightY = startPosY
  end
end

---Displays highlighter on screen. 
function displayHighlighter()
  local highlighterPNG = gfx.loadpng("Images/OrderPics/ordertilepressed.png")
  highlighterPNG:premultiply()
  local coord = {x = startPosX + (highlightPosX-1) * marginX,  y= startHighlightY + (highlightPosY - 1) * marginY, w = xUnit*5, h =yUnit*0.5}
  
  if tempCopy == nil then
    tempCopy = gfx.new_surface(coord.w, coord.h)
    tempCopy:copyfrom(gfx.screen,coord,nil)
    tempCoord = coord
  else
    gfx.screen:copyfrom(tempCopy,nil,tempCoord,true)
    tempCopy:copyfrom(gfx.screen,coord,nil)
    tempCoord = coord
  end
  
  gfx.screen:copyfrom(highlighterPNG, nil, coord,true)
  highlighterPNG:destroy()  
end

---Adds selected item to order
--@param posX is the current x position
--@param posY is the current y position
function addToOrder(posX,posY)
	local item = refToMenu[posX][posY]
	if refToOrder[posX][item.name] == nil then
		refToOrder[posX][item.name]=item
		refToOrder[posX][item.name].amount=1
	else
		refToOrder[posX][item.name].amount = refToOrder[posX][item.name].amount +1 
	end
	newOrder.totalPrice = newOrder.totalPrice + item.price
end

---Deletes item from order
--@param posX is the x position
--@param posY is the y position
function deleteOrder(posX,posY)
  local item = refToMenu[posX][posY]
  if refToOrder[posX][item.name] then
    refToOrder[posX][item.name].amount= refToOrder[posX][item.name].amount-1
    if(refToOrder[posX][item.name].amount== 0) then
      refToOrder[posX][item.name] = nil
    end
  newOrder.totalPrice = newOrder.totalPrice - item.price  
  end
end

local tempCartCopy = nil
---Displays selected items in a cart
function displayCart()
  local menuItems = 0
  if tempCartCopy == nil then
    tempCartCopy = gfx.new_surface(2 * xUnit, 7.5*yUnit)
    tempCartCopy:copyfrom(gfx.screen,{x = 12.3 *xUnit, y = 2.8 * yUnit, w= 2 * xUnit, h = 7.5 * yUnit},nil)
  else
    gfx.screen:copyfrom(tempCartCopy,nil,{x = 12.3 *xUnit, y = 2.8 * yUnit, w= 2 * xUnit, h = 7.5 * yUnit},true)
	end
	for i=1,#refToOrder do
		for k, v in pairs(refToOrder[i]) do
			text.print(gfx.screen,"lato","black","small", v.amount.." x "..v.name, 12.3 * xUnit, yUnit * 2.8 + 0.25*menuItems*yUnit, xUnit*3.8, yUnit)
			menuItems = menuItems + 1
		end
	end
	text.print(gfx.screen,"lato","black","small", "Total sum:".." "..newOrder.totalPrice.."kr", 12.3 * xUnit, yUnit * 7.2, xUnit*3.8, yUnit)
end

---Function that sets coordinates
--@param x is the x position
--@param y is the y position
function setCoordinates(x,y)
	column = x
	row = y
end

---Function that destroys tempsurface. 
function destroyTempSurfaces()
  tempCartCopy:destroy()
  tempCopy:destroy()
end

---Moves hightlightfield
--@param key is the key user presses
function moveHighlight(key)
  --Up
  if(key == 'up')then
    highlightPosY = highlightPosY - 1
    if(highlightPosY<middleBoundary+1) then
    	if(highlightPosY < lowerBoundary) then
      	highlightPosY = middleBoundary
      end
      setCoordinates(highlightPosX,highlightPosY)
    	startHighlightY = startPosY
    else
    	setCoordinates(highlightPosX+2,highlightPosY-middleBoundary)
    end
  --Down
  elseif(key == 'down')then
    highlightPosY = highlightPosY + 1
    if(highlightPosY>middleBoundary) then
    	if(highlightPosY > upperBoundary) then
      	highlightPosY = middleBoundary + 1
      end
      setCoordinates(highlightPosX+2, highlightPosY-middleBoundary)
      if(highlightPosX==1) then
    	  startHighlightY = startPosY + 1.2 *yUnit + (3-#menu.pizzas) * marginY
      elseif(highlightPosX==2) then
      	startHighlightY = startPosY + 1.2 *yUnit + (4-#menu.drinks) * marginY
      end    
    else
		setCoordinates(highlightPosX,highlightPosY)
    end
  --Left
  elseif(key == 'left')then
    highlightPosX = highlightPosX -1
    if(highlightPosX < 1) then
      highlightPosX = highlightPosX + 2
    end
    setUpperBoundary(highlightPosX)
    highlightPosY = lowerBoundary
    setCoordinates(highlightPosX,highlightPosY)
  --Right
  elseif(key == 'right') then
    highlightPosX = highlightPosX +1
    if(highlightPosX > 2) then
    	highlightPosX = highlightPosX -2
    end
	  setUpperBoundary(highlightPosX)
	  highlightPosY = lowerBoundary
   	setCoordinates(highlightPosX,highlightPosY)
    end
    displayHighlighter()
    gfx.update()
end

---OnKey function. Called when user presses any key
--@param key is the key user pressed
--@param state is the current state (up or down)
function onKey(key,state)
	if(state == 'up') then
	  if(key == 'red') then
      pathName = dir .. "OrderStep1.lua"
      if checkTestMode() then
        return pathName
      else
        destroyTempSurfaces()
        dofile(pathName)
      end
    elseif(key == 'green') then
      if checkTestMode() then
        return key
      end
      --Add to order and display cart
      addToOrder(column,row)
      displayCart()
      gfx.update()
    elseif(key == 'blue') then
      -- Go back to menu
      pathName = dir ..  "OrderStep3.lua"
      if checkTestMode() then
        return pathName
      else
        createOrder()
        destroyTempSurfaces()
        assert(loadfile(pathName))(newOrder)
      end
    --Delete item
    elseif key == 'yellow' then
      if checkTestMode() then
        return key
      end
      deleteOrder(column,row)
      displayCart()
      gfx.update()

    --Navigate
    elseif key == "up" then
      if checkTestMode() then
        return key
      end
      moveHighlight(key)
    elseif key == 'down' then
      if checkTestMode() then
        return key
      end
      moveHighlight(key)
    elseif key == 'left' then
      if checkTestMode() then
        return key
      end
      moveHighlight(key)
    elseif key == 'right' then
      if checkTestMode() then
        return key
      end
      moveHighlight(key)
	  elseif key == 'ok' then
   	end
	end
end

--- Functions that returns some of the values on local variables to be used when testing
-- @param value Sets the different testing values
-- @return StartPosY Starting position of the marker for this page
-- @return HightlightPosY Current position of the marker
-- @return HightlightPosX Current position of the marker
-- @return upperBoundary Value of the highest position the marker can go before going offscreen
-- @return lowerBoundary Value of the lowerst position the marker can go before going offscreen
function returnValuesForTesting(value)
  if value == "startPosY" then
    return startPosY
  elseif value == "highlightPosX" then
    return highlightPosX
  elseif value == "highlightPosY" then 
    return highlightPosY
  elseif value == "upperBoundary" then
    return upperBoundary
  elseif value == "lowerBoundary" then
    return lowerBoundary
  elseif value == "middleBoundary" then
    return middleBoundary
  elseif value == "column" then 
    return column
  end
end
--- This function is used in testing when it is needed to set the value of highlightPosY to a certain number
--@param value is the highlightposition y
function setYValuesForTesting(value)
  highlightPosY = value
end
--- This function is used in testing when it is needed to set the value of highlightPosX to a certain number
--@param value is the highlightposition x
function setXValuesForTesting(value)
  highlightPosX = value
end

---Main method
function onStart()
  createMenu()
  checkExistingOrder()
  setUpperBoundary(highlightPosX)
	updateScreen()
end
onStart()





