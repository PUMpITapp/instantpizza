--TODO:
--Another background and text font/color
--Real graphic components
--Inputs from user, read and write
--Create user from input
--Buttons
--Transparency not working
--- Checks if the file was called from a test file.
-- Returs true if it was, 
--   - which would mean that the file is being tested.
-- Returns false if it was not,
--   - which wold mean that the file was being used.  
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
local text = chooseText(checkTestMode())
local gfx =  chooseGfx(checkTestMode())

--Start of inputFields.
inputFieldStart = gfx.screen:get_height()*(2.5/9)
inputFieldY = gfx.screen:get_height()*(2.5/9)
inputFieldEnd = inputFieldStart + gfx.screen:get_height()*(0.7/9)*5
index = 0

--Calls methods that builds GUI
function buildGUI()
local background = gfx.loadpng("Images/choosepizzeria.png") -- change this
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
displayWelcomeText()
--displayHighlightSurface()
gfx.update()
end

function displayWelcomeText()
	text.print(gfx.screen, arial, "vadsom",gfx.screen:get_width()*(5/16),inputFieldStart, 500, 500)
end

--Creates inputsurface and displays "highlighted" input
function displayHighlightSurface()
	local highlight = gfx.loadpng("Images/pressinputfield.png") -- change
	gfx.screen:copyfrom(highlight,nil,{x=gfx.screen:get_width()*(5/16), y=inputFieldY, h=gfx.screen:get_height()/18, w=gfx.screen:get_width()*(7/16)})
end

function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'blue') then
	  		--Go forward
        pathName = "Menu.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
      elseif(key == 'red') then
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
	buildGUI()
end
main()




