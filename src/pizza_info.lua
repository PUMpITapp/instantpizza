--TODO:
--Another background and text font/color
--Real graphic components
--Inputs from user, read and write
--Create user from input
--Buttons
--Transparency not working

local text = require "write_text"
local gfx = require "gfx"
-- inserted these for showing to customer. remove if needed //Huy

local background = gfx.loadpng("images/ChoosePizzeria/chosepizzeria.png")

local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9

--Start of inputFields. Needed for 
local pizzaFieldY = yUnit * 2.5
local pizzaFieldX = xUnit * 3

gfx.screen:fill({241,248,233})
gfx.update()


local pizzaSurface = gfx.new_surface(10 * xUnit, 4 * yUnit)
local backgroundSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())

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
gfx.update()
end

function displayBackground()
	backgroundSurface:clear()
	backgroundSurface:copyfrom(background)

	gfx.screen:copyfrom(backgroundSurface)
end

--Creates new surface and display pizzas
function displayPizzas()
	local pizzaPosX = pizzaFieldX
	local pizzaPosY = pizzaFieldY
	local times = 0;
	pizzaSurface:clear()
	pizzaSurface:fill({241,248,233})
	for key, value in pairs(pizzaMenu) do
		text.print(gfx.screen, arial, value.name, pizzaPosX, pizzaPosY, 2.5 * xUnit, 2 * yUnit)
		text.print(gfx.screen, arial, tostring(value.price), pizzaPosX, pizzaPosY + 0.5 * yUnit, 2.5 * xUnit, 2 * yUnit)
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

end



--Moves the current inputField
function moveHighlightedInputField(key)
	--Starting coordinates for current inputField
	 inputFieldStart = 150
	 inputFieldEnd = 550
	--Up
	if(key == 'Up')then
		if(inputFieldY == 450) then
			inputFieldY = 250
			displayPizzas()
		end
	end
	--Down
	if(key == 'Down')then
		if(inputFieldY == 250)then
			inputFieldY = 450
			displayPizzas()
		end
	end
	--Left
	if(key == 'Left')then
		if(inputFieldX > gfx.screen:get_width()/8) then
			inputFieldX = inputFieldX - 200
			displayPizzas()
		elseif(inputFieldX == gfx.screen:get_width()/8)then
			inputFieldX = gfx.screen:get_width()/8+600
			displayPizzas()
		end
	end
	--Down
	if(key == 'Right') then
		if(inputFieldX < gfx.screen:get_width()/8+600) then
			inputFieldX = inputFieldX + 200 
			displayPizzas()
		elseif(inputFieldX == gfx.screen:get_width()/8+600)then
			inputFieldX = gfx.screen:get_width()/8
			displayPizzas()

		end
	end
end

--Method that prints picture to screen. Takes picture and x,y coordinates as argument.
function printPicture(pic,xx,yy)
 	gfx.screen:copyfrom(pic, nil, {x=xx,y=yy})

end

function onKey(key,state)
	--TODO
	if(state == 'up') then
	  	if(key == 'Up') then
	  		--Up
	  		moveHighlightedInputField(key)
	  	elseif(key == 'Down') then
	  		--Down
	  	  	moveHighlightedInputField(key)
	  		--Left
	  	elseif(key == 'Left') then
	  		moveHighlightedInputField(key)
	  		--Right
	  	elseif(key == 'Right') then
	  		moveHighlightedInputField(key)
	  	elseif(key == 'red') then
	  	  	dofile("choose_Pizzeria.lua")
	  	end
	end
	gfx.update()
end

--Main method
function main()
	updateScreen()
end
main()





