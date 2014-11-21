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
local order = ...
local background = gfx.loadpng("Images/OrderPics/OrderStep4.png") 
local time = 0
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

--Calls methods that builds GUI
function buildGUI()
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
text.print(gfx.screen,"lato","black","large",tostring(time).." min", xUnit*6.5, yUnit*3.5, 6* xUnit,200)
gfx.update()
end

function onKey(key,state)
	if(state == 'up') then
      if(key == 'green') then
        --Go back to menu
        pathName = "Menu.lua"
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
  print(time)
end

function displayOrderInfo()
  text.print(gfx.screen,"lato","black","medium","Orderinformation", xUnit*3.9, yUnit*5.5, 6* xUnit,200)
  text.print(gfx.screen,"lato","black","small",tostring(order.pizzeria.name).." ".."010-31231231", xUnit*4, yUnit*6, 6* xUnit,200)
  text.print(gfx.screen,"lato","black","small","Total cost: "..tostring(order.totalPrice).."kr", xUnit*4, yUnit*6.3, 6* xUnit,200)

end
--Main method
function main()
  randomTime()
	buildGUI()
  displayOrderInfo()
  sleep()
end
main()





