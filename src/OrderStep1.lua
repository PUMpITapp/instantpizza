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
local io = require "IOHandler"
local text = chooseText(checkTestMode())
local gfx =  chooseGfx(checkTestMode())

local background = gfx.loadpng("Images/OrderPics/chooseaccount.png") 
local accountTile = gfx.loadpng("Images/OrderPics/inputfield.png")
local highlightTile = gfx.loadpng("Images/OrderPics/highlighter.png")

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

--2.3 13.8 
local startPosY = yUnit*2.5
--Rutan startposition är 2.3. För att centrera inputfield 2.3+2.25. 
local startPosX = xUnit*4.55
local marginY = yUnit*1.2
local highlightPosY = 1

local lowerBoundary = 1
local upperBoundary = 0
local inputFieldEnd = 0

dofile("table.save.lua")

function readUsers()
  userTable = io.readUserData()
end

function displayUsers()
  yCoord = startPosY
  for index,v in ipairs(userTable)do
    gfx.screen:copyfrom(accountTile,nil,{x=startPosX, y=yCoord, h=yUnit, w=xUnit*7})
    text.print(gfx.screen, arial,tostring(userTable[index].email), startPosX*1.02, yCoord+marginY*0.2, xUnit*7, yUnit)
    upperBoundary = index
    yCoord = yCoord+marginY
    if(index == 4)then
      break
    end
  end
end

function getUser()
  account = userTable[highlightPosY]
  return account
end

function displayHighlighter()
  gfx.screen:copyfrom(highlightTile, nil, {x = startPosX, y= startPosY + (highlightPosY - 1) * marginY, w = xUnit*9 , h =yUnit})
end
--Calls methods that builds GUI
function buildGUI()
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
displayUsers()
displayHighlighter()
end

function moveHighlightedInputField(key)
  --Starting coordinates for current inputField
  if(key == 'up')then
    highlightPosY = highlightPosY - 1

    if(highlightPosY < lowerBoundary) then
      highlightPosY = upperBoundary
    end
  --Down
  elseif(key == 'down')then
    highlightPosY = highlightPosY + 1
    if(highlightPosY > upperBoundary) then
      highlightPosY = 1
    end
end
updateScreen()
end

function updateScreen()
  buildGUI()
  gfx.update()
end

function onKey(key,state)
	if(state == 'up') then
    if(key == 'up')then
      moveHighlightedInputField(key)
    elseif(key == 'down')then
      moveHighlightedInputField(key)
	  elseif(key == 'ok') then
      pathName = "OrderStep2.lua"
      if checkTestMode() then
        return pathName
      else
        account = getUser()
        assert(loadfile(pathName))(account)
      end
    elseif(key == 'green') then
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

--Main method
function main()
  readUsers()
	updateScreen()
end
main()





