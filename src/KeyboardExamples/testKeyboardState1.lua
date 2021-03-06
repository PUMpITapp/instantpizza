local gfx = require "gfx"
local text = require "write_text"
-- local keyboardClass = require "keyboard"
local screenWidth = gfx.screen:get_width()
local screenHeight = gfx.screen:get_height()
local xUnit = screenWidth / 16
local yUnit = screenHeight / 9
local highlightPos = 1
gfx.screen:fill({0,0,0,0})
gfx.update()
-- local name = ...
local lastForm = ...

local newForm = {
	laststate = "testKeyboardState1.lua",
	currentInputField = "name",
	name = "Input name",
	age = 0,
	adress = "Input adress"
	}

local function main()
	checkForm()
	-- displaySavedText(name)
	displayInputfield()
	displayForm(info)
	displayHighlight()
end

function checkForm()
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

function onKey(key, state)
	if(state == 'up')then
		if(key == "Up" and highlightPos > 1) then
			highlightPos = highlightPos - 1
			displayHighlight()

		elseif(key == "Down" and highlightPos < 3) then
			highlightPos = highlightPos +1
			displayHighlight()

		elseif(key == "Return") then
			assert(loadfile("keyboard.lua"))(newForm)
		elseif(key == "S") then
			saveData(newForm)
		elseif(key == "blue") then
			assert(loadfile("testKeyboardState2.lua"))(newForm)
		end
	end
end

function displayInputfield()
	local pos1 = {x=xUnit, y=2 * yUnit, w=xUnit * 8, h=yUnit}
	local pos2 = {x=xUnit, y=4 * yUnit, w=xUnit * 8, h=yUnit}
	local pos3 = {x=xUnit, y=6 * yUnit, w=xUnit * 8, h=yUnit}

	gfx.screen:fill({r=255, g=255, b=255, a=0}, pos1)
	text.print(gfx.screen, arial, tostring(newForm.name), pos1.x, pos1.y, pos1.w, pos1.h)
	gfx.screen:fill({r=255, g=255, b=255, a=0}, pos2)
	text.print(gfx.screen, arial, tostring(newForm.age), pos2.x, pos2.y, pos2.w, pos2.h)
	gfx.screen:fill({r=255, g=255, b=255, a=0}, pos3)
	text.print(gfx.screen, arial, tostring(newForm.adress), pos3.x, pos3.y, pos3.w, pos3.h)
	gfx.update()
end

function displayHighlight()
	local pos1 = {x=xUnit, y=2 * yUnit, w=xUnit * 8, h=yUnit}
	displayInputfield()
	displayForm()
	gfx.screen:fill({r=255, g=0, b=0, a=0}, {x =pos1.x*8, y =pos1.y + (2 * highlightPos -2) * yUnit,w = xUnit,h = yUnit})
	setInputfield(newForm)
	gfx.update()
end

function setInputfield(form)
	if highlightPos == 1 then
		form.currentInputField = "name"
	elseif highlightPos ==2 then
		form.currentInputField = "age"
	elseif highlightPos ==3 then
		form.currentInputField = "adress"
	end
end
-- just to show how the form looks like in terminal
function displayForm(form)
	if form then
		for key, value in pairs(form) do
			print(key,value)
		end
	end
end

-- can be used to save data from form to a file
function saveData(form)
	local file = io.open("outputEXAMPLE.txt", "w")
	for key, value in pairs(form) do
		file:write(key," : ",value, "\n")
	end
	file:flush()
	file:close()
	print "SAVED"
end

main()