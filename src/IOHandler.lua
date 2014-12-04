local ioHandler = {}

--- Set if the program is running on the box or not
local onBox = true
progress = "IOhandler"
--- Change the path system if the app runs on the box comparing to the emulator
if onBox == true then
  dir = sys.root_path()
else
    sys = {}
    sys.root_path = function () return '' end
    dir = ""
end
dofile(dir .. "table.save.lua")

---Function that is used to create a new user.
--@param name is the users name
--@param address is the users address
--@param zipCode is the users zipCode
--@param city is the users city
--@param phone is the users phonenumber
--@param email is the users email address
--@param pizzeria is the pizzeria the user selects
User = {}
function User:new(name,address,zipCode,city,phone,email,pizzeria)
  newObj ={
  name = name,
  address = address,
  zipCode = zipCode,
  city = city,
  phone = phone,
  email = email,
  pizzeria = pizzeria,
  }
  self.__index = self
  return setmetatable(newObj, self)
end
---Function that is used to create a new pizzeria.
--@param name is the pizzerias name
--@param city is the pizzerias city
--@param zipCode is the pizzerias zipCode
--@param phoneNr is the pizzerias phonenumber
--@param imgPath is the pizzerias path to the logotype
--@param rating is the rating of the pizzeria
--@param pizzas is the pizzerias pizzas in a table
--@param drinks is the pizzerias drinks in a table
Pizzeria = {}
function Pizzeria:new(name,city,zipCode,phoneNr,imgPath,rating,pizzas,drinks)
  newObj = {
  name = name,
  city = city,
  zipCode = zipCode,
  phoneNr = phoneNr,
  imgPath = imgPath,
  rating = rating,
  pizzas = pizzas,
  drinks = drinks
  }
  self.__index = self
  return setmetatable(newObj, self)
end
---Function that is used to create new pizzas.
--@param name is the name of the pizza
--@param price is the price of the pizza
--@param ingredients is the ingredients of the pizza
Pizza = {}
function Pizza:new(name,price,ingredients)
  newObj = {
  name = name,
  price = price,
  ingredients = ingredients
  }
  self.__index = self
  return setmetatable(newObj, self)
end
---Function that is used to create new drinks
--@param name is the name och the drink
--@param price is the price of the drink
Drink = {}
function Drink:new(name,price)
  newObj = {
  name = name,
  price = price
  }
  self.__index = self
  return setmetatable(newObj, self)
end

---Function to read users from file
--@return of users
function ioHandler.readUserData()
  local usersTable = {}
  usersTable = table.load(dir .. "UserData.lua")
  return usersTable
end
---Function to read pizzerias from file
--@return of pizzerias
function ioHandler.readPizzerias()
  local pizzeriaTable = {}
  pizzeriaTable = table.load(dir .. "PizzeriaData.lua")
  return pizzeriaTable
end
---Test function that reads pizzerias from file
--@return of pizzerias
function ioHandler.readPizzerias_test()
  local pizzeriaTable = {}
  pizzeriaTable = table.load(dir .. "PizzeriaData_testing.lua")
  return pizzeriaTable
