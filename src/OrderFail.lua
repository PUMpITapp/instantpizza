--- Set if the program is running on the box or not
local onBox = true

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


if onBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/OrderPics/?.png'
  dir = sys.root_path()

else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
end

--- Chooses either the actual or the dummy gfx.
-- @return #string tempGfx Returns dummy gfx if the file is being tested, returns actual gfx if the file is being run.
function chooseText()
  if not checkTestMode() then
    tempText = require "write_text"
  elseif checkTestMode() then
    tempText = require "write_text_stub"
  end
  return tempText
end

local text = chooseText()

local qrencode = dofile(dir .. "qrencode.lua")

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

local startPosY = yUnit * 3
local startPosX = xUnit * 3

local textPosX = 8.2* xUnit
local textPosY = 3.2 * yUnit

local stringToQR =""
local qrCode = nil

local newOrder = ...

---Builds GUI
function buildGUI()
  displayBackground()
  displayQR()
  displayText()
end

--- Function that displays the Background image of the application
function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/OrderPics/orderNoNetwork.png") 
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
end

--- Function that generates a string to be used when creating the QR-code
function generateOrder()
  if checkTestMode() then
  else

    stringToQR = "Customer: "..newOrder.name.."\nAddress: "..newOrder.address.."\nZip: "..newOrder.zipCode.."\nPhone: "..newOrder.phone.."\n\n"
    for i = 1, #newOrder.order do
      for key,value in pairs(newOrder.order[i])do
        stringToQR = stringToQR..value.amount.."x "..value.name.."\n"
      end
    end
  end
end

--- Function that creates a QR-code from the string created in generateOrder()
-- @return #QR qeCode The generated QR-code
function generateQR()
  local ok, qrCode = qrencode.qrcode(stringToQR)
  if not ok then
      print(qrCode)
  end
  return qrCode
end
--- Function that displays the QR code on the Screen
function displayQR()
  local i = 1
  local j = 1
  local bitSizeX = math.ceil(4 * xUnit / #qrCode)
  local bitSizeY = math.ceil(4 * xUnit / #qrCode)
  local qrSurface = gfx.new_surface(bitSizeX, bitSizeY)

  for k,v in pairs(qrCode) do

    for key, value in pairs(v)do
      -- print(key,value)
      if(value >0) then
        qrSurface:fill({0,0,0,255})
        gfx.screen:copyfrom(qrSurface,nil,{x =startPosX+ i * bitSizeX, y = startPosY+j * bitSizeY, w = bitSizeX, h = bitSizeY})

      elseif(value<0) then
        qrSurface:fill({255,255,255,255})
        gfx.screen:copyfrom(qrSurface,nil,{x =startPosX +i * bitSizeX, y = startPosY+j * bitSizeY, w = bitSizeX, h = bitSizeY})

      end
      i = i + 1
    end
    i =1
    j = j + 1
  end
  qrSurface:destroy()
end

--- Function that displays an explaining text to the user about the QR-code
function displayText()
  if checkTestMode() then
  else
    text.print(gfx.screen, "lato","black","small", "There seems to be a problem with your internet connection.",textPosX,textPosY,9 *xUnit, 1 *yUnit)
    text.print(gfx.screen, "lato","black","small", "Do not worry, your order is saved as a QR-code on the left.",textPosX,textPosY + 0.5 *yUnit,9 *xUnit, 1 *yUnit)
    text.print(gfx.screen, "lato","black","small", "Please scan the QR-code and send it to:",textPosX,textPosY + yUnit,9 *xUnit, 1 *yUnit)
    text.print(gfx.screen, "lato","black","medium", newOrder.pizzeria.name..":",textPosX,textPosY + 2 *yUnit,9 *xUnit, 1 *yUnit)
    text.print(gfx.screen, "lato","black","medium", newOrder.pizzeria.phoneNr, textPosX,textPosY + 2.5 *yUnit,9 *xUnit, 1 *yUnit)
  end
end

--- Gets input from user and re-directs according to input
-- @param #string key The key that has been pressed
-- @param #string state The state of the key-press
-- @return #String pathName The path that the program shall be directed to
function onKey(key,state)
	if(state == 'up') then

      if(key == 'green') then
        --Go back to menu
        pathName =dir.. "Menu.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
	  	end
	end
end

--- Function that that updates the current screen to be able to show new or changed information to the user
function updateScreen()
  buildGUI()
  gfx.update()
end

--Main method
function onStart()
  generateOrder()
  qrCode = generateQR()
	updateScreen()
end
onStart()


