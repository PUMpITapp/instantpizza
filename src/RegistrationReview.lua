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
--- Chooses the text
-- @return #string tempText Returns write_text_stub if the file is being tested, returns actual write_text if the file is being run.
function chooseText()
  if not checkTestMode() then
    tempText = require "write_text"
  elseif checkTestMode() then
    tempText = require "write_text_stub"
  end
  return tempText
end

--- Checks if the program is run on the box or not
if onBox == true then
  package.path = package.path .. ';' .. sys.root_path() .. 'Images/UserRegistrationPics/?.png'
  dir = sys.root_path()
else
  gfx =  chooseGfx(checkTestMode())
  sys = {}
  sys.root_path = function () return '' end
  dir = ""
end
--- Variable to use when displaying printed text on the screen
--- Determine whether to use the stub or to run the actual file
local text = chooseText()
--- Variable to use when handling tables that are stored in the system
local io = require "IOHandler"

--- Handle forms from last step and initiate a new form for this step
local lastForm = ...
local newForm = {}
---Creates x,y units of the screen.
local xUnit = gfx.screen:get_width()/16
local yUnit = gfx.screen:get_height()/9
---Startposition for y,x.
local startPosY = yUnit * 2.8
local startPosX = xUnit*3.40
---Sets a flag used in Menu.lua later. Decides if user has edited or created a new user.
local accountAction = ""

---Function that checks lastForm and sets its values to newForm. 
function checkForm()
  if type(lastForm) == "string" then

  else
    if lastForm then
      newForm = lastForm
    end
  end
end

---Calls methods that builds GUI.
function buildGUI()
  displayBackground()
  displayRegistrationInformation()
  gfx.update()
end

---Displays the background image.
function displayBackground()
  local backgroundPNG = gfx.loadpng("Images/UserRegistrationPics/registrationreview.png")
  backgroundPNG:premultiply()
  gfx.screen:copyfrom(backgroundPNG, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  backgroundPNG:destroy()
end

---Displays information the user has entered in previous steps. 
function displayRegistrationInformation()
  if checkTestMode() then
  else
    text.print(gfx.screen,"lato","black","small", "Name: "..tostring(newForm.name), startPosX, startPosY, 500, 500)
    text.print(gfx.screen,"lato","black","small", "Address: "..tostring(newForm.address), startPosX,startPosY+(yUnit*0.5),500,500)
    text.print(gfx.screen,"lato","black","small", "ZipCode: "..tostring(newForm.zipCode), startPosX,startPosY+(yUnit*1),500,500)
    text.print(gfx.screen,"lato","black","small", "City: "..tostring(newForm.city), startPosX,startPosY+(yUnit*1.5),500, 500)
    text.print(gfx.screen,"lato","black","small", "Phone: "..tostring(newForm.phone), startPosX,startPosY+(yUnit*2) ,500, 500)
    text.print(gfx.screen,"lato","black","small", "Email: "..tostring(newForm.email), startPosX,startPosY+(yUnit*2.5),500, 50)
    text.print(gfx.screen,"lato","black","small", "Pizzeria: "..tostring(newForm.pizzeria.name), startPosX,startPosY+(yUnit*3),500, 50)
    local pizzaText = ""
    for i=1,#newForm.pizzeria.userPizzas do
      length = #newForm.pizzeria.userPizzas
      if(length == i)then
        pizzaText = pizzaText.." "..newForm.pizzeria.userPizzas[i].name
      else
        pizzaText = pizzaText..newForm.pizzeria.userPizzas[i].name..", "
      end
    end
    text.print(gfx.screen,"lato","black","small", "Pizzas: "..tostring(pizzaText), startPosX,startPosY+(yUnit*3.5),500, 50)
  end
end

---Saves the account. If editMode exists updateUser is called in IOHandler, otherwise saveUser is called.
function saveAccount()
  newForm.pizzeria.pizzas = newForm.pizzeria.userPizzas
  newForm.pizzeria.userPizzas = nil
  if not(newForm.editMode == nil)then
    io.updateUser(newForm)
    accountAction = "Edit"
  else
    io.saveUserData(newForm)
    accountAction = "Create"
  end
end
---On key function, called when user press a key.
-- @param #string key The key that has been pressed
-- @param #string state The state of the key-press (up,down)
-- @return #string pathName The path that the program shall be directed to
function onKey(key,state)
	if(state == 'up') then
	  	if(key == 'yellow') then
	  		--Save account and go to menu
        saveAccount()
        pathName = dir .. "Menu.lua"
        if checkTestMode() then
          return pathName
        else
          assert(loadfile(pathName))(accountAction)
        end
      elseif(key == 'green') then
        --Go back to menu
        pathName = dir .. "Menu.lua"
        if checkTestMode() then
          return pathName
        else
          dofile(pathName)
        end
      elseif(key == 'red') then
        --Go back to menu
        pathName = dir .. "RegistrationStep3.lua"
        if checkTestMode() then
          return pathName
        else
          assert(loadfile(pathName))(lastForm)
        end
	  	end
	end
end

---Main method
function onStart()
  checkForm()
	buildGUI()
end
onStart()





