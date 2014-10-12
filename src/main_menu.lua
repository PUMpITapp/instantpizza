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
local highlightSurface = gfx.new_surface(gfx.screen:get_width()/1, gfx.screen:get_height())


--Starting coordinates for current inputField
local inputFieldX = 150
local inputFieldY = 160
local inputFieldStart = 160
local inputFieldEnd = 510


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
displayHighlightSurface()
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
	sideSurface:fill({255,255,0})
	gfx.screen:copyfrom(sideSurface,nil,{x=0, y=200})
	gfx.update()
	--name
	local name = gfx.loadpng("images/1.png")
	printPicture(name,20,160)
	--adress
	local address = gfx.loadpng("images/2.png")
	printPicture(address,20,230)
	--postal
	local postal = gfx.loadpng("images/3.png")
	printPicture(postal,20,300)
	--phone
	local city = gfx.loadpng("images/4.png")
	printPicture(city,20,370)
	--phone
	local phone = gfx.loadpng("images/5.png")
	printPicture(phone,20,440)
	--email
	local email = gfx.loadpng("images/6.png")
	printPicture(email,20,510)
	gfx.update()
end
function displayInputSurface()


end

--Creates inputsurface and displays "highlighted" input
function displayHighlightSurface()
	--TODO:
	--Actual inputfields and higlight. Variable highlight is the actual highlight
	-- that moves when user presses up and down.
	inputSurface:clear()
	inputSurface:fill({255,255,255,0})
	gfx.screen:copyfrom(inputSurface,nil,{x=160, y=200})
	local highlight = gfx.loadpng("images/1.png")
	printPicture(highlight,inputFieldX,inputFieldY)
	gfx.update()
end

--Moves the current inputField
function moveHighlightedInputField(key)
	--Up
	if(key == 'red') then
		if(inputFieldY > 160) then
			inputFieldY = inputFieldY - 70
			displayHighlightSurface()
		elseif(inputFieldY == 160) then
			inputFieldY = inputFieldEnd
			displayHighlightSurface()
		end
	end
	--Down
	if(key == 'green') then
		if(inputFieldY < 510) then
			inputFieldY = inputFieldY + 70
			displayHighlightSurface()
		elseif(inputFieldY == 510) then
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





