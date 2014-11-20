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
  usersTable = table.load("UserData.lua")
  return usersTable
end
-- Function to read pizzerias. Are stored in a table, every pizzeria has a table of pizzas. 
function ioHandler.readPizzerias()
  local pizzeriaTable = {}
  pizzeriaTable = table.load("PizzeriaData.lua")
  return pizzeriaTable
end
-- Test function that reads "pizzerias"
function ioHandler.readPizzerias_test()
  local pizzeriaTable = {}
  pizzeriaTable = table.load("PizzeriaData_testing.lua")
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

function ioHandler.addTestUser()
  users = {}
  pizzas = {}
  Pizza1 = Pizza:new("Vesuvio","70")
  Pizza2 = Pizza:new("Kebab","75")
  Pizza3 = Pizza:new("Mexicana","70")
  drinks ={}
  Drink1 = Drink:new("Coca cola","10")
  Drink2 = Drink:new("Fanta","10")
  Drink3 = Drink:new("Ramlösa","10")
  pizzas[1] = Pizza1
  pizzas[2] = Pizza2
  pizzas[3] = Pizza3
  drinks[1] = Drink1
  drinks[2] = Drink2
  drinks[3] = Drink3
  Pizzeria = Pizzeria:new("Test pizzeria","pizza2.png","5",pizzas,drinks)
  user = User:new("Test user","Ryd","584 34","Link","070600334","johan@me.com",Pizzeria)
  return user
  --table.save(users,"UserData.lua")
end
function ioHandler.saveUserData(name,address,zipCode,city,phone,email,pizzeria)
  tempUserTable = {}
  usersTable = {}
  j=1
  user = User:new(account.name,account.address,account.zipCode,account.city,account.phone,account.email,pizzeria)
  tempUserTable = ioHandler.readUserData()
  if not (tempUserTable == nil)then
    for i=1,#tempUserTable do
    usersTable[j]=tempUserTable[i]
    j=j+1
    end
  end
  usersTable[j]=user
  table.save(usersTable,"UserData.lua")
end
return ioHandler
