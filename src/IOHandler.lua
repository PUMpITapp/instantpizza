local ioHandler = {}

dofile("table.save.lua")
--Create new user
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
--Create new pizzeria. Each pizzeria object has one table of pizzas. 
Pizzeria = {}
function Pizzeria:new(name,imgPath,rating,pizzas,drink)
  newObj = {
  id = id,
  name = name,
  imgPath = imgPath,
  rating = rating,
  pizzas = pizzas,
  drink = drink
  }
  self.__index = self
  return setmetatable(newObj, self)
end
--Create pizza
Pizza = {}
function Pizza:new(name,price)
  newObj = {
  name = name,
  price = price
  }
  self.__index = self
  return setmetatable(newObj, self)
end
--Create drinks
Drink = {}
function Drink:new(name,price)
  newObj = {
  name = name,
  price = price
  }
  self.__index = self
  return setmetatable(newObj, self)
end
--Function to read users. Users are stored in a table containing user "objects"
function ioHandler.readUserData()
  local usersTable = {}
  usersTable = table.load("UserDB.lua")
  return usersTable
end
-- Function to read pizzerias. Are stored in a table, every pizzeria has a table of pizzas. 
function ioHandler.readPizzerias()
  local pizzeriaTable = {}
  pizzeriaTable = table.load("PizzeriaData.lua")
  --print(pizzeriaTable[1].name)
  return pizzeriaTable
end
function ioHandler.addTestPizzerias()
  drinks ={}
  drinks2 = {}
  pizzas = {}
  pizzas2 = {}
  pizzeriasTable = {}

  Drink1 = Drink:new("Coca cola","10")
  Drink2 = Drink:new("Fanta","10")
  Drink3 = Drink:new("Ramlösa","10")
  Drink4 = Drink:new("Julmust","10")

  Pizza1 = Pizza:new("Vesuvio","70")
  Pizza2 = Pizza:new("Kebab","75")
  Pizza3 = Pizza:new("Mexicana","70")
  Pizza4 = Pizza:new("Azteka","65")
  Pizza5 = Pizza:new("Kebab Special","70")
  Pizza6 = Pizza:new("Kebabtallrik","65")
  Pizza7 = Pizza:new("Kebabrulle","70")
  Pizza8 = Pizza:new("Hawaii","60")

  drinks[1] = Drink1
  drinks[2] = Drink2
  drinks2[1] = Drink3
  drinks2[2] = Drink4
  pizzas[1] = Pizza1
  pizzas[2] = Pizza2
  pizzas[3] = Pizza3
  pizzas[4] = Pizza4
  pizzas2[1] = Pizza5
  pizzas2[2] = Pizza6
  pizzas2[3] = Pizza7
  pizzas2[4] = Pizza8

  Pizzeria1 = Pizzeria:new("Pizzeria Mona Lisa","pizza1.png","5.0",pizzas,drinks)
  Pizzeria2 = Pizzeria:new("Pizzeria Baguetten","pizza2.png","5.0",pizzas2,drinks2)
  pizzeriasTable[1] = Pizzeria1
  pizzeriasTable[2] = Pizzeria2
  table.save(pizzeriasTable,"PizzeriaData.lua")
end


--Function to save user to file. Appends string from userForm and saves it to file, file info i appended so nothing is overwritten. 
function ioHandler.saveUserData(userTable)
  user = User:new(userTable.name,userTable.address,userTable.zipCode,userTable.city,userTable,phone,userTable.email,userTable.pizzeria)
  table.save(user,"UserData.lua")
end
return ioHandler
