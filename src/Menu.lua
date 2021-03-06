--- Tells if the program shall be run on the box or not
local onBox = false

--- Checks if the file was called from a test file.
-- @return true if called from a test file, indicating the file is being tested, else false
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
-- @return tempGfx Returns dummy gfx if the file is being tested, returns actual gfx if the file is being run.
function chooseGfx()
  if not checkTestMode() then
    tempGfx = require "gfx"
  elseif checkTestMode() then
    tempGfx = require "gfx_stub"
  end
  return tempGfx
end

--- Checks if the program is run on the box or not
if onBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/MenuPics/?.png'
  dir = sys.root_path()
else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
end

--- Variable that is triggered if a user has edited or created an account
local accountAction = ...

--- Declare units in variables
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

--- Function that builds the GUI
function buildGUI()
  local backgroundPNG = gfx.loadpng("Images/MenuPics/menu.png")
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
  addNotification()
  gfx.update()
end

--- Gets input from user and re-directs according to input
-- @param key The key that has been pressed
-- @param state The state of the key-press
-- @return pathName The path that the program shall be directed to
function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'red') then
	  		--Go to Create Account
        pathName = dir .. "ManageAccounts.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
      elseif(key == 'yellow') then
        -- Go to About
        pathName = dir .. "Tutorial.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
        elseif(key == 'blue') then
        -- Go to order steps
        pathName = dir .. "OrderStep1.lua"
          if checkTestMode() then
            return pathName
          else
            dofile(pathName)
        end
	  	end
	end
end

--- Function that is triggered when an account is edited or created that alerts the user about the action
function addNotification()
  if accountAction == "Edit" then
    local backgroundPNG = gfx.loadpng("Images/MenuPics/editaccount.png")
    backgroundPNG:premultiply()
    gfx.screen:copyfrom(backgroundPNG, nil, {x=xUnit*3.08 , y=yUnit*4.66, w=xUnit*2.5, h=yUnit*3.75},true)
    backgroundPNG:destroy()
  elseif (accountAction == "Create") then
    local backgroundPNG = gfx.loadpng("Images/MenuPics/anewaccount.png")
    backgroundPNG:premultiply()
    gfx.screen:copyfrom(backgroundPNG, nil, {x=xUnit*3.08 , y=yUnit*4.66, w=xUnit*2.5, h=yUnit*3.75},true)
    backgroundPNG:destroy()  
  end
end

--- Main method
function onStart()
	buildGUI()
end
onStart()





