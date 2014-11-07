local text = require "write_text"
local gfx = require "gfx"

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

local highligtherPNG = gfx.loadpng("images/pizzaInfo/pressedpizzeria.png")
local backgroundPNG = gfx.loadpng("images/pizzaInfo/choosePizzas.png")
local tilePNG = gfx.loadpng("images/pizzaInfo/pizzeriatile.png")

local pizzaSurface = gfx.new_surface(10 * xUnit, 4 * yUnit)
local backgroundSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())
-- local highlightSurface = gfx.new_surface(10 * xUnit, 4 * yUnit)

local lastStateForm = ...

local pizzaMenu = {}
pizzaMenu[1] = {name = "Kebab", price = 75}
pizzaMenu[2] = {name = "Hawaii", price = 60}
pizzaMenu[3] = {name = "Vesuvio", price = 70}
pizzaMenu[4] = {name = "Poker", price = 80}
pizzaMenu[5] = {name = "Capri", price = 70}
pizzaMenu[6] = {name = "Bella", price = 60}
pizzaMenu[7] = {name = "Husets", price = 100}
pizzaMenu[8] = {name = "Quatro", price = 65}

local choosenPizzas = {}

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

--Creates new surface and display pizzas
function displayPizzas()
	local pizzaPosX = pizzaFieldX
	local pizzaPosY = pizzaFieldY
	local ySpace = 0.5 * yUnit

	pizzaSurface:clear()
	for i=1,showLimit do
		gfx.screen:copyfrom(tilePNG, nil, {x =pizzaPosX, y =pizzaPosY + (i-1) * margin, w=xUnit*7 , h=ySpace})
		text.print(gfx.screen, arial, pizzaMenu[i].name, pizzaPosX, pizzaPosY+ (i-1) * margin, xUnit*2, ySpace)
		text.print(gfx.screen, arial, tostring(pizzaMenu[i].price) .. "kr", pizzaPosX + 6 * xUnit, pizzaPosY + (i-1) * margin, 2 * xUnit, ySpace)
		pizzaPosY = pizzaPosY + ySpace
	end
end

--Creates inputsurface and displays "highlighted" input
function displayHighlightSurface()
	-- highlightSurface:clear()
	-- highlightSurface:copyfrom(highligtherPNG)
	local pos = {x = pizzaFieldX + (highlightPosX -1)*xUnit, y = pizzaFieldY +(highlightPosY-1) * (yUnit *0.5 + margin), w = 9 * xUnit, h =0.5*yUnit}
	gfx.screen:copyfrom(highligtherPNG, nil , pos )
end

function getPizzaOnCoordinate(posY)

	return pizzaMenu[posY]
end


function insertOnChoiceMenu(myPizza)
	if not choosenPizzas[myPizza.name] then
		if(choices < maxChoices) then
		choices = choices + 1
		choosenPizzas[myPizza.name] = myPizza
		end
	end
end

function deleteOnChoiceMenu(myPizza)
	if choosenPizzas[myPizza.name] then
		choices = choices - 1
		choosenPizzas[myPizza.name] = nil
	end
end

function displayChoiceMenu()
	local x = 13 * xUnit
	local y = 1.5 * yUnit
	local menuItems = 0
	for k, v in pairs(choosenPizzas) do
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
		if(highlightPosY > showLimit) then
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
	  		assert(loadfile("choose_Pizzeria.lua"))(nil)
	  	elseif(key == 'blue') then

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
	updateScreen(q)
end
main()





