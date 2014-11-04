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
local lastForm = ...
inputFieldTable = {}
inputFieldTable[0] = "name"
inputFieldTable[1] = "address"
inputFieldTable[2] = "zipCode"
inputFieldTable[3] = "city"
inputFieldTable[4] = "phone"
inputFieldTable[5] = "email"

local newForm = {
	laststate = "user_registration.lua",
	currentInputField = "name",
	name = "",
	address= "",
	zipCode ="",
	city = "",
	phone="",
	email = ""
	}



--Start of inputFields.
inputFieldStart = gfx.screen:get_height()*(2.5/9)
inputFieldY = gfx.screen:get_height()*(2.5/9)
inputFieldEnd = inputFieldStart + gfx.screen:get_height()*(0.7/9)*5
index = 0

function checkForm()
	newForm.currentInputField = "name"
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

--Calls methods that builds GUI
function buildGUI()
local background = gfx.loadpng("images/userregistration.png")
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
displayHighlightSurface()
gfx.update()
end

--Creates inputsurface and displays "highlighted" input
function displayHighlightSurface()
	text.print(gfx.screen, arial, tostring(newForm.name),gfx.screen:get_width()*(5/16),inputFieldStart, 500, 500)
	text.print(gfx.screen, arial, tostring(newForm.address),gfx.screen:get_width()*(5/16),inputFieldStart+gfx.screen:get_height()*(0.7/9),500,500)
	text.print(gfx.screen, arial, tostring(newForm.zipCode),gfx.screen:get_width()*(5/16),inputFieldStart+gfx.screen:get_height()*((0.7/9)*2),500,500)
	text.print(gfx.screen, arial, tostring(newForm.city),gfx.screen:get_width()*(5/16),inputFieldStart+gfx.screen:get_height()*((0.7/9)*3),500, 500)
	text.print(gfx.screen, arial, tostring(newForm.phone),gfx.screen:get_width()*(5/16),inputFieldStart+gfx.screen:get_height()*((0.7/9)*4),500, 500)
	text.print(gfx.screen, arial, tostring(newForm.email),gfx.screen:get_width()*(5/16),inputFieldStart+gfx.screen:get_height()*((0.7/9)*5),500, 500)
	local highlight = gfx.loadpng("images/pressinputfield.png")
	gfx.screen:copyfrom(highlight,nil,{x=gfx.screen:get_width()*(5/16), y=inputFieldY, h=gfx.screen:get_height()/18, w=gfx.screen:get_width()*(7/16)})
end

--Moves the current inputField
function moveHighlightedInputField(key)
	--Starting coordinates for current inputField
	if(key == 'Up') then
		if(inputFieldY > inputFieldStart) then
			inputFieldY = inputFieldY - gfx.screen:get_height()*(0.7/9)
			index=index-1
			newForm.currentInputField= inputFieldTable[index]
		end
	end
	--Down
	if(key == 'Down') then
		if(inputFieldY < inputFieldEnd)then
			inputFieldY = inputFieldY + gfx.screen:get_height()*(0.7/9)
			index=index+1
			newForm.currentInputField= inputFieldTable[index]
		
		elseif(inputFieldY == inputFieldEnd) then
			inputFieldY = inputFieldStart
			index = 0
			newForm.currentInputField= inputFieldTable[index]
		end
	end
	buildGUI()
end
function onKey(key,state)
	if(state == 'up') then
		if(key == 'Up')then
			moveHighlightedInputField(key)
	 	elseif(key == 'Down')then
	 		moveHighlightedInputField(key) 	
		elseif(key == "Return") then
			assert(loadfile("keyboard.lua"))(newForm)
	  	elseif(key == 'red') then
	  		--Go back
	  	elseif(key == 'blue') then
	  		--Go forward
	  		dofile("choose_Pizzeria.lua")
	  	end
	end
end

--Main method
function main()
	checkForm()
	buildGUI()
	newForm.currentInputField = "name"
end
main()





