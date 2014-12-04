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
function chooseGfx()
  if not checkTestMode() then
    tempGfx = require "gfx"
  elseif checkTestMode() then
    tempGfx = require "gfx_stub"
  end
  return tempGfx
end

--- Chooses the text
-- @return #string tempText Returns write_text_stub if the file is being tested, returns actual write_text if the file is being run.
function chooseText()
  if not checkTestMode() then
    tempText = require "write_text"
  elseif checkTestMode() then
    tempText = require "write_text_stub"
  end
  return tempText
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

--- Variable to use when displaying printed text on the screen
--- Determine whether to use the stub or to run the actual file
local text = chooseText()

--- Variable to use when handling tables that are stored in the system
local io = require "IOHandler"

--- Declare units in variables
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

--- Start of inputField
local startPosY = yUnit * 2.6
local startPosX = xUnit * 4

--- End of inputfield
local endPosY = yUnit*6.8

--- Determines the space between fields
local marginY = yUnit*0.3
local marginX = xUnit * 4

--- Variable to check whether a user has chosen anything to order or not
local isOrdered = false

--- Tables to handle user content
local user = {}
local newOrder = ...

--- Function that builds the GUI
function buildGUI()
  displayBackground()
  printHeadLines()
  printOrder()
end

--- Function that displays the Background image of the application
function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/OrderPics/orderstep3.png") 
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
end

--- Function to display the labels in this step that has corresponding values in printOrder()
function printHeadLines()
  startPosYHeader = startPosY*0.9
  text.print(gfx.screen,"lato","black","medium","Product", startPosX, startPosYHeader, 6* xUnit,200)
  text.print(gfx.screen,"lato","black","medium","Amount", startPosX+marginX*0.84, startPosYHeader, 6* xUnit,200)
  text.print(gfx.screen,"lato","black","medium","Price", startPosX+marginX*1.6, startPosYHeader, 6* xUnit,200)
  text.print(gfx.screen,"lato","black","medium","Total sum:", startPosX+marginX*1.4,endPosY, 6* xUnit,200)
end

--- Function to display the products that the user has ordered
function printOrder()
  i = 1
  if checkTestMode() then
  else
    if not isOrdered then
     text.print(gfx.screen,"lato","black","medium","You did not order any pizzas!", startPosX, startPosY+(marginY*5), 10* xUnit,yUnit)
     text.print(gfx.screen,"lato","black","medium","Please edit order.", startPosX, startPosY+(marginY*6.5), 10* xUnit,yUnit)
    else 
      for j = 1, #newOrder.order do
        for key,v in pairs(newOrder.order[j])do
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
end

--- Checks if something has been chosen by the user or not
function checkOrder()
  for k,v in pairs(newOrder.order[1]) do
    if v ~= "" then
      isOrdered = true
    end
  end
end

--- Gets input from user and re-directs according to input
-- @param #string key The key that has been pressed
-- @param #string state The state of the key-press
-- @return #string pathName The path that the program shall be directed to
function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'red') then
	  		-- Go back to the previous step in the order process
        pathName = dir .. "OrderStep2.lua"
        if checkTestMode() then
          return pathName
        else
          editOrder = newOrder
          assert(loadfile(pathName))(editOrder)
        end
      elseif(key == 'yellow') then
        -- Continue to next step
        if isOrdered then
          pathName = dir .. "OrderPending.lua"
          if checkTestMode() then
            return pathName
          else
            assert(loadfile(pathName))(newOrder)
          end
        end
        elseif(key == 'blue') then
          -- Nothing
	  	end
	end
end

--- Function that that updates the current screen to be able to show new or changed information to the user
function updateScreen()
  checkOrder()
  buildGUI()
  gfx.update()
end
--- Main method
function onStart()
	updateScreen()
end
onStart()





