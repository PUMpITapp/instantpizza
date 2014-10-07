local gfx = {}

--------------------------------------------------------------------------------
--- Surface Class
--------------------------------------------------------------------------------

Surface = {}

function Surface:new(w, h)
  o = { cref=surface_new(w, h) }
  self.__index = self
  return setmetatable(o, self)
end

function Surface:newJPEG(path)
  o = { cref=gfx_loadjpeg(path) }
  self.__index = self
  return setmetatable(o, self)
end

function Surface:newPNG(path)
  o = { cref=gfx_loadpng(path) }
  self.__index = self
  return setmetatable(o, self)
end

function Surface:getDefaultSurface()
  o = { cref=surface_get_window_surface() }
  self.__index = self
  return setmetatable(o, self)
end

function Surface:clear(c, r)
  surface_clear(self.cref, c, r)
end

function Surface:fill(c, r)
  surface_fill(self.cref, c, r)
end

function Surface:copyfrom(ss, sr, dr, b)
  surface_copyfrom(self.cref, ss.cref, sr, dr, b)
end

function Surface:get_width()
  return surface_get_width(self.cref)
end

function Surface:get_height()
  return surface_get_height(self.cref)
end

function Surface:get_pixel(x, y)
  print("Not implemented yet.")
end

function Surface:set_pixel(x, y, c)
  print("Not implemented yet.")
end

function Surface:premultiply()
  surface_premultiply(self.cref)
end

function Surface:destroy()
  surface_destroy(self.cref)
end


--------------------------------------------------------------------------------
--- GFX Module definitions
--------------------------------------------------------------------------------
gfx.screen = Surface:getDefaultSurface()

function gfx.set_auto_update()
  return gfx_set_auto_update()
end

function gfx.new_surface(w, h)
  if w < 0 or h > 9999 then
    error("invalid width")
  end
  if w < 0 or h > 9999 then
    error("invalid height")
  end
  return Surface:new(w, h)
end

function gfx.get_memory_use()
  return gfx_get_memory_use()
end

function gfx.get_memory_limit()
  return gfx_get_memory_limit()
end

function gfx.update()
  return gfx_update()
end

function gfx.loadpng(path)
  return Surface:newPNG(path)
end

function gfx.loadjpeg(path)
  return Surface:newJPEG(path)
end

return gfx
