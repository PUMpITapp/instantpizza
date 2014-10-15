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
local inputFieldY = 150
local inputFieldX = 250

gfx.screen:fill({0,0,0,0})
gfx.update()

local logoSurface = gfx.new_surface(gfx.screen:get_width()/2, gfx.screen:get_height()/4)
local sideSurface = gfx.new_surface(gfx.screen:get_width()/4, gfx.screen:get_height())
local inputSurface = gfx.new_surface(gfx.screen:get_width()/1, gfx.screen:get_height())
local highlightSurface = gfx.new_surface(gfx.screen:get_width()/1, gfx.screen:get_height())

--Calls methods that builds GUI
function buildGUI()
displayLogo()
displaySideSurface()

--displayInputSurface()
displayHighlightSurface()
end

--Creates new surface and displays logo
function displayLogo()
	logoSurface:clear()
	logoSurface:fill({0,0,0})
	gfx.screen:copyfrom(logoSurface,nil,{x=0, y=0})
	png_logo_width = 250
	text.print(gfx.screen,arial,"InstantPizza",gfx.screen:get_width()/2-(png_logo_width/2),50,300,300)
  --  gfx.screen:copyfrom(logo, nil, {x=gfx.screen:get_width()/2-(png_logo_width/2), y=100})
	gfx.update()
end
--Creates new surface and displays items on the left side
function displaySideSurface()
	sideSurface:clear()
	sideSurface:fill({0,0,0})
	gfx.screen:copyfrom(sideSurface,nil,{x=0, y=200})
	--Print text on sidemenu
	text.print(gfx.screen,arial,"Pizza",20,150,200,300)

	text.print(gfx.screen,arial,"Soda",20,410,200,300)
	gfx.update()
end
function displayInputSurface()
	inputSurface:clear()
	inputSurface:fill({0,0,0,0})
	gfx.screen:copyfrom(inputSurface,nil,{x=160, y=200})
	local highlight = gfx.loadpng("images/2.png")
	printPicture(highlight,inputFieldX,inputFieldY)
	gfx.update()

end

--Creates inputsurface and displays "highlighted" input
function displayHighlightSurface()
	--TODO:
	--Actual inputfields and higlight. Variable highlight is the actual highlight
	--that moves when user presses up and down.
	--Try transparent on box
	highlightSurface:clear()
	highlightSurface:fill({255,0,0,0})
	gfx.screen:copyfrom(inputSurface,nil,{x=250, y=150})
	text.print(gfx.screen,arial,"Highlighted",inputFieldX,inputFieldY,500,200)
	gfx.update()
end

--Moves the current inputField
function moveHighlightedInputField(key)
	--Starting coordinates for current inputField
	 inputFieldStartY = 150
	 inputFieldStartX = 250
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
			inputFieldY = inputFieldStartY
			displayHighlightSurface()
		end
	end
	--Left
	if(key == 'yellow') then
		if(inputFieldX > 250) then
			inputFieldX = inputFieldX - 80
			if(inputFieldX < 250) then
				inputFieldX = inputFieldEnd
			end
			displayHighlightSurface()
		elseif(inputFieldX == 250) then
			inputFieldX = inputFieldEnd
			displayHighlightSurface()
		end
	end
	--Right
	if(key == 'blue') then
		if(inputFieldX < 550) then
			inputFieldX = inputFieldX + 80
			if(inputFieldX > 550) then
				inputFieldX = inputFieldStartX
			end
			displayHighlightSurface()
		elseif(inputFieldX == 550) then
			inputFieldX = inputFieldStartX
			displayHighlightSurface()
		end
	end
end

--Method that prints picture to screen. Takes picture and x,y coordinates as argument.
function printPicture(pic,xx,yy)
 	gfx.screen:copyfrom(pic, nil, {x=xx,y=yy})

end

function onKey(key,state)
  	if(key == 'red') then
  		--Up
  		moveHighlightedInputField(key)
  	elseif(key == 'green') then
  		--Down
  		moveHighlightedInputField(key)
  	elseif(key == 'yellow') then
  		moveHighlightedInputField(key)
  	elseif(key == 'blue') then
  		moveHighlightedInputField(key)
  	end
	gfx.update()
end

--Main method
function main()
	buildGUI()

end
main()




