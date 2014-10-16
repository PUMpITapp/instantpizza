--TODO:

local text = require "write_text"
local gfx = require "gfx"

--Start of inputFields. Needed for 
local inputFieldY = 250
local inputFieldX = gfx.screen:get_width()/8

gfx.screen:fill({241,248,233})
gfx.update()

local logoSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height()/5)
local pizzeriaSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height()/2)
--local highlightSurface = gfx.new_surface(gfx.screen:get_width(), 80)


--Calls methods that builds GUI
function buildGUI()
	print(inputFieldX)
	displayLogo()
	--displayInputSurface()
	displayPizzerias()
end

--Creates new surface and displays logo
function displayLogo()
	logoSurface:clear()
	logoSurface:fill({139,195,74})
	gfx.screen:copyfrom(logoSurface,nil,{x=0, y=0})
	png_logo_width = 250
	text.print(gfx.screen,arial,"InstantPizza",gfx.screen:get_width()/2-220/2,50,220,300)
	text.print(gfx.screen,arial,"Pizzerias near you",gfx.screen:get_width()/2-320/2,160,320,300)
	gfx.update()
end
function displayPizzerias()
	--TODO
	--Get pizzerias
	pizzeriaSurface:clear()
	pizzeriaSurface:fill({241,248,233})
	gfx.screen:copyfrom(pizzeriaSurface,nil,{x=0, y=230})
	text.print(gfx.screen,arial,"Pizzeria 1",gfx.screen:get_width()/8,300,220,300)
	text.print(gfx.screen,arial,"Pizzeria 2",gfx.screen:get_width()/8+200,300,220,300)
	text.print(gfx.screen,arial,"Pizzeria 3",gfx.screen:get_width()/8+400,300,220,300)
	text.print(gfx.screen,arial,"Pizzeria 4",gfx.screen:get_width()/8+600,300,220,300)

	text.print(gfx.screen,arial,"Pizzeria 5",gfx.screen:get_width()/8,500,220,300)
	text.print(gfx.screen,arial,"Pizzeria 6",gfx.screen:get_width()/8+200,500,220,300)
	text.print(gfx.screen,arial,"Pizzeria 7",gfx.screen:get_width()/8+400,500,220,300)
	text.print(gfx.screen,arial,"Pizzeria 8",gfx.screen:get_width()/8+600,500,220,300)
	text.print(gfx.screen,arial,"Choose",inputFieldX,inputFieldY,140,50)
	gfx.update()
end
--Moves the current inputField
function moveHighlightedInputField(key)
	--Starting coordinates for current inputField
	 inputFieldStart = 150
	 inputFieldEnd = 550
	 print(inputFieldX)
	--Up
	if(key == 'Up')then
		if(inputFieldY == 450) then
			inputFieldY = 250
			displayPizzerias()
		end
	end
	--Down
	if(key == 'Down')then
		if(inputFieldY == 250)then
			inputFieldY = 450
			displayPizzerias()
		end
	end
	--Left
	if(key == 'Left')then
		if(inputFieldX > gfx.screen:get_width()/8) then
			inputFieldX = inputFieldX - 200
			displayPizzerias()
		elseif(inputFieldX == gfx.screen:get_width()/8)then
			inputFieldX = gfx.screen:get_width()/8+600
			displayPizzerias()
		end
	end
	--Down
	if(key == 'Right') then
		if(inputFieldX < gfx.screen:get_width()/8+600) then
			inputFieldX = inputFieldX + 200 
			displayPizzerias()
		elseif(inputFieldX == gfx.screen:get_width()/8+600)then
			inputFieldX = gfx.screen:get_width()/8
			displayPizzerias()

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
  		print("Hej")
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





