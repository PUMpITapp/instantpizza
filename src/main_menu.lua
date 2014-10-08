gfx = require "gfx"
gfx.screen:fill({255,255,255,255})
gfx.update()

-- Directory of artwork
dir = './'
	
-- All the numbers as .png pictures with transparent background
-- with size:
png_logo_width = 361 
png_logo_height = 100 
	
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
function buildGUI()
-- Logo
displayLogo()
--Buttons
--displayButtons()
--Text
--printText(Text)
end

function displayLogo()

	local logo = gfx.loadpng("images/logo.png")
    gfx.screen:copyfrom(logo, nil, {x=gfx.screen:get_width()/2-(png_logo_width/2), y=100})
	gfx.update()

end

function displayButtons()
--TODO
--Code to display buttons
--Use table with images of buttons

end

function onKey(key,state)
  if(key == 'red') then
  elseif(key == 'green') then
  elseif(key == 'yellow') then
  elseif(key == 'blue') then
  end
	gfx.update()
end

function main()
buildGUI()

end
main()





