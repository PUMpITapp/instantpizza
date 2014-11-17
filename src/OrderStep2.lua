--TODO:
--Another background and text font/color
--Real graphic components
--Inputs from user, read and write
--Create user from input
--Buttons
--Transparency not working
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
function chooseGfx(underGoingTest)
  if not underGoingTest then
    tempGfx = require "gfx"
  elseif underGoingTest then
    tempGfx = require "gfx_stub"
  end
  return tempGfx
end

function chooseText(underGoingTest)
  if not underGoingTest then
    tempText = require "write_text"
  elseif underGoingTest then
    tempText = require "write_text_stub"
  end
  return tempText
end
local text = chooseText(checkTestMode())
local gfx =  chooseGfx(checkTestMode())

--Start of inputFields.

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9
local tilePNG = gfx.loadpng("Images/OrderPics/ordertile.png")
local highlighterPNG = gfx.loadpng("Images/OrderPics/ordertilepressed.png")
local background = gfx.loadpng("Images/OrderPics/orderstep2.png") 

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

local menuSurface = gfx.new_surface(10 * xUnit, 4 * yUnit)

local account = ...

local newOrder = {
	name = account.name,
	address = account.address,
	phone = account.phone,
	email = account.email,
	pizzas = {},
	drinks = {},
	sauces = {},
	salads = {},
	totalPrice = 0
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

-- 
--Calls methods that builds GUI
function updateScreen()
  gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=16*xUnit, h=9*yUnit})
  displayMenu()
  displayHighlighter()
  showCart()
  gfx.update()
end

function createMenu()
  menu.pizzas = account.pizzeria.pizzas -- array with numbers

  menu.drinks[1] = {name = "Sprite", price = "5"}
  menu.drinks[2] = {name = "Coke", price = "5"}
  menu.drinks[3] = {name = "Beer", price = "5"}
  menu.drinks[4] = {name = "Fanta", price = "5"}
  menu.drinks[5] = {name = "Loka", price = "5"}

  menu.sauces[1] = {name = "hotsauce", price = "5"}
  menu.sauces[2] = {name = "hotsauce", price = "5"}
  menu.sauces[3] = {name = "hotsauce", price = "5"}

  menu.salads[1] = {name = "pizzasalad", price = "10"}
  menu.salads[2] = {name = "pizzasalad", price = "10"}

refToMenu[1] = menu.pizzas
refToMenu[2] = menu.drinks
refToMenu[3] = menu.sauces
refToMenu[4] = menu.salads

refToOrder[1] = newOrder.pizzas
refToOrder[2] = newOrder.drinks
refToOrder[3] = newOrder.sauces
refToOrder[4] = newOrder.salads

end

-- function createMenuSurface()
--   -- menuSurface:clear()
--   -- menuSurface:fill({r = 255, g = 255, b = 255, a= 100})
--   -- for i=1,4 do
--   --   menuSurface:copyfrom(tilePNG, nil, {x = startPosX, y= startPosY+  (i-1)* marginY, w = fieldWith, h = fieldHeight})   
--   -- end

--   -- for i=1,4 do
--   --   menuSurface:copyfrom(tilePNG, nil, {x = startPosX + marginX, y= startPosY+ (i-1)* marginY , w = fieldWith, h = fieldHeight})   
--   -- end

--   -- for i=1,#menu.sauces do
--   --   menuSurface:copyfrom(tilePNG, nil, {x = startPosX+ marginX * 2, y= startPosY+ (i-1) * marginY, w = fieldWith, h = fieldHeight})   
--   --   text.print(menuSurface, arial, menu.sauces[i].name, startPosX+ marginX * 2, startPosY+ (i-1) * marginY, fieldWith, fieldHeight)
--   -- end

--   -- for i=1,#menu.salads do
--   --   menuSurface:copyfrom(tilePNG, nil, {x = startPosX+ marginX *3, y= startPosY+ (i-1)* marginY, w = fieldWith, h = fieldHeight})   
--   --   text.print(menuSurface, arial, menu.salads[i].name, startPosX+ marginX *3, startPosY+ (i-1)* marginY, fieldWith, fieldHeight)
--   -- end
-- end

