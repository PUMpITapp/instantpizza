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

--- Chooses the text
-- @return #string tempText Returns write_text_stub if the file is being tested, returns actual write_text if the file is being run.
function chooseText()
  if not checkTestMode() then
    tempText = require "write_text"
  elseif checkTestMode() then
    tempText = require "write_text_stub"
  end
  return tempText
end

--- Change the path system if the app runs on the box comparing to the emulator
if onBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/OrderPics/?.png'
  dir = sys.root_path()
else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
end

--- Variable to use when handling tables that are stored in the system
local io = require "IOHandler"

--- Variable to use when displaying printed text on the screen
--- Determine whether to use the stub or to run the actual file
local text = chooseText()

--- Declare units in variables
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

--- Start of inputFields
local startPosY = yUnit*2.5
local startPosX = xUnit*4.55

--- End of inputFields
local inputFieldEnd = 0

--- Define the starting position of the highlight input field and the space between fields
local marginY = yUnit*1.2
local highlightPosY = 1

--- Declare the boundary levels for the input field set
local lowerBoundary = 1
local upperBoundary = 0

--- Page counter variables to display a varying number of pizza pages depending on the number of pizzas
local noOfPages = 0
local currentPage = 1
local startingIndex = 1
local lastPage = currentPage

--- Variables to save the content of a certain field to display it again after highlighted
--- Used for memory optimization
local tempCopy = nil
local tempCoord = {}

dofile(dir .. "table.save.lua")

--- Fetches the users and puts it in a table
function readUsers()
  userTable = io.readUserData()
  if userTable == nil then
  end
end

--- Function that determines total number of pages with users
function getNoOfPages()
  noOfPages = math.ceil(#userTable/4)
end

--- Changes to the next or previous page of users to display
-- @param #string key The key that has been pressed
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

--- Display the users on the screen
function displayUsers()
  local yCoord = startPosY
  local accountTile = gfx.loadpng("Images/OrderPics/inputfield.png")
  upperBoundary = 0
  accountTile:premultiply()
  text.print(gfx.screen,"lato","black","small",tostring("Page: "..currentPage.."/"..noOfPages), startPosX*2.78, yCoord*2.85, xUnit*7, yUnit)
  if not (userTable == nil) then
    -- Loops through all users that shall be displayed
    for index = startingIndex, #userTable do
      gfx.screen:copyfrom(accountTile,nil,{x=startPosX, y=yCoord, h=yUnit, w=xUnit*7},true)
      text.print(gfx.screen,"lato","black","medium",tostring(userTable[index].email), startPosX*1.04, yCoord+marginY*0.2, xUnit*7, yUnit)
      upperBoundary = upperBoundary + 1
      yCoord = yCoord+marginY
      -- Stop displaying when the maximum number of users is shown
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

--- Function that determines which arrows that shall be shown depending on the current page of users
function displayArrows()
  if(noOfPages > 1 and currentPage < noOfPages)then
      local rightArrow = gfx.loadpng("Images/PizzaPics/rightarrow.png")
      rightArrow:premultiply()
      gfx.screen:copyfrom(rightArrow, nil, {x = xUnit*14.5, y= yUnit*4, w = xUnit*1 , h =yUnit*2},true)
      rightArrow:destroy()
  end
  if(currentPage > 1)then
    local leftArrow = gfx.loadpng("Images/PizzaPics/leftarrow.png")
    leftArrow:premultiply()
    gfx.screen:copyfrom(leftArrow, nil, {x = xUnit*0.35, y= yUnit*4, w = xUnit*1 , h =yUnit*2},true)
    leftArrow:destroy()
  end
end

--- Function that interprets the coordinate position and translates it to a user
-- @return #table account Returns which account that corresponds to the coordinates highlighted
function getUser()
  userIndex = (4*(currentPage-1)+highlightPosY)
  account = userTable[userIndex]
  return account
end

--- Displays the highlighter that highlights different choices
function displayHighlighter()
  if(upperBoundary >0)then
    local highlightTile = gfx.loadpng("Images/OrderPics/highlighter.png")
    highlightTile:premultiply()    
    local coord = {x = startPosX, y= startPosY + (highlightPosY - 1) * marginY, w = xUnit*9 , h =yUnit}
    
    if tempCopy == nil then
      tempCopy = gfx.new_surface(coord.w, coord.h)
      tempCopy:copyfrom(gfx.screen,coord,nil)
      tempCoord = coord
    elseif lastPage == currentPage then
      gfx.screen:copyfrom(tempCopy, nil,tempCoord,true)
      tempCopy:copyfrom(gfx.screen,coord,nil)
      tempCoord = coord
    else
      tempCopy:copyfrom(gfx.screen,coord,nil)
      tempCoord = coord
      lastPage = currentPage
    end
      gfx.screen:copyfrom(highlightTile, nil, coord ,true)
      highlightTile:destroy()
  end
end

--- Function that builds the GUI
function buildGUI()
  displayBackground()
  displayUsers()
  displayHighlighter()
  displayArrows()
end

--- Function that displays the Background image of the application
function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/OrderPics/chooseaccount.png")  
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
end

--- Deletes the currect surfaces from the box's RAM memory, clearing up space for new surfaces
function destroyTempSurfaces()
  if not (tempCopy == nil)then
  tempCopy:destroy()
  end
end

--- Moves the current inputField
-- @param #string key The key that has been pressed
function moveHighlightedInputField(key)
  if(key == 'up')then
    highlightPosY = highlightPosY - 1
    if(highlightPosY < lowerBoundary) then
      highlightPosY = upperBoundary
    end
  elseif(key == 'down')then
    highlightPosY = highlightPosY + 1
    if(highlightPosY > upperBoundary) then
      highlightPosY = 1
    end
end
  displayHighlighter()
  gfx.update()
end

--- Function that that updates the current screen to be able to show new or changed information to the user
function updateScreen()
  buildGUI()
  gfx.update()
end

--- Gets input from user and re-directs according to input
-- @param #string key The key that has been pressed
-- @param #string state The state of the key-press
-- @return #string pathName The path that the program shall be directed to
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
      -- Go to next step in the order process
      pathName = dir.. "OrderStep2.lua"
      if checkTestMode() then
        return pathName
      else
        account = getUser()
        destroyTempSurfaces()
        assert(loadfile(pathName))(account)
      end
    elseif(key == 'green') then
      -- Go back to menu
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

--- Functions that returns some of the values on local variables to be used when testing
-- @return #number StartPosY Starting position of the marker for this page
-- @return #number HightlightPosY Current position of the marker
-- @return #number upperBoundary Value of the highest position the marker can go before going offscreen
-- @return #number lowerBoundary Value of the lowerst position the marker can go before going offscreen
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

--- Function that sets the markers position to a selected value
-- @param #number value Value that the user wants to set the marker on 
function setValuesForTesting(value)
  highlightPosY = value
end

--- Main method
function onStart()
  readUsers()
  getNoOfPages()
  updateScreen()
end
onStart()





