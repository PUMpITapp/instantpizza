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
local io = require "IOHandler"
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

local startPosY = yUnit * 2
local startPosX = xUnit * 2.4
local endPosY = yUnit*7
local marginY = yUnit / 2
local marginX = xUnit * 4
local totalSum = 0
local lastPizzaIndex = 0
local lastDrinkIndex = 0
local background = gfx.loadpng("Images/OrderPics/orderstep3.png") 
local user = {}
local newOrder = ...

--Calls methods that builds GUI
function buildGUI()
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
printHeadLines()
printOrder()
end

function printHeadLines()
  text.print(gfx.screen, arial,"Product", startPosX, startPosY, 6* xUnit,200)
  text.print(gfx.screen, arial,"Amount", startPosX+marginX*0.84, startPosY, 6* xUnit,200)
  text.print(gfx.screen, arial,"Price", startPosX+marginX*1.6, startPosY, 6* xUnit,200)
  text.print(gfx.screen, arial,"Total sum:", startPosX,endPosY, 6* xUnit,200)
end

function printOrder()
  i = 1
  for key,v in pairs(newOrder.pizzas)do
    print(v.name,v.price,v.amount)
    amount = v.amount
    text.print(gfx.screen, arial,tostring(v.name), startPosX, startPosY+(marginY*i), 6* xUnit,200)
    text.print(gfx.screen, arial,tostring(amount), startPosX+marginX, startPosY+(marginY*i), 6* xUnit,200)
    text.print(gfx.screen, arial,tostring(amount*v.price), startPosX+marginX*1.6, startPosY+(marginY*i), 6* xUnit,200)
    lastPizzaIndex = i
    i=i+1
  end
  i=1 
  for key,v in pairs(newOrder.drinks)do
    amount = v.amount
    text.print(gfx.screen, arial,tostring(v.name), startPosX, startPosY+(marginY*(lastPizzaIndex+i)), 6* xUnit,200)
    text.print(gfx.screen, arial,tostring(amount), startPosX+marginX, startPosY+(marginY*(lastPizzaIndex+i)), 6* xUnit,200)
    text.print(gfx.screen, arial,tostring(amount*v.price), startPosX+marginX*1.6, startPosY+(marginY*(lastPizzaIndex+i)), 6* xUnit,200)
    lastDrinkIndex = lastPizzaIndex+i
    i= i+1
  end
  text.print(gfx.screen, arial,tostring(newOrder.totalPrice), startPosX+marginX*1.6,endPosY, 6* xUnit,200)
end

function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'red') then
	  		--Choose account and go to next step
        pathName = "OrderStep2.lua"
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
      elseif(key == 'yellow') then
        --Go back to menu
        pathName = "OrderStep4.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
        elseif(key == 'blue') then
        	assert(loadfile("OrderFail.lua"))(newOrder)

	  	end
	end
end
function updateScreen()
  buildGUI()
  gfx.update()
end
--Main method
function main()
	updateScreen()
end
main()





