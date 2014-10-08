--Displays main registration menu
--TODO
--

gfx = require "gfx"
gfx.screen:fill({255,255,255,255})
gfx.update()

-- Directory of artwork
dir = './'
-- All the numbers as .png pictures with transparent background
-- with size:
png_logo_width = 361 
png_logo_height = 100 
	
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





