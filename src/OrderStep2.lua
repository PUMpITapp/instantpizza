-- These three functions below are required for running tests on this file
--- Checks if the file was called from a test file.
-- Returs true if it was, 
--   - which would mean that the file is being tested.
-- Returns false if it was not,
--   - which wold mean that the file was being used.  
local onBox = true

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

if onBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/OrderPics/?.png'
  dir = sys.root_path()

else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
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

--Start of inputFields.

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

local highlightPosX = 1
local highlightPosY = 1
local column = 1
local row = 1
local startPosX = 1*xUnit
local startPosY = 2.5 * yUnit

local startHighlightY = startPosY

local startDrinksY = startPosY
local startDrinksX = 6 * startPosX

local startSauceY = 5.5 * yUnit
local startSauceX = startPosX

local startSaladY = 6.1 * yUnit
local startSaladX = 6 * startPosX

local marginX = 5*xUnit
local marginY = 0.6*yUnit
local fieldWith = 3.5 * xUnit
local fieldHeight = 0.5 * yUnit
local lowerBoundary = 1
local middleBoundary = 1
local upperBoundary = 1
local tempCopy = nil
local tempCoord = {}



local account = ...
local editOrder = ...

local newOrder = {
	name = account.name,
	address = account.address,
	phone = account.phone,
	zipCode = account.zipCode,
  email = account.email,
  pizzeria = account.pizzeria,
	totalPrice = 0
}
local order = {
  pizzas = {},
  sauces = {},
  drinks = {},
  salads = {}
}
local menu = {
  pizzas = {},
  drinks = {},
  sauces = {},
  salads = {}
}

local refToMenu = {}
local refToOrder = {}
local cart = {}
local io = require "IOHandler"
-- 
--Calls methods that builds GUI
function updateScreen()
  displayBackground()
  displayMenu()
  displayCart()
  displayHighlighter()
  gfx.update()
end

function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/OrderPics/orderstep2.png") 
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=16*xUnit, h=9*yUnit})
  backgroundPNG:destroy()
end

function createOrder()
  newOrder["order"] = refToOrder
end
function checkExistingOrder()
  if not (editOrder.order == nil)then
    refToOrder[1] = editOrder.order[1]
    refToOrder[2] = editOrder.order[2]
    refToOrder[3] = editOrder.order[3]
    refToOrder[4] = editOrder.order[4]
    newOrder.totalPrice = editOrder.totalPrice
  end
end
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

function displayMenu()

  -- gfx.screen:copyfrom(menuSurface)
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


--could be optimized
local tempCartCopy = nil
function displayCart()
  local menuItems = 0
  if tempCartCopy == nil then
    tempCartCopy = gfx.new_surface(2 * xUnit, 7.5*yUnit)
    tempCartCopy:copyfrom(gfx.screen,{x = 12.3 *xUnit, y = 2.8 * yUnit, w= 2 * xUnit, h = 7.5 * yUnit},nil)
  else
    gfx.screen:copyfrom(tempCartCopy,nil,{x = 12.3 *xUnit, y = 2.8 * yUnit, w= 2 * xUnit, h = 7.5 * yUnit},true)
	end
  -- print(#refToOrder)
	for i=1,#refToOrder do
		for k, v in pairs(refToOrder[i]) do
			text.print(gfx.screen,"lato","black","small", v.amount.." x "..v.name, 12.3 * xUnit, yUnit * 2.8 + 0.25*menuItems*yUnit, xUnit*3.8, yUnit)
			menuItems = menuItems + 1
		end
	end
	text.print(gfx.screen,"lato","black","small", "Total sum:".." "..newOrder.totalPrice.."kr", 12.3 * xUnit, yUnit * 7.2, xUnit*3.8, yUnit)
end

function setCoordinates(x,y)
	column = x
	row = y
end

function destroyTempSurfaces()
  tempCartCopy:destroy()
  tempCopy:destroy()
end
function moveHighlight(key)
--Moves the current inputField
  --Up
  if(key == 'up')then
    highlightPosY = highlightPosY - 1
    if(highlightPosY<middleBoundary+1) then
    	setCoordinates(highlightPosX,highlightPosY)
    	if(highlightPosY < lowerBoundary) then
      	highlightPosY = middleBoundary
      	end
    	startHighlightY = startPosY
    else
    	setCoordinates(highlightPosX+2,highlightPosY-middleBoundary)

    end

  --Down
  elseif(key == 'down')then
    highlightPosY = highlightPosY + 1
    if(highlightPosY>middleBoundary) then
    	setCoordinates(highlightPosX+2, highlightPosY-middleBoundary)
    	if(highlightPosY > upperBoundary) then
      	highlightPosY = middleBoundary + 1
      	end
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

function onKey(key,state)
	if(state == 'up') then
	  if(key == 'red') then
	  	--Choose account and go to next step
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
      addToOrder(column,row)
      displayCart()
      gfx.update()
      -- updateScreen()

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
    elseif key == 'yellow' then
      if checkTestMode() then
        return key
      end
      deleteOrder(column,row)
      displayCart()
      gfx.update()
      -- updateScreen()
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
-- Below are functions that is required for the testing of this file

-- This functions returns some of the values on local variables to be used when testing
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
-- This function is used in testing when it is needed to set the value of highlightPosY to a certain number
function setYValuesForTesting(value)
  highlightPosY = value
end
-- This function is used in testing when it is needed to set the value of highlightPosX to a certain number
function setXValuesForTesting(value)
  highlightPosX = value
end

--Main method
function onStart()
  createMenu()
  checkExistingOrder()
  setUpperBoundary(highlightPosX)

	updateScreen()
    -- displayHighlighter()
end
onStart()





