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

--Declare units i variables
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

 --Start of inputFields. Needed for 
local inputMovement = yUnit*1.2
local inputFieldX = gfx.screen:get_width()/8
local inputFieldY = yUnit*2.5
local inputFieldStart = yUnit*2.5
local inputFieldEnd = inputFieldStart+inputMovement*3
local choosenPizzeria = true

local background = gfx.loadpng("Images/PizzeriaPics/background.png")
local inputField = gfx.loadpng("Images/PizzeriaPics/inputfield.png")
local highlight = gfx.loadpng("Images/PizzeriaPics/highlighter.png")
local pizza1 = gfx.loadpng("Images/PizzeriaPics/Pizzerias/pizza1.png")
local pizza2 = gfx.loadpng("Images/PizzeriaPics/Pizzerias/pizza2.png")
local pizza3 = gfx.loadpng("Images/PizzeriaPics/Pizzerias/pizza3.png")
local pizza4 = gfx.loadpng("Images/PizzeriaPics/Pizzerias/pizza4.png")

local pizzerias = {
	picFilePath = "",
	pizzeriaName = "",
	description = ""
	--Mer info?
}

function readPizzeriaFromFile()



end
--Calls methods that builds GUI
function buildGUI()
	gfx.screen:fill({241,248,233})

	gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
	
	for i = inputFieldStart, inputFieldEnd,inputMovement do
		gfx.screen:copyfrom(inputField,nil,{x=xUnit*3, y=i, h=xUnit, w=yUnit*7})
	end
	displayHighlightSurface()
	displayPizzerias()
	gfx.update()
end

function displayPizzerias()
	--Get pizzerias from file
	--Display pictures
	
	gfx.screen:copyfrom(pizza1,nil,{x=xUnit*3, y=inputFieldStart, h=xUnit, w=yUnit*2})
	gfx.screen:copyfrom(pizza2,nil,{x=xUnit*3, y=(inputFieldStart+inputMovement), h=xUnit, w=yUnit*2})
	gfx.screen:copyfrom(pizza3,nil,{x=xUnit*3, y=inputFieldStart+(inputMovement*2), h=xUnit, w=yUnit*2})
	gfx.screen:copyfrom(pizza4,nil,{x=xUnit*3, y=inputFieldStart+(inputMovement*3), h=xUnit, w=yUnit*2})
	text.print(gfx.screen, arial,"Pizzeria", xUnit*13, yUnit*1, 5 * xUnit, 5 * yUnit)

end

function addPizzeria()
	--Highligt pizzeria and add to form
	local pizza1YCoordinate = inputFieldStart
	local pizza2YCoordinate = (inputFieldStart+inputMovement)
	local pizza3YCoordinate = inputFieldStart+(inputMovement*2)
	local pizza4YCoordinate = inputFieldStart+(inputMovement*3)
	if(inputFieldY == pizza1YCoordinate)then
		text.print(gfx.screen, arial,"Pizzeria 1", xUnit*13, yUnit*1.5, 5 * xUnit, 5 * yUnit)
	elseif(inputFieldY == pizza2YCoordinate)then
		text.print(gfx.screen, arial,"Pizzeria 2", xUnit*13, yUnit*1.5, 5 * xUnit, 5 * yUnit)
	elseif(inputFieldY == pizza3YCoordinate)then
		text.print(gfx.screen, arial,"Pizzeria 3", xUnit*13, yUnit*1.5, 5 * xUnit, 5 * yUnit)
	elseif(inputFieldY == pizza4YCoordinate)then
		text.print(gfx.screen, arial,"Pizzeria 4", xUnit*13, yUnit*1.5, 5 * xUnit, 5 * yUnit)

	end
	gfx.update()
end
function displayHighlightSurface()
	gfx.screen:copyfrom(highlight,nil,{x=xUnit*3, y=inputFieldY, h=xUnit, w=yUnit*9})
end

--Moves the current inputField
function moveHighlightedInputField(key)
	--Starting coordinates for current inputField
	if(key == 'Up') then
		if(inputFieldY > inputFieldStart) then
			inputFieldY = inputFieldY - inputMovement
		end
	end
	--Down
	if(key == 'Down') then
		if(inputFieldY < inputFieldEnd)then
			inputFieldY = inputFieldY + inputMovement
		
		elseif(inputFieldY == inputFieldEnd) then
			inputFieldY = inputFieldStart
		end
	end
	buildGUI()
end

--Method that prints picture to screen. Takes picture and x,y coordinates as argument.
function printPicture(pic,xx,yy)
 	gfx.screen:copyfrom(pic, nil, {x=xx,y=yy})
end

function onKey(key,state)
	--TODO”
	if(state == 'up') then
  		if(key == 'Up') then
	  		--Up
	  		moveHighlightedInputField(key)
	  	elseif(key == 'Down') then
	  		--Down
	  	  	moveHighlightedInputField(key)
	  	elseif(key=='Return')then
	  		addPizzeria()

	  	elseif(key == 'blue') then
	  	  	dofile("RegistrationStep3.lua")

	  	elseif(key == 'red')then
	  		dofile("RegistrationStep1.lua")
	  	end
 	end
end

--Main method
function main()
	buildGUI()
end
main()





