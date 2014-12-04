--- Tells if the program shall be run on the box or not
local onBox = true

--- Checks if the file was called from a test file.
-- @return #boolean true if called from a test file, indicating the file is being tested, else false
function checkTestMode()
  runFile = debug.getinfo(2, "S").source:sub(2,3)
  if (runFile ~= './' ) then
    underGoingTest = false
  elseif (runFile == './') then
    underGoingTest = true
  end
  return underGoingTest
end

--- Chooses either the actual or the dummy gfx.
-- @return #string tempGfx Returns dummy gfx if the file is being tested, returns actual gfx if the file is being run.
function chooseGfx()
  if not checkTestMode() then
    tempGfx = require "gfx"
  elseif checkTestMode() then
    tempGfx = require "gfx_stub"
  end
  return tempGfx
end

--- Checks if the program is run on the box or not
if onBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/MenuPics/?.png'
  dir = sys.root_path()
else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
end

--- Variable that fetches the order content from previous step
local order=...

--- Function that builds GUI
function buildGUI()
  local backgroundPNG = gfx.loadpng("Images/Pending/Pendingpage.png")
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
  gfx.update()
end

--- Function that checks if the box is connected to our server or not
function internet(order)
        local sock = require("socket")
        local tcp=sock.tcp()
        tcp:connect("pumi-2.ida.liu.se", 88)
        print("connecting")
        tcp:send(order.."\n")
        local s,status, partial = tcp:receive()
        --print(status)
        --print(partial)
        tcp:close()
        if(s==nil)then
                return 0
        end
        return s
end

--- Main method
function onStart()
	buildGUI()
	
	order["time"]=internet(order.pizzeria.name)
	local pathName=""
	if(order.time~=0)then
		pathName = dir .. "OrderStep4.lua"
	else
		pathName = dir .. "OrderFail.lua"
	end
	assert(loadfile(pathName))(order)
end
onStart()