--TODO:

local text = require "write_text"
local gfx = require "gfx"

--Start of inputFields. Needed for 
local inputFieldY = 400

gfx.screen:fill({0,0,0})
gfx.update()

local logoSurface = gfx.new_surface(gfx.screen:get_width()/2, gfx.screen:get_height()/4)
local sideSurface = gfx.new_surface(gfx.screen:get_width()/4, gfx.screen:get_height())
local inputSurface = gfx.new_surface(gfx.screen:get_width()/1, gfx.screen:get_height())
local highlightSurface = gfx.new_surface(gfx.screen:get_width()/1, gfx.screen:get_height())

--Calls methods that builds GUI
function buildGUI()
displayLogo()
--displayInputSurface()
displayPizzerias()
--displayHighlightSurface()
end

--Creates new surface and displays logo
function displayLogo()
	logoSurface:clear()
	logoSurface:fill({0,0,0})
	gfx.screen:copyfrom(logoSurface,nil,{x=0, y=0})
	png_logo_width = 250
	text.print(gfx.screen,arial,"InstantPizza",gfx.screen:get_width()/2-220/2,50,220,300)
	text.print(gfx.screen,arial,"Pizzerias near you",gfx.screen:get_width()/2-320/2,150,320,300)
	gfx.update()
end
--Creates inputsurface and displays "highlighted" input
function displayHighlightSurface()
	--TODO:
	--Actual inputfields and higlight. Variable highlight is the actual highlight
	--that moves when user presses up and down.
	--Try transparent on box
	highlightSurface:clear()
	highlightSurface:fill({0,0,0})
	gfx.screen:copyfrom(highlightSurface,nil,{x=200, y=300})
	text.print(gfx.screen,arial,"Highlighted pizzeria",250,inputFieldY,500,200)
	gfx.update()
end

function displayPizzerias()
	--TODO
	--Get pizzerias
	text.print(gfx.screen,arial,"Pizzeria 1",gfx.screen:get_width()/8,300,220,300)
	text.print(gfx.screen,arial,"Pizzeria 2",gfx.screen:get_width()/8+200,300,220,300)
	text.print(gfx.screen,arial,"Pizzeria 3",gfx.screen:get_width()/8+400,300,220,300)
	text.print(gfx.screen,arial,"Pizzeria 4",gfx.screen:get_width()/8+600,300,220,300)

	text.print(gfx.screen,arial,"Pizzeria 5",gfx.screen:get_width()/8,500,220,300)
	text.print(gfx.screen,arial,"Pizzeria 6",gfx.screen:get_width()/8+200,500,220,300)
	text.print(gfx.screen,arial,"Pizzeria 7",gfx.screen:get_width()/8+400,500,220,300)
	text.print(gfx.screen,arial,"Pizzeria 8",gfx.screen:get_width()/8+600,500,220,300)


end
--Moves the current inputField
function moveHighlightedInputField(key)
	--Starting coordinates for current inputField
	 inputFieldStart = 150
	 inputFieldEnd = 550
	--Up
	if(key == 'red') then
		if(inputFieldY > 150) then
			inputFieldY = inputFieldY - 80
			displayHighlightSurface()
		elseif(inputFieldY == 150) then
			inputFieldY = inputFieldEnd
			displayHighlightSurface()
		end
	end
	--Down
	if(key == 'green') then
		if(inputFieldY < 550) then
			inputFieldY = inputFieldY + 80
			displayHighlightSurface()
		elseif(inputFieldY == 550) then
			inputFieldY = inputFieldStart
			displayHighlightSurface()
		end
	end
end

--Method that prints picture to screen. Takes picture and x,y coordinates as argument.
function printPicture(pic,xx,yy)
 	gfx.screen:copyfrom(pic, nil, {x=xx,y=yy})

end

function onKey(key,state)
	--TODO

  	if(key == 'red') then
  		--Up
  		moveHighlightedInputField(key)
  	elseif(key == 'green') then
  		--Down
  		moveHighlightedInputField(key)
  	elseif(key == 'yellow') then

  	elseif(key == 'blue') then

  	end
	gfx.update()
end

--Main method
function main()
	buildGUI()

end
main()





