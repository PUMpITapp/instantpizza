
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
function chooseGfx(underGoingTest)
  if not underGoingTest then
    tempGfx = require "gfx"
  elseif underGoingTest then
    tempGfx = require "gfx_stub"
  end
  return tempGfx
end

local gfx =  chooseGfx(checkTestMode())


--Calls methods that builds GUI
function buildGUI()
local background = gfx.loadpng("Images/tutorial.png") -- change this
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
gfx.update()
end

--- Gets input from user and re-directs according to input
-- @param #string key The key that has been pressed
-- @param #string state The state of the key-press
-- @return #String pathName The path that the program shall be directed to
function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'green') then
	  		--Go forward
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





