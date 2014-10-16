--TODO:
--Another background and text font/color
--Real graphic components
--Inputs from user, read and write
--Create user from input
--Buttons
--Transparency not working

local text = require "write_text"
local gfx = require "gfx"

--Start of inputFields. Needed for 
local inputFieldY = 250
local inputFieldX = gfx.screen:get_width()/8

gfx.screen:fill({241,248,233})
gfx.update()

local logoSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height()/5)
local pizzaSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height()/2)
local highlightSurface = gfx.new_surface(gfx.screen:get_width()/1, gfx.screen:get_height())
local statusSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height()/5)

--Calls methods that builds GUI
function buildGUI()
displayLogo()
displaystatusSurface()
displayPizzas()
--displayHighlightSurface()
end

--Creates new surface and displays logo
function displayLogo()
	logoSurface:clear()
	logoSurface:fill({139,195,74})
	gfx.screen:copyfrom(logoSurface,nil,{x=0, y=0})
	png_logo_width = 250
	text.print(gfx.screen,arial,"InstantPizza",gfx.screen:get_width()/2-(png_logo_width/2),50,300,300)
  --  gfx.screen:copyfrom(logo, nil, {x=gfx.screen:get_width()/2-(png_logo_width/2), y=100})
	gfx.update()
end

--Creates new surface and display pizzas
function displayPizzas()
	pizzaSurface:clear()
	pizzaSurface:fill({241,248,233})
	gfx.screen:copyfrom(pizzaSurface,nil,{x=0, y=230})
	text.print(gfx.screen,arial,"Pizza 1",gfx.screen:get_width()/8,300,220,300)
	text.print(gfx.screen,arial,"Pizza 2",gfx.screen:get_width()/8+200,300,220,300)
	text.print(gfx.screen,arial,"Pizza 3",gfx.screen:get_width()/8+400,300,220,300)
	text.print(gfx.screen,arial,"Pizza 4",gfx.screen:get_width()/8+600,300,220,300)

	text.print(gfx.screen,arial,"Pizza 5",gfx.screen:get_width()/8,500,220,300)
	text.print(gfx.screen,arial,"Pizza 6",gfx.screen:get_width()/8+200,500,220,300)
	text.print(gfx.screen,arial,"Pizza 7",gfx.screen:get_width()/8+400,500,220,300)
	text.print(gfx.screen,arial,"Pizza 8",gfx.screen:get_width()/8+600,500,220,300)
	text.print(gfx.screen,arial,"Choose",inputFieldX,inputFieldY,140,50)
	gfx.update()

end

--Creates inputsurface and displays "highlighted" input
function displayHighlightSurface()
	--TODO:
	--Actual inputfields and higlight. Variable highlight is the actual highlight
	--that moves when user presses up and down.
	--Try transparent on box
	highlightSurface:clear()
	highlightSurface:fill({0,0,155})
	gfx.screen:copyfrom(inputSurface,nil,{x=0, y=gfx.screen:get_height()/5 ,h=gfx.screen:get_height()*(3/5)})
	text.print(gfx.screen,arial,"Highlighted",inputFieldX,inputFieldY,500,200)
	gfx.update()
end

function displaystatusSurface()

	statusSurface:clear()
	statusSurface:fill({255,255,255})
	gfx.screen:copyfrom(statusSurface,nil,{x=0,y=(gfx.screen:get_height()-gfx.screen:get_height()/5)})
	gfx.update()
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

  	end
	gfx.update()
end

--Main method
function main()
	buildGUI()

end
main()





