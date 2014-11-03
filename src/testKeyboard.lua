local gfx = require "gfx"
local keyboardClass = require "keyboard"
gfx.screen:fill({0,0,0,0})
gfx.update()

local function main()
	keyboardClass:displayKeyboard()
	-- dofile("keyboard.lua")
end

-- local function onKey(key, state)
-- 	if(state == 'up')then
-- 		if(key == "N") then
-- 			print("yellow")
-- 			-- dofile("keyboard.lua")

-- 		elseif(key == "K") then
-- 			keyboardClass:displayKeyboard()
-- 			dofile("keyboard.lua")
-- 		end
-- 	end
-- end

main()