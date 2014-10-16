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
local inputFieldY = gfx.screen:get_height()/5
local inputFieldX = 0

gfx.screen:fill({0,0,255})
gfx.update()

local logoSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height()/5)
local sideSurface = gfx.new_surface(gfx.screen:get_width()/4, gfx.screen:get_height())
local inputSurface = gfx.new_surface(gfx.screen:get_width()/1, gfx.screen:get_height()*(3/5))
local highlightSurface = gfx.new_surface(gfx.screen:get_width()/1, gfx.screen:get_height())
local statusSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height()/5)

--Calls methods that builds GUI
function buildGUI()
displayLogo()
--displaySideSurface()
displaystatusSurface()
displayInputSurface()

--displayInputSurface()
--displayHighlightSurface()
end

--Creates new surface and displays logo
function displayLogo()
	logoSurface:clear()
	logoSurface:fill({0,155,0})
	gfx.screen:copyfrom(logoSurface,nil,{x=0, y=0})
	png_logo_width = 250
	text.print(gfx.screen,arial,"InstantPizza",gfx.screen:get_width()/2-(png_logo_width/2),50,300,300)
  --  gfx.screen:copyfrom(logo, nil, {x=gfx.screen:get_width()/2-(png_logo_width/2), y=100})
	gfx.update()
end
--Creates new surface and displays items on the left side
function displaySideSurface()
	sideSurface:clear()
	sideSurface:fill({155,0,0})
	gfx.screen:copyfrom(sideSurface,nil,{x=0, y=gfx.screen:get_height()/5})
	--Print text on sidemenu
	text.print(gfx.screen,arial,"Pizza",20,150,200,300)

	text.print(gfx.screen,arial,"Soda",20,410,200,300)
	gfx.update()
end
function displayInputSurface()
	inputSurface:clear()
	inputSurface:fill({0,0,155})
	gfx.screen:copyfrom(inputSurface,nil,{x=0, y=gfx.screen:get_height()/5, h=gfx.screen:get_height()*(3/5)})
	--local highlight = gfx.loadpng("images/2.png")
	--printPicture(highlight,inputFieldX,inputFieldY)
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
	 inputFieldStartY = gfx.screen:get_height()/5
	 inputFieldStartX = 0
	 inputFieldEndY = gfx.screen:get_height()*(4/5)
	 inputFieldEndX = gfx.screen:get_width()
	--Up
	if(key == 'red') then
		if(inputFieldY > gfx.screen:get_height()/5) then
			inputFieldY = inputFieldY - gfx.screen:get_height()/10
			displayHighlightSurface()
		elseif(inputFieldY == gfx.screen:get_height()/5) then
			inputFieldY = inputFieldEndY
			displayHighlightSurface()
		end
	end
	--Down
	if(key == 'green') then
		if(inputFieldY < gfx.screen:get_width()) then
			inputFieldY = inputFieldY + gfx.screen:get_height()/10
			displayHighlightSurface()
		elseif(inputFieldY == gfx.screen:get_width()) then
			inputFieldY = inputFieldStartY
			displayHighlightSurface()
		end
	end
	--Left
	if(key == 'yellow') then
		if(inputFieldX > 0) then
			inputFieldX = inputFieldX - 80
			if(inputFieldX < 0) then
				inputFieldX = inputFieldEndX
			end
			displayHighlightSurface()
		elseif(inputFieldX == 0) then
			inputFieldX = inputFieldEnd
			displayHighlightSurface()
		end
	end
	--Right
	if(key == 'blue') then
		if(inputFieldX < gfx.screen:get_width()) then
			inputFieldX = inputFieldX + 80
			if(inputFieldX > gfx.screen:get_width()) then
				inputFieldX = inputFieldStartX
			end
			displayHighlightSurface()
			print(inputFieldX)
		elseif(inputFieldX == gfx.screen:get_width()) then
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
  	if(key == 'red' and state == 'up') then
  		--Up
  		moveHighlightedInputField(key)
  	elseif(key == 'green' and state == 'up') then
  		--Down
  		moveHighlightedInputField(key)
  	elseif(key == 'yellow' and state == 'up') then
  		moveHighlightedInputField(key)
  	elseif(key == 'blue' and state == 'up') then
  		moveHighlightedInputField(key)
  	end
	gfx.update()
end

--Main method
function main()
	buildGUI()

end
main()





