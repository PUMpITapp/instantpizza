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

--Form from earlier step
local lastForm = ...

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9
local startPosY = yUnit * 2.8
local startPosX = xUnit*3.40
local background = gfx.loadpng("Images/UserRegistrationPics/registrationreview.png")

--Create new pizzeria. Each pizzeria object has one table of pizzas. 
Pizzeria = {}
function Pizzeria:new(name,imgPath,rating,pizzas,drink)
  newObj = {
  id = id,
  name = name,
  imgPath = imgPath,
  rating = rating,
  pizzas = pizzas,
  drink = drink
  }
  self.__index = self
  return setmetatable(newObj, self)
end
--Create pizza
Pizza = {}
function Pizza:new(name,price)
  newObj = {
  name = name,
  price = price
  }
  self.__index = self
  return setmetatable(newObj, self)
end
--Create drinks
Drink = {}
function Drink:new(name,price)
  newObj = {
  name = name,
  price = price
  }
  self.__index = self
  return setmetatable(newObj, self)
end

--Calls methods that builds GUI
function buildGUI()
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
displayHighlightSurface()
gfx.update()
end

--Creates inputsurface and displays "highlighted" input
function displayHighlightSurface()
  if checkTestMode() then
  else
    text.print(gfx.screen,"lato","black","small", "Name: "..tostring(lastForm.name), startPosX, startPosY, 500, 500)
    text.print(gfx.screen,"lato","black","small", "Address: "..tostring(lastForm.address), startPosX,startPosY+(yUnit*0.5),500,500)
    text.print(gfx.screen,"lato","black","small", "ZipCode: "..tostring(lastForm.zipCode), startPosX,startPosY+(yUnit*1),500,500)
    text.print(gfx.screen,"lato","black","small", "City: "..tostring(lastForm.city), startPosX,startPosY+(yUnit*1.5),500, 500)
    text.print(gfx.screen,"lato","black","small", "Phone: "..tostring(lastForm.phone), startPosX,startPosY+(yUnit*2) ,500, 500)
    text.print(gfx.screen,"lato","black","small", "Email: "..tostring(lastForm.email), startPosX,startPosY+(yUnit*2.5),500, 50)
    text.print(gfx.screen,"lato","black","small", "Pizzeria: "..tostring(lastForm.pizzeria.name), startPosX,startPosY+(yUnit*3),500, 50)
    local pizzaText = ""
    for i=1,#lastForm.pizzeria.pizza do
      length = #lastForm.pizzeria.pizza
      if(length == i)then
        pizzaText = pizzaText.." "..lastForm.pizzeria.pizza[i].name
      else
      pizzaText = pizzaText..lastForm.pizzeria.pizza[i].name..", "
      end
    end

    text.print(gfx.screen,"lato","black","small", "Pizzas: "..tostring(pizzaText), startPosX,startPosY+(yUnit*3.5),500, 50)
  end

end

function saveAccount()
  if checkTestMode then
  else
    account = lastForm
    pizzas = {}
    for i=1,#lastForm.pizzeria.pizza do
      name = lastForm.pizzeria.pizza[i].name
      price = lastForm.pizzeria.pizza[i].price
      pizzas[i] = Pizza:new(name,price)
    end
    drinks = {}
    drink = Drink:new("Coca cola","10")
    drinks[1] = drink
    pizzeria = Pizzeria:new(account.pizzeria.name,account.pizzeria.imgPath,account.pizzeria.rating,pizzas,drinks)
    io.saveUserData(account.name,account.address,account.zipCode,account.city,account.phone,account.email,pizzeria)
  end
end

function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'yellow') then
	  		--Save account and go to menu
        saveAccount()
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





