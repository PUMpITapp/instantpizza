local gfx = {}

--------------------------------------------------------------------------------
--- Surface Class
--------------------------------------------------------------------------------

Surface = {}

function Surface:new(w, h)
  dummyTable = { cref ="dummySurface" }
  self.__index = self
  return setmetatable(dummyTable, self)
end

function Surface:newJPEG(path)
  dummyTable = { cref = dummySurface }
  self.__index = self
  return setmetatable(dummyTable, self)
end

function Surface:newPNG(path)
  dummyTable = { cref = dummySurface }
  self.__index = self
  return setmetatable(dummyTable, self)
end

function Surface:getDefaultSurface()
  dummyTable = { cref = dummySurface }
  self.__index = self
  return setmetatable(dummyTable, self)
end

function Surface:clear(c, r)
  --surface_clear(self.cref, c, r)
end

function Surface:fill(c, r)
end

function Surface:copyfrom(ss, sr, dr, b)
end

function Surface:get_width()
  return 100
end

function Surface:get_height()
  return 100
end

function Surface:get_pixel(x, y)
end

function Surface:set_pixel(x, y, c)
end

function Surface:premultiply()
end

function Surface:destroy()
end


--------------------------------------------------------------------------------
--- GFX Module definitions
--------------------------------------------------------------------------------
gfx.screen = Surface:getDefaultSurface()

function gfx.set_auto_update()
end

function gfx.new_surface(w, h)
    return Surface:new(w, h)
end

function gfx.get_memory_use()
end

function gfx.get_memory_limit()
end

function gfx.update()
end

function gfx.loadpng(path)
  return Surface:newPNG('dummy')
end

function gfx.loadjpeg(path)
  return Surface:newJPEG('dummy')
end


return gfx  


