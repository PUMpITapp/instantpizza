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
local gfx =  chooseGfx()

local io = require "IOHandler"
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

local startPosY = yUnit * 2.6
local startPosX = xUnit * 4
local endPosY = yUnit*6.8
local marginY = yUnit*0.3
local marginX = xUnit * 4
local totalSum = 0
local lastPizzaIndex = 0
local lastDrinkIndex = 0
local background = gfx.loadpng("Images/OrderPics/orderstep3.png") 
local user = {}
local newOrder = ...
local network = false

--Calls methods that builds GUI
function buildGUI()
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
printHeadLines()
printOrder()
end

function printHeadLines()
  startPosYHeader = startPosY*0.9
  text.print(gfx.screen,"lato","black","medium","Product", startPosX, startPosYHeader, 6* xUnit,200)
  text.print(gfx.screen,"lato","black","medium","Amount", startPosX+marginX*0.84, startPosYHeader, 6* xUnit,200)
  text.print(gfx.screen,"lato","black","medium","Price", startPosX+marginX*1.6, startPosYHeader, 6* xUnit,200)
  text.print(gfx.screen,"lato","black","medium","Total sum:", startPosX+marginX*1.4,endPosY, 6* xUnit,200)
end

function printOrder()
  i = 1
  if checkTestMode() then
  else
    for j = 1, #newOrder.order do
      for key,v in pairs(newOrder.order[j])do
      -- print(v.name,v.price,v.amount)
        amount = v.amount
        text.print(gfx.screen,"lato","black","small",tostring(v.name), startPosX, startPosY+(marginY*i), 6* xUnit,200)
        text.print(gfx.screen,"lato","black","small",tostring(amount), startPosX+marginX, startPosY+(marginY*i), 6* xUnit,200)
        text.print(gfx.screen,"lato","black","small",tostring(amount*v.price.."kr"), startPosX+marginX*1.6, startPosY+(marginY*i), 6* xUnit,200)
        i = i+1
      end
  end
    text.print(gfx.screen,"lato","black","medium",tostring(newOrder.totalPrice.."kr"), startPosX+marginX*2,endPosY, 6* xUnit,200)
end
end

function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'red') then
	  		--Go back to the previous step in the order process
        pathName = "OrderStep2.lua"
        if checkTestMode() then
          return pathName
        else
          editOrder = newOrder
          assert(loadfile(pathName))(editOrder)
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
        --Continue to QR-code page
        if(network)then
          pathName = "OrderStep4.lua"
        else
          pathName = "OrderFail.lua"
        end
        if checkTestMode() then
          return pathName
        else
          assert(loadfile(pathName))(newOrder)
          gfx.screen:destroy()
        end
        elseif(key == 'blue') then
        	

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





