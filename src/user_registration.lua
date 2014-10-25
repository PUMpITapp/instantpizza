--TODO:
--Another background and text font/color
--Real graphic components
--Inputs from user, read and write
--Create user from input
--Buttons
--Transparency not working
--- Checks if the file was called from a test file.
-- Returs true if it was, 
--   - which would mean that the file is being tested.
-- Returns false if it was not,
--   - which wold mean that the file was being used.  
function checkTestMode()
  runFile = debug.getinfo(2, "S").source:sub(2,3)
  if (runFile ~= './' ) then
    underGoingTest = false
  elseif (runFile == './') then
    underGoingTest = true
  end
  return underGoingTest
end

--- Chooses either the actual or he dummy gfx.
-- Returns dummy gfx if the file is being tested.
-- Rerunes actual gfx if the file is being run.
function chooseGfx(underGoingTest)
  if not underGoingTest then
    tempGfx = require "gfx"
  elseif underGoingTest then
    tempGfx = require "gfx_stub"
  end
  return tempGfx
end

function chooseText(underGoingTest)
  if not underGoingTest then
    tempText = require "write_text"
  elseif underGoingTest then
    tempText = require "write_text_stub"
  end
  return tempText
end
local text = chooseText(checkTestMode())
local gfx =  chooseGfx(checkTestMode())
--Start of inputFields. Needed for 

inputFieldY = 150
local pizzaPicture = gfx.loadpng("images/pizza.png")
local progressBar = gfx.loadpng("images/progressbar1.png")
local nextButton = gfx.loadpng("images/buttonnext.png")
local logoName = gfx.loadpng("images/pizzaIP.png")
local backButton = gfx.loadpng("images/buttonback.png")
gfx.screen:fill({241,248,233,0})
gfx.update()

local sideSurface = gfx.new_surface(gfx.screen:get_width()/4, gfx.screen:get_height())
local logoSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height()/5)
local inputSurface = gfx.new_surface(gfx.screen:get_width()/1, gfx.screen:get_height())
local highlightSurface = gfx.new_surface(gfx.screen:get_width()/1, gfx.screen:get_height())
local statusSurface = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height()/5)


--Calls methods that builds GUI
function buildGUI()

displayLogo()
displaySideSurface()
displayInputSurface()
--displayHighlightSurface()
displaystatusSurface()

end


--Creates new surface and displays logo
function displayLogo()
	logoSurface:clear()
	logoSurface:fill({139,195,74})
	gfx.screen:copyfrom(logoSurface,nil,{x=0, y=25})
	png_logo_width = 250
	printPicture(logoName,(gfx.screen:get_width() - 740)/2,(gfx.screen:get_height()/5)-45)
	printPicture(pizzaPicture,gfx.screen:get_width()/5+420,(gfx.screen:get_height()/5)-110)
  --  gfx.screen:copyfrom(logo, nil, {x=gfx.screen:get_width()/2-(png_logo_width/2), y=100})
	gfx.update()
end
--Creates new surface and displays items on the left side
function displaySideSurface()
	sideSurface:clear()

	sideSurface:fill({241,248,233})
	gfx.screen:copyfrom(sideSurface,nil,{x=0, y=gfx.screen:get_height()/5})

	--Print text on sidemenu
	text.print(gfx.screen,arial,"Name",40,150,200,300)
	text.print(gfx.screen,arial,"Address",40,230,200,300)
	text.print(gfx.screen,arial,"Zip code",40,310,200,300)
	text.print(gfx.screen,arial,"City",40,390,200,300)
	text.print(gfx.screen,arial,"Phone",40,470,200,300)
	text.print(gfx.screen,arial,"E-mail",40,550,200,300)
	gfx.update()
end
function displayInputSurface()
	inputSurface:clear()
	inputSurface:fill({241,248,233})
	gfx.screen:copyfrom(inputSurface,nil,{x=gfx.screen:get_width()/4, y=gfx.screen:get_height()/5, h=gfx.screen:get_height()*(3/5)})
	--local highlight = gfx.loadpng("images/2.png")
	--printPicture(highlight,inputFieldX,inputFieldY)
	printPicture(nextButton,gfx.screen:get_width()-gfx.screen:get_width()/6, gfx.screen:get_height() - gfx.screen:get_height()/3)
	printPicture(backButton,gfx.screen:get_width()-(gfx.screen:get_width()/6)*2, gfx.screen:get_height() - gfx.screen:get_height()/3)
	gfx.update()

end

--Creates inputsurface and displays "highlighted" input
function displayHighlightSurface()
	--TODO:
	--Actual inputfields and higlight. Variable highlight is the actual highlight
	--that moves when user presses up and down.
	--Try transparent on box
	highlightSurface:clear()
	highlightSurface:fill({241,248,233})
	gfx.screen:copyfrom(inputSurface,nil,{x=gfx.screen:get_width()/4, y=gfx.screen:get_height()/5, h=gfx.screen:get_height()*(3/5), w=gfx.screen:get_width()/2})
	text.print(gfx.screen,arial,"Highlighted input",(gfx.screen:get_width()/4 + 5),inputFieldY,500,200)
	
	gfx.update()
end

function displaystatusSurface()

	statusSurface:clear()
	statusSurface:fill({241,248,233})
	gfx.screen:copyfrom(statusSurface,nil,{x=0,y=(gfx.screen:get_height()-gfx.screen:get_height()/5)})
	printPicture(progressBar, (gfx.screen:get_width() - 740)/2, gfx.screen:get_height()-gfx.screen:get_height()/5)
	gfx.update()
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
	if(state == 'up') then
	  	if(key == 'red') then
	  		--Up
	  		moveHighlightedInputField(key)
	  	elseif(key == 'green') then
	  		--Down
	  		moveHighlightedInputField(key)
	  	elseif(key == 'yellow') then

	  	elseif(key == 'blue') then
	  		dofile("choose_Pizzeria.lua")
	  	end
	gfx.update()
	end
end

--Main method
function main()
	buildGUI()

end
main()





