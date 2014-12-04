local onBox = true

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

if onBox == true then
  progress = "loadingPics..."
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/UserPage/?.png'
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/OrderPics/?.png'
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/PizzaPics/?.png'
  dir = sys.root_path()
else
gfx = chooseGfx(checkTestMode())
    sys = {}
    sys.root_path = function () return '' end
    dir = ""
end

local io = require "IOHandler"




local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

local tempCopy = nil
local tempCoord = {}

--2.3 13.8 
local startPosY = yUnit*2.5
--Rutan startposition är 2.3. För att centrera inputfield 2.3+2.25. 
local startPosX = xUnit*3.2
local marginY = yUnit*1.2
local highlightPosY = 1

local lowerBoundary = 1
local upperBoundary = 0
local inputFieldEnd = 0
local noOfPages = 0
local currentPage = 1
local startingIndex = 1
local lastPage = 0
local deletedElement = false
local deleteMode = false

dofile(dir.."table.save.lua")

function readUsers()
  userTable = io.readUserData()
  noOfPages = math.ceil(#userTable/4)
  if userTable == nil then
  end
end

function getNoOfPages()
  noOfPages = math.ceil(#userTable/4)
end

function changeCurrentPage(key)
  if(key == 'left')then
    if(currentPage > 1)then
      currentPage = currentPage -1
      startingIndex = startingIndex-4
    end
  elseif (key == 'right')then
    if(currentPage < noOfPages)then
      currentPage=currentPage+1
      startingIndex = startingIndex+4  
    end
  end
  highlightPosY = 1
  updateScreen()
end

function displayUsers()
  foundUsers = false
  yCoord = startPosY
  upperBoundary = 0
  text.print(gfx.screen,"lato","black","small",tostring("Page: "..currentPage.."/"..noOfPages), startPosX*3.94, yCoord*2.85, xUnit*7, yUnit)
  if not (userTable == nil)then
    if not (#userTable == 0) then
    local accountTile = gfx.loadpng("Images/OrderPics/inputfield.png")
    accountTile:premultiply()
      for index = startingIndex, #userTable do
        gfx.screen:copyfrom(accountTile,nil,{x=startPosX, y=yCoord, h=yUnit, w=xUnit*7},true)
        text.print(gfx.screen,"lato","black","medium",tostring(userTable[index].email), startPosX*1.04, yCoord+marginY*0.2, xUnit*7, yUnit)
        yCoord = yCoord+marginY
        upperBoundary = upperBoundary+1
        foundUsers = true
        if(index == startingIndex+3)then
          break
        end
      end
      accountTile:destroy()
    end
  end
  if(foundUsers==false)then
    text.print(gfx.screen,"lato","black","medium","No users registered!", startPosX*1.9, yCoord+marginY*0.2, xUnit*7, yUnit)
  end
end

function getUser()
  userIndex = (4*(currentPage-1)+highlightPosY)
  user = userTable[userIndex]
  user["editMode"] = "true"
  user["editIndex"] = userIndex
  return user
end

function displayArrows()
  if(noOfPages > 1 and currentPage < noOfPages)then
    local rightArrow = gfx.loadpng("Images/PizzaPics/rightarrow.png")
    rightArrow:premultiply()  
    gfx.screen:copyfrom(rightArrow, nil, {x = xUnit*14.7, y= yUnit*4, w = xUnit*1 , h =yUnit*2},true)
    rightArrow:destroy()
  end
  if(currentPage > 1)then
    local leftArrow = gfx.loadpng("Images/PizzaPics/leftarrow.png")
    leftArrow:premultiply()
    gfx.screen:copyfrom(leftArrow, nil, {x = xUnit*0.35, y= yUnit*4, w = xUnit*1 , h =yUnit*2},true)
    leftArrow:destroy()
  end
end



function displayHighlighter()

  if(upperBoundary >0)then
    
    local highlightTile = gfx.loadpng("Images/UserPage/userpressed.png")
    highlightTile:premultiply()
    local coord = {x = startPosX, y= startPosY + (highlightPosY - 1) * marginY, w = xUnit*10 , h =yUnit}
    
    if tempCopy == nil then
      tempCopy = gfx.new_surface(coord.w, coord.h)
      tempCopy:copyfrom(gfx.screen,coord,nil)
      tempCoord = coord
      lastPage = currentPage
    elseif lastPage == currentPage then
      gfx.screen:copyfrom(tempCopy, nil,tempCoord,true)
      tempCopy:copyfrom(gfx.screen,coord,nil)
      tempCoord = coord
    else
      tempCopy:copyfrom(gfx.screen,coord,nil)
      tempCoord = coord
      lastPage = currentPage
    end

    gfx.screen:copyfrom(highlightTile, nil, coord,true)
    highlightTile:destroy()
  end

end
--Calls methods that builds GUI
function buildGUI()
  displayBackground()
  getNoOfPages()
  displayUsers()
  displayHighlighter()
  displayArrows()
end

function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/UserPage/manageaccount.png") 
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
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
  displayHighlighter()
  gfx.update()
end

function updateScreen()
  buildGUI()
  gfx.update()
end

function showConfirmDelete()
  print("Hej")
  local confirm = gfx.loadpng("Images/UserPage/notifydelete.png") 
  confirm:premultiply()
  gfx.screen:copyfrom(confirm, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  confirm:destroy()
  deleteMode = true
  gfx.update()
end
function deleteUser()
  removeIndex = (4*(currentPage-1)+highlightPosY)
  table.remove(userTable,removeIndex)
  io.saveUserTable(userTable)
  currentPage = 1
  startingIndex = 1
  tempCopy = nil
  highlightPosY = 1
  updateScreen()
end

function destroyTempSurfaces()
  if tempCopy ~= nil then
    tempCopy:destroy()
  end
end

function onKey(key,state)
	if(state == 'up') then
    if(key == 'up')then
      if checkTestMode() then
        return key
      end
      if not deleteMode then
      moveHighlightedInputField(key)
      end
    elseif(key == 'down')then
      if checkTestMode() then
        return key
      end
      if not deleteMode then
      moveHighlightedInputField(key)
      end
    elseif(key == 'left')then
      if checkTestMode() then
        return key
      end
      if not deleteMode then
      changeCurrentPage(key)
      end
      elseif(key == 'right')then
      if checkTestMode() then
        return key
      end
      changeCurrentPage(key)
    elseif(key == 'green') then
      --Go back to menu
      pathName = dir .. "Menu.lua"
        print(pathName)

      if checkTestMode() then
        return pathName
      else
        destroyTempSurfaces()
        dofile(pathName)
      end
      elseif(key == 'blue') then
      pathName = dir .. "RegistrationStep1.lua"
      if checkTestMode() then
        return pathName
      else
        if(deleteMode)then
          updateScreen()
          deleteMode = false
        else
        destroyTempSurfaces()
        dofile(pathName)
        end
      end
    elseif(key == 'yellow') then
      pathName = dir .. "RegistrationStep1.lua"
      if checkTestMode() then
        return pathName
      else
        if(deleteMode)then
          deleteUser()
          deleteMode = false
        else
        newForm = getUser()
        destroyTempSurfaces()
        assert(loadfile(pathName))(newForm)
        end
      end
      elseif(key == 'red') then
        showConfirmDelete()
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
  print(deleteMode)
  readUsers()
  updateScreen()
end
onStart()





