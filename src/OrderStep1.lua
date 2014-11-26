local onBox = false
progress = "OrdeSte"

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


if onBox == true then
  progress = "loadingPackages..."
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/OrderPics/?.png'
  dir = sys.root_path()

else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
end


function chooseText()
  if not checkTestMode() then
    tempText = require "write_text"
  elseif checkTestMode() then
    tempText = require "write_text_stub"
  end
  return tempText
end
progress = "loadText..."
local text = chooseText()
progress = "loadIOHANDLER..."
local io = require "IOHandler"
progress = "loadIOHandler:DONE"


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
local noOfPages = 0
local currentPage = 1
local startingIndex = 1

local tempCopy = nil
local tempCoord = {}



dofile(dir .. "table.save.lua")

function readUsers()
  progress = "readUsers..."
  userTable = io.readUserData()
  if userTable == nil then
  end
  progress = "readUsers:DONE"
end

function getNoOfPages()
  noOfPages = math.ceil(#userTable/4)
end

function changeCurrentPage(key)
  if(key == 'left')then
    if(currentPage > 1)then
      currentPage = currentPage -1
      startingIndex = startingIndex-4
      displayUsers()
    end
  elseif (key == 'right')then
    if(currentPage < noOfPages)then
      currentPage=currentPage+1
      startingIndex = startingIndex+4  
      displayUsers()
    end
  end
  highlightPosY = 1
  updateScreen()
end

function displayUsers()
  progress = "displayUsers..."
  local yCoord = startPosY
  local accountTile = gfx.loadpng("Images/OrderPics/inputfield.png")
  upperBoundary = 0
  accountTile:premultiply()
  text.print(gfx.screen,"lato","black","small",tostring("Page: "..currentPage.."/"..noOfPages), startPosX*2.78, yCoord*2.85, xUnit*7, yUnit)
  if not (userTable == nil) then
    for index = startingIndex, #userTable do
      gfx.screen:copyfrom(accountTile,nil,{x=startPosX, y=yCoord, h=yUnit, w=xUnit*7},true)
      text.print(gfx.screen,"lato","black","medium",tostring(userTable[index].email), startPosX*1.04, yCoord+marginY*0.2, xUnit*7, yUnit)
      upperBoundary = upperBoundary + 1
      yCoord = yCoord+marginY
      if(index == startingIndex+3)then
          break
      end
    end
  else
    text.print(gfx.screen,"lato","black","medium","No users registered!", startPosX*1.3, yCoord+marginY*0.2, xUnit*7, yUnit)
  end
  accountTile:destroy()
  progress = "displayUsers:DONE"
end

function displayArrows()
  --Bilder
  if(noOfPages > 1 and currentPage < noOfPages)then
      local rightArrow = gfx.loadpng("Images/PizzaPics/rightarrow.png")
      rightArrow:premultiply()
      gfx.screen:copyfrom(rightArrow, nil, {x = xUnit*14.5, y= yUnit*4, w = xUnit*1 , h =yUnit*2})
      rightArrow:destroy()
  end
  if(currentPage > 1)then
    local leftArrow = gfx.loadpng("Images/PizzaPics/leftarrow.png")
    leftArrow:premultiply()
    gfx.screen:copyfrom(leftArrow, nil, {x = xUnit*0.35, y= yUnit*4, w = xUnit*1 , h =yUnit*2})
    leftArrow:destroy()
  end
end

function getUser()
  progress = "getUser..."
  userIndex = (4*(currentPage-1)+highlightPosY)
  account = userTable[userIndex]
  print(account.email)
  return account
end

function displayHighlighter()
  progress = "displayHighlighter..."
  if(upperBoundary >0)then
    local highlightTile = gfx.loadpng("Images/OrderPics/highlighter.png")
    highlightTile:premultiply()
    
    local coord = {x = startPosX, y= startPosY + (highlightPosY - 1) * marginY, w = xUnit*9 , h =yUnit}
    
    if tempCopy == nil then
      tempCopy = gfx.new_surface(coord.w, coord.h)
      tempCopy:copyfrom(gfx.screen,coord,coord)
      tempCoord = coord
    else
      gfx.screen:copyfrom(tempCopy,tempCoord,tempCoord,true)
      tempCopy:copyfrom(gfx.screen,coord,coord)
      tempCoord = coord
    end
    
      gfx.screen:copyfrom(highlightTile, nil, coord ,true)
      highlightTile:destroy()
  end
  progress = "displayHighlighter:DONE"
end
--Calls methods that builds GUI
function buildGUI()
  progress = "buildGUI..."
  displayBackground()
  displayUsers()
  displayHighlighter()
  displayArrows()
  progress = "buildGUI:DONE"
end

function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/OrderPics/chooseaccount.png")  
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
end

function destroyTempSurfaces()
  tempCopy:destroy()
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
      if checkTestMode() then
        return key
      end
      moveHighlightedInputField(key)
    elseif(key == 'down')then
      if checkTestMode() then
        return key
      end
      moveHighlightedInputField(key)
      elseif(key == 'left')then
      if checkTestMode() then
        return key
      end
      changeCurrentPage(key)
      elseif(key == 'right')then
      if checkTestMode() then
        return key
      end
      changeCurrentPage(key)
    elseif(key == 'ok') then
      pathName = dir.. "OrderStep2.lua"
      if checkTestMode() then
        return pathName
      else

        account = getUser()
        destroyTempSurfaces()
        assert(loadfile(pathName))(account)
      end
    elseif(key == 'green') then
      --Go back to menu
      pathName = dir .. "Menu.lua"
      if checkTestMode() then
        return pathName
      else
        destroyTempSurfaces()
        dofile(pathName)
      end
    end
  end
end

-- This functions returns some of the values on local variables to be used when testing
function returnValuesForTesting(value)

  if value == "startPosY" then
    return startPosY
  elseif value == "highlightPosY" then 
    return highlightPosY
  elseif value == "upperBoundary" then
    return upperBoundary
  elseif value == "lowerBoundary" then
    return lowerBoundary
  end
end
-- This function is used in testing when it is needed to set the value of highlightPosY to a certain number
function setValuesForTesting(value)
  highlightPosY = value
end

--Main method
function onStart()
  progress = "readUsers..."
  readUsers()
  getNoOfPages()
  progress = "updateScreen..."
  updateScreen()
end
onStart()





