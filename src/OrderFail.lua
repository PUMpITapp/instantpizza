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

local qrencode = dofile("qrencode.lua")

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

local startPosY = yUnit * 3
local startPosX = xUnit * 3

local textPosX = 8.2* xUnit
local textPosY = 3.2 * yUnit

local marginY = yUnit / 2
local marginX = xUnit * 4

local stringToQR ="Huy Tran\nvallavägen 6.210\nbella\n+kebabsås\n+loka"
local qrCode = nil

local qrSurface = gfx.new_surface(xUnit, yUnit)
local background = gfx.loadpng("Images/OrderPics/orderNoNetwork.png") 
local order = ...

--Calls methods that builds GUI
function buildGUI()
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
displayQR()
displayText()
end

function generateOrder()
  if checkTestMode() then
  else
    stringToQR = order.name.."\n"..order.address.."\n"..order.phone.."\n"..order.email.."\n"
    for key, value in pairs(order.pizzas) do
      stringToQR = stringToQR..value.amount.."x "..value.name.."\n"
    end
    for key, value in pairs(order.drinks) do
      stringToQR = stringToQR..value.amount.."x "..value.name.."\n"
    end
    for key, value in pairs(order.sauces) do
      stringToQR = stringToQR..value.amount.."x "..value.name.."\n"
    end
    for key, value in pairs(order.salads) do
      stringToQR = stringToQR..value.amount.."x "..value.name.."\n"
    end
  end
end

function generateQR()
  local ok, qrCode = qrencode.qrcode(stringToQR)
  if not ok then
      print(qrCode)
  end
  return qrCode
end

function displayQR()
  local i = 1
  local j = 1
  local bitSizeX = math.floor(4 * xUnit / #qrCode)
  local bitSizeY = math.floor(4 * yUnit / #qrCode)

for k,v in pairs(qrCode) do

  for key, value in pairs(v)do
    -- print(key,value)
    if(value >0) then
      qrSurface:fill({0,0,0,0})
      gfx.screen:copyfrom(qrSurface,nil,{x =startPosX+ i * bitSizeX, y = startPosY+j * bitSizeY, w = bitSizeX, h = bitSizeY})

    elseif(value<0) then
      qrSurface:fill({255,255,255,0})
      gfx.screen:copyfrom(qrSurface,nil,{x =startPosX +i * bitSizeX, y = startPosY+j * bitSizeY, w = bitSizeX, h = bitSizeY})

    end
    i = i + 1
  end
  i =1
  j = j + 1
end
end
function displayText()
  if checkTestMode() then
  else
    text.print(gfx.screen, "lato","black","small", "There seems to be a problem with your internet connection.",textPosX,textPosY,9 *xUnit, 1 *yUnit)
    text.print(gfx.screen, "lato","black","small", "Do not worry, your order is saved as a QR-code on the left.",textPosX,textPosY + 0.5 *yUnit,9 *xUnit, 1 *yUnit)
    text.print(gfx.screen, "lato","black","small", "Please scan the QR-code and send it to:",textPosX,textPosY + yUnit,9 *xUnit, 1 *yUnit)
    text.print(gfx.screen, "lato","black","medium", order.pizzeria.name..":",textPosX,textPosY + 2 *yUnit,9 *xUnit, 1 *yUnit)
    text.print(gfx.screen, "lato","black","medium", "0705834633",textPosX,textPosY + 2.5 *yUnit,9 *xUnit, 1 *yUnit)
  end
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
function updateScreen()
  buildGUI()
  gfx.update()
end
--Main method
function main()
  generateOrder()
  qrCode = generateQR()
	updateScreen()
end
main()


