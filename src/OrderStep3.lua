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
local onBox =true


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
local user = {}
local newOrder = ...
local network = false

--Calls methods that builds GUI
function buildGUI()
  displayBackground()
  printHeadLines()
  printOrder()
end

function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/OrderPics/orderstep3.png") 
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
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

function internet(order)
        local sock = require "socket"
        local tcp=sock.tcp()
        print("connecting")
        tcp:connect("pumi-2.ida.liu.se", 88)
        tcp:send(order.."\n")
        local s,status, partial = tcp:receive()
        print(s)
        --print(status)
        --print(partial)
        tcp:close()
	if(s==nil)then
		return false
	end
	return true
end

function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'red') then
	  		--Go back to the previous step in the order process
        pathName = dir .. "OrderStep2.lua"
        if checkTestMode() then
          return pathName
        else
          editOrder = newOrder
          assert(loadfile(pathName))(editOrder)
        end
      elseif(key == 'yellow') then
        --Continue to QR-code page
        network=internet("OMG")
	
        if(network)then
          pathName = dir .. "OrderStep4.lua"
        else
          pathName = dir .. "OrderFail.lua"
        end
        if checkTestMode() then
          return pathName
        else
          assert(loadfile(pathName))(newOrder)
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
function onStart()
	updateScreen()
end
onStart()





