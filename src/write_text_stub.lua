local text = {}


arial = require "apple_symbols_regular_20"

function text.print(surface, font, text, x, y, w, h)
end

function text.getStringLength(font, text)
	local strLength = 0
	for i =1, #text do
		local c = text:sub(i,i)
		for j = 1, #font.chars do 
			local fc = font.chars[j]
			if fc.char == c then
				strLength = strLength + fc.width
			end
		end
	end	
	return strLength
end

function text.getFontHeight(font)
	return font.height
end


return text
