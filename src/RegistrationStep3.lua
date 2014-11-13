local text = require "write_text"
local gfx = require "gfx"
local io = require "IOHandler"


local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9
local margin = yUnit * 0.05

local pizzaFieldY = yUnit * 2.5
local pizzaFieldX = xUnit * 3

local highlightPosX = 1
local highlightPosY = 1

local showLimit = 8
local maxChoices = 4
local choices = 0
local noOfPizzas = 0

local highligtherPNG = gfx.loadpng("Images/PizzaPics/highlighter.png")
local backgroundPNG = gfx.loadpng("Images/PizzaPics/background.png")
local tilePNG = gfx.loadpng("Images/PizzaPics/inputfield.png")

local pizzaSurface = gfx.new_surface(10 * xUnit, 4 * yUnit)
local backgroundSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())

local lastForm = ...
local newForm = {}

local isChosen = false
local pizzaMenu = {}
local pizza = {}

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
--Calls methods that builds GUI
function updateScreen()
displayBackground()
displayHighlightSurface()
displayPizzas()
displayChoiceMenu()
gfx.update()
end

function displayBackground()
	backgroundSurface:clear()
	backgroundSurface:copyfrom(backgroundPNG)

	gfx.screen:copyfrom(backgroundSurface)
end
function getPizzas()
	currentPizzeria = newForm.pizzeria
	currentPizzeria.pizzas = io.readPizzas(currentPizzeria.id)

end
--Creates new surface and display pizzas
function displayPizzas()
	local pizzaPosX = pizzaFieldX
	local pizzaPosY = pizzaFieldY
	local ySpace = 0.5 * yUnit
	pizzaSurface:clear()
	for i,v in ipairs(currentPizzeria.pizzas) do
		gfx.screen:copyfrom(tilePNG, nil, {x =pizzaPosX, y =pizzaPosY + (i-1) * margin, w=xUnit*7 , h=ySpace})
		text.print(gfx.screen, arial, currentPizzeria.pizzas[i].name, pizzaPosX, pizzaPosY+ (i-1) * margin, xUnit*5, ySpace)
		text.print(gfx.screen, arial, tostring(currentPizzeria.pizzas[i].price) .. "kr", pizzaPosX + 6 * xUnit, pizzaPosY + (i-1) * margin, 2 * xUnit, ySpace)
		pizzaPosY = pizzaPosY + ySpace
		noOfPizzas = i
		if(i == showLimit)then 
			break
		end
	end
end

function displayHighlightSurface()
	local pos = {x = pizzaFieldX + (highlightPosX -1)*xUnit, y = pizzaFieldY +(highlightPosY-1) * (yUnit *0.5 + margin), w = 9 * xUnit, h =0.5*yUnit}
	gfx.screen:copyfrom(highligtherPNG, nil , pos )
end

function getPizzaOnCoordinate(posY)

	return currentPizzeria.pizzas[posY]
end


function insertOnChoiceMenu(myPizza)
	isChosen = true
	if(choices < maxChoices) then
	choices = choices + 1
	pizza[choices] = myPizza
	end
	
end

function insertOnTable(pizzaTable)
	newForm.pizzeria["pizza"] = pizzaTable
	-- local i = 0
	-- for key, value in pairs(pizzaTable) do
	-- 	i = i + 1
	-- 	pos = "pizza"..i
	-- 	newForm[pos] = value.name
	-- end
end

function deleteOnChoiceMenu(myPizza)
	if pizza[myPizza.name] then
		choices = choices - 1
		pizza[myPizza.name] = nil
	end
end

function displayChoiceMenu()
	local x = 13 * xUnit
	local y = 1.5 * yUnit
	local menuItems = 0
	for k, v in pairs(pizza) do
	text.print(gfx.screen, arial, v.name, x, y + 0.5*menuItems*yUnit, pizzaCellX, pizzaCellY)
	menuItems = menuItems + 1
	end
end

--Moves the current inputField
function moveHighlight(key)

	--Up
	if(key == 'Up')then
		highlightPosY = highlightPosY - 1
		if(highlightPosY < 1) then
			highlightPosY = highlightPosY +1
		end
	--Down
	elseif(key == 'Down')then
		highlightPosY = highlightPosY + 1
		if(highlightPosY > noOfPizzas) then
			highlightPosY = highlightPosY -1
		end
	--Left
	elseif(key == 'Left')then
		
	--Right
	elseif(key == 'Right') then
		
	end
end

function onKey(key,state)
	--TODO
	if(state == 'up') then
	  	if(key == 'Up') then
	  		--Up
	  		moveHighlight(key)
	  		updateScreen()
	  		
	  	elseif(key == 'Down') then
	  		--Down
	  		moveHighlight(key)
	  		updateScreen()
	  		--Left
	  	elseif(key == 'Left') then
	  		moveHighlight(key)
	  		updateScreen()
	  		--Right
	  	elseif(key == 'Right') then
	  		moveHighlight(key)
			updateScreen()
	  	elseif(key == 'red') then
	  		-- insertOnTable(pizza)
	  		assert(loadfile("RegistrationStep2.lua"))(newForm)
	  	elseif(key == 'blue') then
	  		if isChosen then
	  			insertOnTable(pizza)
	  			assert(loadfile("RegistrationReview.lua"))(newForm)
	  		else
	  			text.print(gfx.screen, arial, "You need to choose at least one pizza!", xUnit*3, yUnit*6.5, xUnit*10, yUnit)
	  		end
	  	elseif(key == 'Return') then
	  		local choosenPizza = getPizzaOnCoordinate(highlightPosY)
	  		insertOnChoiceMenu(choosenPizza)
	  		updateScreen()
	  	elseif(key == 'Delete') then
	  		deleteOnChoiceMenu(getPizzaOnCoordinate(highlightPosY))
	  		updateScreen()
	  	end
	end
	gfx.update()
end

--Main method
function main()
	checkForm()
	getPizzas()
	updateScreen(q)
end
main()





