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
local accountTile = gfx.loadpng("Images/OrderPics/accounttile.png")
local highlightTile = gfx.loadpng("Images/OrderPics/acconttilepressed.png")

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

local inputMovement = yUnit*1
local inputFieldX = gfx.screen:get_width()/8
local inputFieldY = yUnit*2.5
local inputFieldStart = yUnit*2.5
local inputFieldEnd = 0
local highlightFieldPos = 0

--Start of inputFields.
inputFieldStart = gfx.screen:get_height()*(2.5/9)
inputFieldY = gfx.screen:get_height()*(2.5/9)
inputFieldEnd = inputFieldStart + gfx.screen:get_height()*(0.7/9)*5
index = 0

dofile("table.save.lua")

function readUsers()
  io.addTestUser()
  userTable = io.readUserData()
  for i,v in pairs(userTable)do
    print(i,v)
  end
end

function displayUsers()
  yCoord = inputFieldStart
  for index,v in ipairs(userTable)do
    gfx.screen:copyfrom(accountTile,nil,{x=xUnit*3, y=yCoord, h=xUnit*0.7, w=yUnit*7})
    text.print(gfx.screen, arial,tostring(userTable[index].email), xUnit*3.1, yCoord, xUnit*7, yUnit)
    print("Test"..index,v)
    yCoord = yCoord+inputMovement
  end
  inputFieldEnd = yCoord-inputMovement
end

function getUser()
  account = userTable[highlightFieldPos]
  return account
end

function displayHighlighInput()
  gfx.screen:copyfrom(highlightTile,nil,{x=xUnit*3, y=inputFieldY, h=xUnit*0.7, w=yUnit*10})
end
--Calls methods that builds GUI
function buildGUI()
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
displayUsers()
displayHighlighInput()
gfx.update()
end

function moveHighlightedInputField(key)
  --Starting coordinates for current inputField
  if(key == 'Up') then
    if(inputFieldY > inputFieldStart) then
      inputFieldY = inputFieldY - inputMovement
      highlightFieldPos = highlightFieldPos -1
    end
  end
  --Down
  if(key == 'Down') then
    if(inputFieldY < inputFieldEnd)then
      inputFieldY = inputFieldY + inputMovement
      highlightFieldPos = highlightFieldPos + 1
    
    elseif(inputFieldY == inputFieldEnd) then
      inputFieldY = inputFieldStart
      highlightFieldPos = 1
    end
  end
  buildGUI()
end

function onKey(key,state)
	if(state == 'up') then
    if(key == 'Up')then
      moveHighlightedInputField(key)
    elseif(key == 'Down')then
      moveHighlightedInputField(key)
	  elseif(key == 'Return') then
	  	--Choose account and go to next step

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
	buildGUI()
end
main()





