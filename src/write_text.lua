local text = {}

--- Prints text to the screen
-- @param surface The surface to print to
-- @param fontFace The font to use, possible values: 'lora', 'lato'
-- @param fontSize The font size to use, measured in pixel height
-- @param text The text to print
-- @param x X coordinate of upper left corner to start printing from
-- @param y Y coordinate of upper left corner to start printing from
-- @param w Width of textbox
-- @param h Height of textbox

local onBox = true
local gfx = require "gfx"

if onBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'fonts/spritesheets/?.png'
  package.path = package.path .. ';' .. sys.root_path() .. 'fonts/lookups/?.lua'
  dir = sys.root_path()
else
  gfx = require "gfx"
    sys = {}
    sys.root_path = function () return '' end
    dir = ""
end
function text.print(surface, fontFace, fontColor, fontSize, text, x, y, w, h)
  fontFace = string.lower(fontFace)
  fontColor = string.lower(fontColor)
  fontSize = string.lower(fontSize)
  -- Check that params are valid
  if (fontFace ~= 'lato' and fontFace ~= 'lora') then
    print('fontFace not found, should be lato or lora')
    return false
  elseif (fontSize ~= 'small' and fontSize ~= 'medium' and fontSize ~= 'large') then
    print('fontsize not found, should be small, medium or large')
    return false
  end

  local font = require ("fonts/lookups/" .. fontFace .. "_" .. fontSize)
  local font_spritesheet = gfx.loadpng("fonts/spritesheets/" .. fontFace .. "_" .. fontSize .. "_" .. fontColor .. ".png")

  local sx = x -- Start x position on the surface
  local surface_w = surface:get_width()
  local surface_h = surface:get_height()

  if w == nil or w > surface_w then
      w = surface_w
  end

  if h == nil or h > surface_h then
      h = surface_h
  end

  for i = 1, #text do -- For each character in the text
      local c = text:sub(i,i) -- Get the character
      for j = 1, #font.chars do -- For each character in the font
          local fc = font.chars[j] -- Get the character information
          if fc.char == c then
              if x + fc.width > sx + w then -- If the text is gonna be out the surface, popup a new line
                  x = math.floor(sx)
                  y = y + font.height
              end

              dx = math.floor(x + fc.ox) -- dx is the x positon of the character, some characters need offset
              dy = math.floor(y + font.metrics.ascender - fc.oy) -- dy is the y position of the character, some characters need offset

              surface:copyfrom(font_spritesheet, {x=fc.x, y=fc.y, w=fc.w, h=fc.h}, {x=dx, y=dy, w = fc.w, h = fc.h}, true)

              x = math.floor(x + fc.width) -- add offset for next character

              break
          end
      end
  end
end

--- Returns the width of the string in pixels
-- @param fontFace The font-face to check the width of
-- @param fontSize The font size to cehck the width of
-- @param text The text that is being mesured
-- @return integer The width of the tested string in px
function text.getStringLength(fontFace, fontSize, text)
  font = require ("fonts/lookups/" .. fontFace .. "_" .. fontSize)

  local strLength = 0

  for i = 1, #text do
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

--- Returns the height of the font
-- @param fontFace The fontFace to get the height of
-- @param fontSize The font size to get the height of
-- @return integer The height of the requested font
function text.getFontHeight(fontFace, fontSize)
  font = require ("fonts/lookups/" .. fontFace .. "_" .. fontSize)
  return font.height
end

--[[ Print some text for test purposes.

gfx = require "gfx"
gfx.screen:clear({218,218,218})
gfx.update()

text.print(gfx.screen, 'lato', 'white', 'small', "Test", 0, 0, 500, 500)
text.print(gfx.screen, 'lato', 'white', 'medium', "Test", 150, 0, 500, 500)
text.print(gfx.screen, 'lato', 'white', 'large', "Test", 300, 0, 500, 500)

text.print(gfx.screen, 'lato', 'black', 'small', "Test", 0, 100, 500, 500)
text.print(gfx.screen, 'lato', 'black', 'medium', "Test", 150, 100, 500, 500)
text.print(gfx.screen, 'lato', 'black', 'large', "Test", 300, 100, 500, 500)

text.print(gfx.screen, 'lora', 'white', 'small', "Test", 0, 200, 500, 500)
text.print(gfx.screen, 'lora', 'white', 'medium', "Test", 150, 200, 500, 500)
text.print(gfx.screen, 'lora', 'white', 'large', "Test", 300, 200, 500, 500)

text.print(gfx.screen, 'lora', 'black', 'small', "Test", 0, 300, 500, 500)
text.print(gfx.screen, 'lora', 'black', 'medium', "Test", 150, 300, 500, 500)
text.print(gfx.screen, 'lora', 'black', 'large', "Test", 300, 300, 500, 500)

--]]

return text
