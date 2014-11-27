--- Tells if the program shall be run on the box or not
local onBox = false

-- Makes sure that the first step in the tutorial is loaded
local pageNumber = 1

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

--- Checks if the program is run on the box or not
if onBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/AboutPics/?.png'
  dir = sys.root_path()

else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
end

--- Calls methods that builds GUI
function buildGUI()
  displayBackground()
  displayStep()
  gfx.update()
end

-- Displays the general background
-- @param #picture backgroundPNG Determines which image to load to the background
function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/AboutPics/aboutbackground.png")
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
end

-- Displays the current step of the tutorial
-- @param #integer pageNumber Checks which is the current step of the tutorial
-- @param #picture step Determines which image to load in front of the background
function displayStep()
  if pageNumber == 1 then
    step = gfx.loadpng("Images/AboutPics/aboutstep1.png")
  elseif pageNumber == 2 then
    step = gfx.loadpng("Images/AboutPics/aboutstep2.png")
  elseif pageNumber == 3 then
    step = gfx.loadpng("Images/AboutPics/aboutstep3.png")
  end
  step:premultiply()
  gfx.screen:copyfrom(step, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  step:destroy()
end

--- Gets input from user and re-directs according to input
-- @param #string key The key that has been pressed
-- @param #string state The state of the key-press
-- @param #integer pageNumber The current step in the tutorial
-- @return #string pathName The path that the program shall be directed to
function onKey(key,state)
  if(state == 'up') then
      if(key == 'green') then
        --Go to Menu
        pathName = dir .. "Menu.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
      elseif(key == 'left') then
        --Go to the previous step
        if checkTestMode() then
          return key
        else
          if pageNumber == 1 then
            --Nothing
          else
            pageNumber = pageNumber - 1
            buildGUI()
          end
        end
      elseif(key == 'right') then
        --Go to the next step
        if checkTestMode() then
          return key
        else
          if pageNumber == 3 then
            --Nothing
          else
            pageNumber = pageNumber + 1
            buildGUI()
          end
        end
      end
  end
end

--- Main method
function onStart()
  buildGUI()
end
onStart()





