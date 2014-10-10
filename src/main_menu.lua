--TODO:
--Real graphic components
--Inputs from user, read and write
--Create user from input
--Buttons
--

local gfx = require "gfx"
gfx.screen:fill({255,255,255,255})
gfx.update()

local logoSurface = gfx.new_surface(gfx.screen:get_width()/2, gfx.screen:get_height()/4)
local sideSurface = gfx.new_surface(gfx.screen:get_width()/4, gfx.screen:get_height())
local inputSurface = gfx.new_surface(gfx.screen:get_width()/1, gfx.screen:get_height())

--Starting coordinates for current inputField
local inputFieldX = 110
local inputFieldY = 160

png_numbers = {
	  num1 = 'images/1.png',
	  num2 = 'images/2.png',
	  num3 = 'images/3.png',
	  num4 = 'images/4.png',
	  num5 = 'images/5.png',
	  num6 = 'images/6.png',
	  num7 = 'images/7.png',
	  num8 = 'images/8.png',
	  num9 = 'images/9.png',
	  num0 = 'images/0.png',
}

--Calls methods that builds GUI
function buildGUI()

displayLogo()
displaySideSurface()
drawInputSurface()
end

--Creates new surface and displays logo
function displayLogo()
	logoSurface:clear()
	logoSurface:fill({255,255,255})
	gfx.screen:copyfrom(logoSurface,nil,{x=0, y=0})
	png_logo_width = 361 
	local logo = gfx.loadpng("images/logo.png")
    gfx.screen:copyfrom(logo, nil, {x=gfx.screen:get_width()/2-(png_logo_width/2), y=100})
	gfx.update()
end
--Creates new surface and displays items on the left side
function displaySideSurface()
	sideSurface:clear()
	sideSurface:fill({255,255,255})
	gfx.screen:copyfrom(sideSurface,nil,{x=0, y=200})
	gfx.update()
	--name
	local name = gfx.loadpng("images/1.png")
	printPicture(name,20,160)
	--adress
	local adress = gfx.loadpng("images/2.png")
	printPicture(adress,20,230)
	--postal
	local postal = gfx.loadpng("images/3.png")
	printPicture(postal,20,300)
	--phone
	local phone = gfx.loadpng("images/4.png")
	printPicture(phone,20,370)
	--email
	gfx.update()
end

--Creates inputsurface and displays "highlighted" input
function drawInputSurface()
	inputSurface:clear()
	inputSurface:fill({255,255,255})
	gfx.screen:copyfrom(inputSurface,nil,{x=120, y=200})
	local input = gfx.loadpng("images/0.png")
	printPicture(input,inputFieldX,inputFieldY)
	gfx.update()
end

--Moves the current inputField
function moveInputFields(key)
	if(key == 'red') then
		if(inputFieldY > 160) then
			inputFieldY = inputFieldY - 70
			drawInputSurface()
		end
	end
	if(key == 'green') then
		if(inputFieldY < 370) then
			inputFieldY = inputFieldY + 70
			drawInputSurface()
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
  		moveInputFields(key)
  	elseif(key == 'green') then
  		--Down
  		moveInputFields(key)
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





