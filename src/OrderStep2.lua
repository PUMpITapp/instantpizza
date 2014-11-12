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


--Calls methods that builds GUI
function buildGUI()
local background = gfx.loadpng("Images/OrderPics/createorder.png") 
  gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=16*xUnit, h=9*yUnit})
  displayMenu()
  gfx.update()
end

function displayMenu()
  text.print(gfx.screen, arial, "Pizzas", xUnit, 2 * yUnit, xUnit * 10, yUnit)
  gfx.screen:copyfrom(tilePNG, nil, {x = xUnit, y= 2.5 * yUnit, w = xUnit * 3.5, h =yUnit*0.5})
  gfx.screen:copyfrom(tilePNG, nil, {x = 6 * xUnit, y= 2.5 * yUnit, w = xUnit * 3.5, h =yUnit*0.5})
  gfx.screen:copyfrom(tilePNG, nil, {x = xUnit, y= 3 * yUnit, w = xUnit * 3.5, h =yUnit*0.5})
  gfx.screen:copyfrom(tilePNG, nil, {x = 6 * xUnit, y= 3 * yUnit, w = xUnit * 3.5, h =yUnit*0.5})
  gfx.screen:copyfrom(highlighterPNG, nil, {x = xUnit, y= 2.5 * yUnit, w = xUnit * 5, h =yUnit*0.5})

  text.print(gfx.screen, arial, "Drinks", xUnit, 3.5 * yUnit, xUnit * 10, yUnit)
  gfx.screen:copyfrom(tilePNG, nil, {x = xUnit, y= 4 * yUnit, w = xUnit * 3.5, h =yUnit*0.5})
  gfx.screen:copyfrom(tilePNG, nil, {x = 6 * xUnit, y= 4 * yUnit, w = xUnit * 3.5, h =yUnit*0.5})
  gfx.screen:copyfrom(tilePNG, nil, {x = xUnit, y= 4.5 * yUnit, w = xUnit * 3.5, h =yUnit*0.5})
  gfx.screen:copyfrom(tilePNG, nil, {x = 6 * xUnit, y= 4.5 * yUnit, w = xUnit * 3.5, h =yUnit*0.5})


  text.print(gfx.screen, arial, "Extra sauce", xUnit, 5 * yUnit, xUnit * 10, yUnit)
    gfx.screen:copyfrom(tilePNG, nil, {x = xUnit, y= 5.5 * yUnit, w = xUnit * 3.5, h =yUnit*0.5})
  gfx.screen:copyfrom(tilePNG, nil, {x = 6 * xUnit, y= 5.5 * yUnit, w = xUnit * 3.5, h =yUnit*0.5})
  gfx.screen:copyfrom(tilePNG, nil, {x = xUnit, y= 6 * yUnit, w = xUnit * 3.5, h =yUnit*0.5})
  gfx.screen:copyfrom(tilePNG, nil, {x = 6 * xUnit, y= 6 * yUnit, w = xUnit * 3.5, h =yUnit*0.5})

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
	  	end
	end
end

--Main method
function main()
	buildGUI()
end
main()