end
---Function that adds lots dummy pizzerias and pizzas
function ioHandler.addTestPizzerias()
  drinks ={}
  pizzas = {}
  pizzeriasTable = {}

  --Create drinks
  Drink1 = Drink:new("Coca cola","10")
  Drink2 = Drink:new("Fanta","10")
  Drink3 = Drink:new("Ramlösa","10")
  Drink4 = Drink:new("Julmust","10")

  --Creates pizzas. {name,price,{ingredients}}
  Pizza1 = Pizza:new("Vesuvio","70",{"Skinka","Ost"})
  Pizza2 = Pizza:new("Kebab","75",{"Skinka","Ost","Kebab"})
  Pizza3 = Pizza:new("Mexicana","70",{"Skinka","Ost","Taco"})
  Pizza4 = Pizza:new("Azteka","65",{"Skinka","Ost","Jalapenos"})
  Pizza5 = Pizza:new("Kebab Special","70",{"Kebab","Ost","Pommes"})
  Pizza6 = Pizza:new("Kebabtallrik","65",{"Kebab","Pommes","Sallad"})
  Pizza7 = Pizza:new("Kebabrulle","70",{"Kebab","Bröd","Sås"})
  Pizza8 = Pizza:new("Hawaii","60",{"Skinka","Ost","Ananas"})
  Pizza9 = Pizza:new("Poker","85",{"Oxfile","Ost","Champinjoner"})
  Pizza10 = Pizza:new("Salami","75",{"Salami","Ost"})
  Pizza11 = Pizza:new("Vegetaria","60",{"Champinjoner","Ost","Oliver"})
  Pizza12 = Pizza:new("Capricciosa","60",{"Skinka","Ost","Champinjoner"})
  Pizza13 = Pizza:new("Tono","80",{"Tonfisk","Ost"})
  Pizza14 = Pizza:new("Margaritha","60",{"Ost"})
  Pizza15 = Pizza:new("Tutti frutti","60",{"Ost","Ananas","Banan"})
  Pizza16 = Pizza:new("Calzone","65",{"Inbakad","Skinka","Ost"})
  Pizza17 = Pizza:new("Honolulu","60",{"Banan","Ost","Ananas"})
  Pizza18 = Pizza:new("Kycklingpizza","60",{"Kyckling","Ost","Curry"})
  Pizza19 = Pizza:new("Opera","70",{"Salami","Ost","Oliver"})
  Pizza20 = Pizza:new("Disco","80",{"Korv","Fisk","BBQ"})

  --Put drink1 and 2  into table drinks
  drinks[1] = Drink1
  drinks[2] = Drink2
  drinks[3] = Drink3
  drinks[4] = Drink4

  --Put pizzas into pizzas table
  pizzas[1] = Pizza1
  pizzas[2] = Pizza2
  pizzas[3] = Pizza3
  pizzas[4] = Pizza4
  pizzas[5] = Pizza5
  pizzas[6] = Pizza6
  pizzas[7] = Pizza7
  pizzas[8] = Pizza8
  pizzas[9] = Pizza9
  pizzas[10] = Pizza10
  pizzas[11] = Pizza11
  pizzas[12] = Pizza12
  pizzas[13] = Pizza13
  pizzas[14] = Pizza14
  pizzas[15] = Pizza15
  pizzas[16] = Pizza16
  pizzas[17] = Pizza17
  pizzas[18] = Pizza18
  pizzas[19] = Pizza19
  pizzas[20] = Pizza20

  --Create pizzerias
  Pizzeria1 = Pizzeria:new("Pizzeria Mona Lisa","Linköping","58434","010-1111111","pizza1.png","5.0",pizzas,drinks)
  Pizzeria2 = Pizzeria:new("Pizzeria Baguetten","Linköping","58436","010-1111112","pizza2.png","5.0",pizzas,drinks)
  Pizzeria3 = Pizzeria:new("Pizzeria Florens","Linköping","58220","010-1111113","pizza3.png","5.0",pizzas,drinks)
  Pizzeria4 = Pizzeria:new("Pizzeria Bari","Linköping","58217","010-1111114","pizza4.png","5.0",pizzas,drinks)
  Pizzeria5 = Pizzeria:new("Pizzeria Victoria","Linköping","58234","010-1111115","pizza5.png","5.0",pizzas,drinks)
  Pizzeria6 = Pizzeria:new("Pizzeria La Luna","Linköping","58214","010-1111116","pizza6.png","5.0",pizzas,drinks)
  Pizzeria7 = Pizzeria:new("Pizzafiket","Linköping","58233","010-1111117","pizza7.png","5.0",pizzas,drinks)
  Pizzeria8 = Pizzeria:new("Mamma Mia","Linköping","58232","010-1111118","pizza8.png","5.0",pizzas,drinks)
  Pizzeria9 = Pizzeria:new("Pizzeria Montecarlo","Linköping","58248","010-1111119","pizza9.png","5.0",pizzas,drinks)
  Pizzeria10 = Pizzeria:new("Pizzeria Tropicana","Linköping","58726","010-1111110","pizza10.png","5.0",pizzas,drinks)
  --Put pizzerias in table
  pizzeriasTable[1] = Pizzeria1
  pizzeriasTable[2] = Pizzeria2
  pizzeriasTable[3] = Pizzeria3
  pizzeriasTable[4] = Pizzeria4
  pizzeriasTable[5] = Pizzeria5
  pizzeriasTable[6] = Pizzeria6
  pizzeriasTable[7] = Pizzeria7
  pizzeriasTable[8] = Pizzeria8
  pizzeriasTable[9] = Pizzeria9
  pizzeriasTable[10] = Pizzeria10
  table.save(pizzeriasTable,dir .. "PizzeriaData.lua")
end

---Function that saves userdata.
--@param userForm is the user that is being saved. 
function ioHandler.saveUserData(userForm)
  tempUserTable = {}
  usersTable = {}
  j=1
  user = User:new(userForm.name,userForm.address,userForm.zipCode,userForm.city,userForm.phone,userForm.email,userForm.pizzeria)
  ---Read users from file so previous users are not overwritten 
  tempUserTable = ioHandler.readUserData()
  if not (tempUserTable == nil)then
    for i=1,#tempUserTable do
    usersTable[j]=tempUserTable[i]
    j=j+1
    end
  end
  usersTable[j]=user
  table.save(usersTable,dir .. "UserData.lua")
end
---Function that saves a table of users to file
--@param userTable is the table of users that are going to be saved
function ioHandler.saveUserTable(userTable)
  table.save(userTable,dir .. "UserData.lua")
end
---Function that updates userdata
--@param userForm is the user being edited
function ioHandler.updateUser(userForm)
  users = table.load(dir .. "UserData.lua")
  table.remove(users,userForm.editIndex)
  ioHandler.saveUserTable(users)
  ioHandler.saveUserData(userForm)
end
return ioHandler