function displayMenu()

  -- gfx.screen:copyfrom(menuSurface)

  for i =1,#menu.pizzas do
  	    gfx.screen:copyfrom(tilePNG, nil, {x = startPosX, y= startPosY+  (i-1)* marginY, w = fieldWith, h = fieldHeight})   
    text.print(gfx.screen, arial, menu.pizzas[i].name..": "..menu.pizzas[i].price, startPosX, startPosY+ (i-1) * marginY, fieldWith, fieldHeight)
 
  end

  for i =1,#menu.drinks do
    gfx.screen:copyfrom(tilePNG, nil, {x = startDrinksX, y= startDrinksY+ (i-1)* marginY , w = fieldWith, h = fieldHeight})   
    text.print(gfx.screen, arial, menu.drinks[i].name..": "..menu.drinks[i].price, startDrinksX, startDrinksY+ (i-1) * marginY, fieldWith, fieldHeight)
 
  end
  for i=1,#menu.sauces do
    gfx.screen:copyfrom(tilePNG, nil, {x = startSauceX, y= startSauceY+ (i-1) * marginY, w = fieldWith, h = fieldHeight})   
    text.print(gfx.screen, arial, menu.sauces[i].name..": "..menu.sauces[i].price, startSauceX, startSauceY+ (i-1) * marginY, fieldWith * 2, fieldHeight)
  end

  for i=1,#menu.salads do
    gfx.screen:copyfrom(tilePNG, nil, {x = startSaladX, y= startSaladY+ (i-1)* marginY, w = fieldWith, h = fieldHeight})   
    text.print(gfx.screen, arial, menu.salads[i].name..": "..menu.salads[i].price, startSaladX, startSaladY+ (i-1)* marginY, fieldWith* 2, fieldHeight)
  end

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
  gfx.screen:copyfrom(highlighterPNG, nil, {x = startPosX + (highlightPosX-1) * marginX,  y= startHighlightY + (highlightPosY - 1) * marginY, w = xUnit*5, h =yUnit*0.5})
end

function addToOrder(posX,posY)
	local item = refToMenu[posX][posY]
	cart[#cart+1] = item

	if refToOrder[posX][item.name] == nil then
		refToOrder[posX][item.name]=item
		refToOrder[posX][item.name].amount=1
	else
		refToOrder[posX][item.name].amount = refToOrder[posX][item.name].amount +1 
	end
	newOrder.totalPrice = newOrder.totalPrice + item.price
end

function showCart()
	local menuItems = 0
	-- print(#refToOrder)
	for i=1,#refToOrder do
		for k, v in pairs(refToOrder[i]) do
			text.print(gfx.screen, arial, v.amount.." x "..v.name, 12.2 * xUnit, yUnit * 2.8 + 0.5*menuItems*yUnit, xUnit*3.8, yUnit)
			menuItems = menuItems + 1
		end
	end
	text.print(gfx.screen, arial, "tot:".." "..newOrder.totalPrice, 12.2 * xUnit, yUnit * 8, xUnit*3.8, yUnit)
end

function setCoordinates(x,y)
	column = x
	row = y
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
      	startHighlightY = startPosY + 1.2* yUnit - marginY
    else
		setCoordinates(highlightPosX,highlightPosY)

    end
  --Left
  elseif(key == 'left')then
    highlightPosX = highlightPosX -1
    if(highlightPosX < 1) then
      highlightPosX = highlightPosX + 1

    end
      setUpperBoundary(highlightPosX)
      highlightPosY = lowerBoundary
      setCoordinates(highlightPosX,highlightPosY)


  --Right
  elseif(key == 'right') then
    highlightPosX = highlightPosX +1
    if(highlightPosX > 2) then
    	highlightPosX = highlightPosX -1
    end
	    setUpperBoundary(highlightPosX)
	    highlightPosY = lowerBoundary
   		setCoordinates(highlightPosX,highlightPosY)

  end
end

function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'red') then
	  		--Choose account and go to next step
        pathName = "OrderStep1.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
      elseif(key == 'green') then
        --Go back to menu
        pathName = "Menu.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
      elseif(key == 'blue') then
        -- Go back to menu
        print("PIZZAS")
        for k,v in pairs(newOrder.pizzas) do
        	print(k,v)
        	for i,j in pairs(v) do
        		print(i,j)
        	end
        end
        print("DRINKS")
                for k,v in pairs(newOrder.drinks) do
        	print(k,v)
        	for i,j in pairs(v) do
        		print(i,j)
        	end
        end
        pathName = "OrderStep3.lua"
        if checkTestMode() then
          return pathName

        else
          assert(loadfile(pathName))(newOrder)
        end

      elseif key == "up" then
        moveHighlight(key)
      elseif key == 'down' then
        moveHighlight(key)
      elseif key == 'left' then
        moveHighlight(key)
      elseif key == 'right' then
        moveHighlight(key)
	  elseif key == 'ok' then
	  	addToOrder(column,row)
	  	

	  	end
	end
  updateScreen()
end

--Main method
function main()
  createMenu()
  setUpperBoundary(highlightPosX)

  -- createMenuSurface()
	updateScreen()
end
main()





