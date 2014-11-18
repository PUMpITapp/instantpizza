local gfx = require "gfx"
local qrencode = dofile("qrencode.lua")
local text = require "write_text"

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

local startPosY = yUnit * 3
local startPosX = xUnit * 3

local textPosX = 7* xUnit
local textPosY = 3 * yUnit

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
  text.print(gfx.screen, arial, "Step1: Pick up your phone",textPosX,textPosY,9 *xUnit, 1 *yUnit)
  text.print(gfx.screen, arial, "Step2: Use QR camera to take picture",textPosX,textPosY + 0.5 *yUnit,9 *xUnit, 1 *yUnit)
  text.print(gfx.screen, arial, "Step3: Send QR-code as message",textPosX,textPosY + yUnit,9 *xUnit, 1 *yUnit)
  text.print(gfx.screen, arial, "       to this number ",textPosX,textPosY + 1.5 *yUnit,9 *xUnit, 1 *yUnit)

end

function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'red') then
	  		--Choose account and go to next step
        pathName = "OrderStep2.lua"
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
      elseif(key == 'yellow') then
        --Go back to menu
        pathName = "OrderStep4.lua"
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


