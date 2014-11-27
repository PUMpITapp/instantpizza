local onBox = true
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

if onBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/UserRegistrationPics/?.png'
  dir = sys.root_path()

else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
end

local text = chooseText()

local io = require "IOHandler"

--Form from earlier step
local lastForm = ...
local newForm = {}

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9
local startPosY = yUnit * 2.8
local startPosX = xUnit*3.40

function checkForm()
  if type(lastForm) == "string" then

  else
    if lastForm then
      newForm = lastForm
    end
  end
end

--Calls methods that builds GUI
function buildGUI()
  displayBackground()
  displayHighlightSurface()
  gfx.update()
end

function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/UserRegistrationPics/registrationreview.png")
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
end

--Creates inputsurface and displays "highlighted" input
function displayHighlightSurface()
  if checkTestMode() then
  else
    text.print(gfx.screen,"lato","black","small", "Name: "..tostring(newForm.name), startPosX, startPosY, 500, 500)
    text.print(gfx.screen,"lato","black","small", "Address: "..tostring(newForm.address), startPosX,startPosY+(yUnit*0.5),500,500)
    text.print(gfx.screen,"lato","black","small", "ZipCode: "..tostring(newForm.zipCode), startPosX,startPosY+(yUnit*1),500,500)
    text.print(gfx.screen,"lato","black","small", "City: "..tostring(newForm.city), startPosX,startPosY+(yUnit*1.5),500, 500)
    text.print(gfx.screen,"lato","black","small", "Phone: "..tostring(newForm.phone), startPosX,startPosY+(yUnit*2) ,500, 500)
    text.print(gfx.screen,"lato","black","small", "Email: "..tostring(newForm.email), startPosX,startPosY+(yUnit*2.5),500, 50)
    text.print(gfx.screen,"lato","black","small", "Pizzeria: "..tostring(newForm.pizzeria.name), startPosX,startPosY+(yUnit*3),500, 50)
    local pizzaText = ""
    for i=1,#newForm.pizzeria.userPizzas do
      length = #newForm.pizzeria.userPizzas
      if(length == i)then
        pizzaText = pizzaText.." "..newForm.pizzeria.userPizzas[i].name
      else
      pizzaText = pizzaText..newForm.pizzeria.userPizzas[i].name..", "
      end
    end

    text.print(gfx.screen,"lato","black","small", "Pizzas: "..tostring(pizzaText), startPosX,startPosY+(yUnit*3.5),500, 50)
  end

end

function saveAccount()
  newForm.pizzeria.pizzas = newForm.pizzeria.userPizzas
  newForm.pizzeria.userPizzas = nil
  if not(newForm.editMode == nil)then
    io.updateUser(newForm)
  else
    io.saveUserData(newForm)
  end
end

function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'yellow') then
	  		--Save account and go to menu
        saveAccount()
        pathName = dir .. "Menu.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
      elseif(key == 'green') then
        --Go back to menu
        pathName = dir .. "Menu.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
      elseif(key == 'red') then
        --Go back to menu
        pathName = dir .. "RegistrationStep3.lua"
        if checkTestMode() then
          return pathName
        else
          assert(loadfile(pathName))(lastForm)
        end
	  	end
	end
end

--Main method
function onStart()
  checkForm()
	buildGUI()
end
onStart()





