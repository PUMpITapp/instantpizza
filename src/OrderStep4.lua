--TODO:
--Another background and text font/color
--Real graphic components
--Inputs from user, read and write
--Create user from input
--Buttons
--Transparency not working

--- Set if the program is running on the box or not
local onBox =true

--- Checks if the file was called from a test file.
-- @return #boolean true if called from a test file, indicating the file is being tested, else false 
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
-- @return #string tempGfx Returns dummy gfx if the file is being tested, returns actual gfx if the file is being run.
function chooseGfx(underGoingTest)
  if not underGoingTest then
    tempGfx = require "gfx"
  elseif underGoingTest then
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
-- @return #string tempText Returns write_text_stub if the file is being tested, returns actual write_text if the file is being run.
function chooseText(underGoingTest)
  if not underGoingTest then
    tempText = require "write_text"
  elseif underGoingTest then
    tempText = require "write_text_stub"
  end
  return tempText
end

--- Variable to use when displaying printed text on the screen
--- Determine whether to use the stub or to run the actual file
local text = chooseText(checkTestMode())

--- Initiates a new form for this step
local newOrder = ...

--- Declare units in variables
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

---Calls methods that builds GUI
function buildGUI()
  displayBackground()
  text.print(gfx.screen,"lato","black","large",tostring(newOrder.time).." min", xUnit*6.5, yUnit*3.5, 6* xUnit,200)
end

--- Function that displays the Background image of the application
function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/OrderPics/orderstep4.png") 
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
end

--- Gets input from user and re-directs according to input
-- @param #string key The key that has been pressed
-- @param #string state The state of the key-press
-- @return #String pathName The path that the program shall be directed to
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

--- Function that displays the current order information to the user
function displayOrderInfo()
  text.print(gfx.screen,"lato","black","medium","Orderinformation", xUnit*3.9, yUnit*5.5, 6* xUnit,200)
  text.print(gfx.screen,"lato","black","small",tostring(newOrder.pizzeria.name).." ".."010-31231231", xUnit*4, yUnit*6, 6* xUnit,200)
  text.print(gfx.screen,"lato","black","small","Total cost: "..tostring(newOrder.totalPrice).."kr", xUnit*4, yUnit*6.3, 6* xUnit,200)
end

---Main method
function onStart()
	buildGUI()
  displayOrderInfo()
  gfx.update()
end
onStart()





