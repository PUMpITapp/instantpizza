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
inputFieldStart = gfx.screen:get_height()*(2.5/9)
inputFieldY = gfx.screen:get_height()*(2.5/9)
inputFieldEnd = inputFieldStart + gfx.screen:get_height()*(0.7/9)*5
index = 0

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9
local tilePNG = gfx.loadpng("Images/OrderPics/ordertile.png")
local highlighterPNG = gfx.loadpng("Images/OrderPics/ordertilepressed.png")
local background = gfx.loadpng("Images/OrderPics/createorder.png") 

local highlightPosX = 1
local highlightPosY = 1
local startPosX = 0.4*xUnit
local startPosY = 2.5 * yUnit
local marginX = 2.9*xUnit
local marginY = 0.7*yUnit
local fieldWith = 2 * xUnit
local fieldHeight = 0.5 * yUnit
local lowerBoundary = 1
local upperBoundary = 1
-- local inPizzas = true
-- local inDrinks = false
-- local inSauces = false
-- local in
local menuSurface = gfx.new_surface(10 * xUnit, 4 * yUnit)

local account = ...
local newOrder = {}
local menu = {
  pizzas = {},
  drinks = {},
  sauces = {},
  salads = {}
}

-- 
--Calls methods that builds GUI
function updateScreen()
  gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=16*xUnit, h=9*yUnit})
  displayMenu()
  displayHighlighter()
  gfx.update()
end

function createMenu()
  -- menu.pizzas = account.pizzerias.pizzas
  -- menu.drinks = account.pizzerias.drinks
  menu.sauces[1] = {name = "hotsauce", price = "5kr"}
  menu.sauces[2] = {name = "hotsauce", price = "5kr"}
  menu.sauces[3] = {name = "hotsauce", price = "5kr"}
  menu.sauces[4] = {name = "hotsauce", price = "5kr"}
  menu.sauces[5] = {name = "hotsauce", price = "5kr"}

  menu.salads[1] = {name = "pizzasalad", price = "10kr"}
  menu.salads[2] = {name = "pizzasalad", price = "10kr"}
  menu.salads[3] = {name = "pizzasalad", price = "10kr"}
  menu.salads[4] = {name = "pizzasalad", price = "10kr"}
  menu.salads[5] = {name = "pizzasalad", price = "10kr"}
  menu.salads[6] = {name = "pizzasalad", price = "10kr"}
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
  local xPos = 1
  local yPos = 1

  text.print(gfx.screen, arial, "Pizzas", startPosX, 2 * yUnit, xUnit * 10, yUnit)
  text.print(gfx.screen, arial, "Drinks", startPosX + marginX, 2 * yUnit, xUnit * 10, yUnit)
  text.print(gfx.screen, arial, "Extra sauce", startPosX + marginX * 2, 2* yUnit, xUnit * 10, yUnit)
  text.print(gfx.screen, arial, "Sallads", startPosX + marginX * 3, 2 * yUnit, xUnit * 10, yUnit)


  -- gfx.screen:copyfrom(menuSurface)
  
  -- for k, v in pairs(menu.pizza)do
  --   gfx.screen:copyfrom(tilePNG, nil, {x = xUnit, y= (2 + 0.5*yPos)* yUnit, w = xUnit * 3.5, h =yUnit*0.5})
  --   yPos = yPos + 1
  -- then
  for i=1,4 do
    gfx.screen:copyfrom(tilePNG, nil, {x = startPosX, y= startPosY+  (i-1)* marginY, w = fieldWith, h = fieldHeight})   
  end

  for i=1,4 do
    gfx.screen:copyfrom(tilePNG, nil, {x = startPosX + marginX, y= startPosY+ (i-1)* marginY , w = fieldWith, h = fieldHeight})   
  end

  for i=1,#menu.sauces do
    gfx.screen:copyfrom(tilePNG, nil, {x = startPosX+ marginX * 2, y= startPosY+ (i-1) * marginY, w = fieldWith, h = fieldHeight})   
    text.print(gfx.screen, arial, menu.sauces[i].name..": "..menu.sauces[i].price, startPosX+ marginX * 2, startPosY+ (i-1) * marginY, fieldWith * 2, fieldHeight)
  end

  for i=1,#menu.salads do
    gfx.screen:copyfrom(tilePNG, nil, {x = startPosX+ marginX *3, y= startPosY+ (i-1)* marginY, w = fieldWith, h = fieldHeight})   
    text.print(gfx.screen, arial, menu.salads[i].name..": "..menu.salads[i].price, startPosX+ marginX *3, startPosY+ (i-1)* marginY, fieldWith* 2, fieldHeight)
  end

end

function setUpperBoundary(column)
  if column == 1 then
    upperBoundary = #menu.pizzas
  elseif column == 2 then
    upperBoundary = #menu.drinks
  elseif column == 3 then
    upperBoundary = #menu.sauces
  elseif column == 4 then
    upperBoundary = #menu.salads
  end
end

function displayHighlighter()
  gfx.screen:copyfrom(highlighterPNG, nil, {x = startPosX + (highlightPosX-1) * marginX,  y= startPosY + (highlightPosY - 1) * marginY, w = xUnit * 2.9, h =yUnit*0.5})
end

function moveHighlight(key)
--Moves the current inputField
  --Up
  if(key == 'Up')then
    highlightPosY = highlightPosY - 1
    if(highlightPosY < lowerBoundary) then
      highlightPosY = highlightPosY +1
    end

  --Down
  elseif(key == 'Down')then
    highlightPosY = highlightPosY + 1
    if(highlightPosY > upperBoundary) then
      highlightPosY = highlightPosY -1
    end
  --Left
  elseif(key == 'Left')then
    highlightPosX = highlightPosX -1
    if(highlightPosX < 1) then
      highlightPosX = highlightPosX + 1
    end
      setUpperBoundary(highlightPosX)
      highlightPosY = 1
    
  --Right
  elseif(key == 'Right') then
    highlightPosX = highlightPosX +1
    if(highlightPosX > 4) then
      highlightPosX = highlightPosX -1
    end
    setUpperBoundary(highlightPosX)
    highlightPosY = 1
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
        --Go back to menu
        pathName = "OrderStep3.lua"
        if checkTestMode() then
          return pathName

        else
          dofile(pathName)
        end

      elseif key == "Up" then
        moveHighlight(key)
      elseif key == 'Down' then
        moveHighlight(key)
      elseif key == 'Left' then
        moveHighlight(key)
      elseif key == 'Right' then
        moveHighlight(key)
	  	end
	end
  updateScreen()
end

--Main method
function main()
  createMenu()
  -- createMenuSurface()
	updateScreen()
end
main()





