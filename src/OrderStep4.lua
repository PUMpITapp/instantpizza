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
local onBox =false

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
  if not underGoingTest then
    tempText = require "write_text"
  elseif underGoingTest then
    tempText = require "write_text_stub"
  end
  return tempText
end

local text = chooseText(checkTestMode())
local newOrder = ...
local time = 0
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

--Calls methods that builds GUI
function buildGUI()
  displayBackground()
  text.print(gfx.screen,"lato","black","large",tostring(time).." min", xUnit*6.5, yUnit*3.5, 6* xUnit,200)
end

function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/OrderPics/orderstep4.png") 
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
end

function onKey(key,state)
	if(state == 'up') then
      if(key == 'green') then
        --Go back to menu
        pathName = dir .. "Menu.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
	  	end
	end
end

function randomTime()
  math.randomseed(os.time())
  time = math.random(30,60)
end

function displayOrderInfo()
  if checkTestMode() then
    --Nothing
  else
  text.print(gfx.screen,"lato","black","medium","Orderinformation", xUnit*3.9, yUnit*5.5, 6* xUnit,200)
  text.print(gfx.screen,"lato","black","small",tostring(newOrder.pizzeria.name).." ".."010-31231231", xUnit*4, yUnit*6, 6* xUnit,200)
  text.print(gfx.screen,"lato","black","small","Total cost: "..tostring(newOrder.totalPrice).."kr", xUnit*4, yUnit*6.3, 6* xUnit,200)
  end
end
--Main method
function onStart()
  randomTime()
	buildGUI()
  displayOrderInfo()
  gfx.update()
end
onStart()





