local text = require "write_text"
local gfx = require "gfx"

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

local pizzaFieldY = yUnit * 2.5
local pizzaFieldX = xUnit * 3

local pizzaCellX = 10/4 * xUnit
local pizzaCellY = 4/2 * yUnit

local highlightPosX = 1
local highlightPosY = 1

local pizzaLimitX = 4
local pizzaLimitY = 2

local highligtherPNG = gfx.loadpng("images/pizzaInfo/pizzeriatile.png")
local backgroundPNG = gfx.loadpng("images/pizzaInfo/choosePizzas.png")

local pizzaSurface = gfx.new_surface(10 * xUnit, 4 * yUnit)
local backgroundSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())
local highlightSurface = gfx.new_surface(10 * xUnit, 4 * yUnit)

local lastStateForm = ...


local pizzaMenu = {
	p1 = {name = "Kebab", price = 75},
	p2 = {name = "Hawaii", price = 60},
	p3 = {name = "Vesuvio", price = 70},
	p4 = {name = "Poker", price = 80},
	p5 = {name = "Capri", price = 70},
	p6 = {name = "Bella", price = 60},
	p7 = {name = "Husets", price = 100},
	p8 = {name = "Quatro", price = 65}
}

--Calls methods that builds GUI
function updateScreen()
displayBackground()
displayPizzas()
displayHighlightSurface()
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
	local times = 0

	pizzaSurface:clear()
	pizzaSurface:fill({241,248,233})
	for key, value in pairs(pizzaMenu) do
		text.print(gfx.screen, arial, value.name, pizzaPosX, pizzaPosY, 2.5 * xUnit, 2 * yUnit)
		text.print(gfx.screen, arial, tostring(value.price) .. "kr", pizzaPosX, pizzaPosY + 0.5 * yUnit, pizzaCellX, pizzaCellY)
		pizzaPosX = pizzaPosX + 2.5 * xUnit
		times = times + 1
		if(times > 3)then
			times = 0
			pizzaPosX = pizzaFieldX
			pizzaPosY = pizzaPosY + 2 * yUnit
		end
	end
end

--Creates inputsurface and displays "highlighted" input
function displayHighlightSurface()
	
	highlightSurface:clear()
	highlightSurface:copyfrom(highligtherPNG)
	gfx.screen:copyfrom(highlightSurface, nil , {x = pizzaFieldX + (highlightPosX -1)*pizzaCellX, y = pizzaFieldY +(highlightPosY-1) * pizzaCellY, w =pizzaCellX, h =pizzaCellY})
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
		if(highlightPosY > pizzaLimitY) then
			highlightPosY = highlightPosY -1
		end
	--Left
	elseif(key == 'Left')then
		highlightPosX = highlightPosX - 1
		if(highlightPosX < 1) then
			highlightPosX = highlightPosX +1
		end
	--Right
	elseif(key == 'Right') then
		highlightPosX = highlightPosX + 1
		if(highlightPosX > pizzaLimitX) then
			highlightPosX = highlightPosX -1
		end
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

	  	end
	end
	gfx.update()
end

--Main method
function main()
	updateScreen(q)
end
main()





