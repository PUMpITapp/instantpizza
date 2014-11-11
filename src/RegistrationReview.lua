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

--Form from earlier step
local lastForm = ...

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9
local background = gfx.loadpng("Images/UserRegistrationPics/registrationreview.png")



--Calls methods that builds GUI
function buildGUI()
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
displayHighlightSurface()
gfx.update()
end

--Creates inputsurface and displays "highlighted" input
function displayHighlightSurface()
  text.print(gfx.screen, arial, "Name: "..tostring(lastForm.name), xUnit*3*1.1, yUnit * 2, 500, 500)
  text.print(gfx.screen, arial, "Address: "..tostring(lastForm.address), xUnit*3*1.1, yUnit * 2.5,500,500)
  text.print(gfx.screen, arial, "ZipCode: "..tostring(lastForm.zipCode), xUnit*3*1.1, yUnit * 3,500,500)
  text.print(gfx.screen, arial, "City: "..tostring(lastForm.city), xUnit*3*1.1, yUnit * 3.5,500, 500)
  text.print(gfx.screen, arial, "Phone: "..tostring(lastForm.phone), xUnit*3*1.1, yUnit * 4,500, 500)
  text.print(gfx.screen, arial, "Email: "..tostring(lastForm.email), xUnit*3*1.1, yUnit * 4.5,500, 50)
  text.print(gfx.screen, arial, "Pizzeria: "..tostring(lastForm.pizzeria), xUnit*3*1.1, yUnit * 5,500, 50)
  local pizzaText = ""
  for i=1,#lastForm.pizzeria.pizza do
    pizzaText = pizzaText..lastForm.pizzeria.pizza[i].name..", "
  end
  text.print(gfx.screen, arial, "Pizzas: "..tostring(pizzaText), xUnit*3*1.1, yUnit * 5.5,500, 50)

end

function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'yellow') then
	  		--Save account and go to menu
        pathName = "Menu.lua"
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
      elseif(key == 'red') then
        --Go back to menu
        pathName = "RegistrationStep3.lua"
        if checkTestMode() then
          return pathName
        else
          assert(loadfile(pathName))(lastForm)
        end
	  	end
	end
end

--Main method
function main()
	buildGUI()
end
main()





