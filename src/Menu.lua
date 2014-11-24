--TODO:
--Another background and text font/color
--Real graphic components
--Inputs from user, read and write
--Create user from input
--Buttons
--Transparency not working
local onBox = false

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
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/MenuPics/?.png'
  dir = sys.root_path()

else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
end

-- function chooseText()
--   if not checkTestMode() then
--     tempText = require "write_text"
--   elseif checkTestMode() then
--     tempText = require "write_text_stub"
--   end
--   return tempText
-- end

-- local text = chooseText(checkTestMode())

--Start of inputFields.
inputFieldStart = gfx.screen:get_height()*(2.5/9)
inputFieldY = gfx.screen:get_height()*(2.5/9)
inputFieldEnd = inputFieldStart + gfx.screen:get_height()*(0.7/9)*5
index = 0

--Calls methods that builds GUI
function buildGUI()
  local backgroundPNG = gfx.loadpng("Images/MenuPics/menu.png")
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
  gfx.update()
end



function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'red') then
	  		--Go to Create Account
        pathName = dir .. "RegistrationStep1.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
      elseif(key == 'yellow') then
        --Go to About
        pathName = dir .. "Tutorial.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
        elseif(key == 'blue') then
        --Go to About
        pathName = dir .. "OrderStep1.lua"
          if checkTestMode() then
            return pathName
          else
            dofile(pathName)
        end
	  	end
	end
end

--Main method
function onStart()
	buildGUI()
end
onStart()





