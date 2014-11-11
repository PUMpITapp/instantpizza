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
local io = require "IOHandler"
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
local choosenPizzeria = false
local pizzeriaToAdd = ""

local background = gfx.loadpng("Images/PizzeriaPics/background.png")
local inputField = gfx.loadpng("Images/PizzeriaPics/inputfield.png")
local highlight = gfx.loadpng("Images/PizzeriaPics/highlighter.png")

local lastForm = ...
local newForm = {}

--Pizzeria tables
local pizzerias = {}
local pizzeria = {}
local highlightFieldPos = 1

function checkForm()
	if type(lastForm) == "string" then

	else
		if lastForm then
			if lastForm.laststate == newForm.laststate then
				newForm = lastForm
			else
				for k,v in pairs(lastForm) do
					if not newForm[k] then
						newForm[k] = v
					end
				end
			end
		end
	end
		for k,v in pairs(newForm) do
		print(k,v)
	end
end
--Reads pizzerias from file. Returns a table containing pizzeria objects. 
function readPizzeriaFromFile()
	pizzerias = io.readPizzerias()
end
--Builds GUI
function buildGUI()
	gfx.screen:fill({241,248,233})
	gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
	displayHighlightSurface()
	displayPizzerias()
	displayChoosenPizzeria()
end
--Displays chosen pizzeria in cart
function displayChoosenPizzeria()
	if (choosenPizzeria)then
		text.print(gfx.screen, arial,pizzeria.name, xUnit*13, yUnit*1.5, 5 * xUnit, 5 * yUnit)
	end
end
--Display pizzerias. TODO: Add functionality to display more than four pizzerias. And display only in zip code area
function displayPizzerias()
	yCoord = inputFieldStart
	counter = 1
	for index,value in ipairs(pizzerias) do
		pngPath = pizzerias[index].imgPath
		pizzeriaImg = gfx.loadpng("Images/PizzeriaPics/Pizzerias/"..tostring(pngPath))
		gfx.screen:copyfrom(inputField,nil,{x=xUnit*3, y=yCoord, h=xUnit, w=yUnit*7})
		gfx.screen:copyfrom(pizzeriaImg,nil,{x=xUnit*3, y=yCoord, h=xUnit, w=yUnit*2})
		yCoord = yCoord+inputMovement
		if(counter == 4)then
			break
		end
		counter = counter+1
	end
end
--Find the selected pizzeria and send i to addToForm()
function addPizzeria()
	pizzeria = pizzerias[highlightFieldPos]
	addToForm(pizzeria)
	choosenPizzeria = true
end
--Adds pizzeria to form
function addToForm(pizzeria)
	newForm["pizzeria"] = pizzeria
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
end

--Method that prints picture to screen. Takes picture and x,y coordinates as argument.
function printPicture(pic,xx,yy)
 	gfx.screen:copyfrom(pic, nil, {x=xx,y=yy})
end

function updateScreen()
	buildGUI()
	gfx.update()
end
function onKey(key,state)
	--TODO”
	if(state == 'up') then
  		if(key == 'Up') then
	  		--Up
	  		moveHighlightedInputField(key)
	  		updateScreen()
	  	elseif(key == 'Down') then
	  		--Down
	  	  	moveHighlightedInputField(key)
	  	  	updateScreen()
	  	elseif(key=='Return')then
	  		addPizzeria()
	  		updateScreen()
	  	elseif(key == 'blue') then
	  	  	assert(loadfile("RegistrationStep3.lua"))(newForm)

	  	elseif(key == 'red')then
	  		assert(loadfile("RegistrationStep1.lua"))(newForm)
	  	end
 	end
end

--Main method
function main()
	checkForm()
	readPizzeriaFromFile()
	updateScreen()	
end
main()





