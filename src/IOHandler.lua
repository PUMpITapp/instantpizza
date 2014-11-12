local ioHandler = {}
--Create new user
User = {}
function User:new(name,address,zipCode,city,phone,email,pizzeria,pizzaOne,pizzaTwo,pizzaThree,pizzaFour)
  newObj ={
  name = name,
  address = address,
  zipCode = zipCode,
  city = city,
  phone = phone,
  email = email,
  pizzeria = pizzeria,
  pizzaOne = pizzaOne,
  pizzaTwo = pizzaTwo,
  pizzaThree = pizzaThree,
  pizzaFour = pizzaFour
  }
  self.__index = self
  return setmetatable(newObj, self)
end
--Create new pizzeria. Each pizzeria object has one table of pizzas. 
Pizzeria = {}
function Pizzeria:new(id,name,imgPath,rating,pizzas)
  newObj = {
  id = id,
  name = name,
  imgPath = imgPath,
  rating = rating,
  pizzas = pizzas
  }
  self.__index = self
  return setmetatable(newObj, self)
end
--Create pizza
Pizza = {}
function Pizza:new(id,name,price)
  newObj = {
  id = id,
  name = name,
  price = price
  }
  self.__index = self
  return setmetatable(newObj, self)
end
--Function to split string. Delimiter is where to split the string. Our files uses ", "
function string:split(delimiter)
  result = {}
  local start = 1
  local splitStart, splitEnd = string.find( self, delimiter, splitStart )
  while splitStart do
    table.insert( result, string.sub( self, start, splitStart-1 ))
    start = splitEnd + 1
    splitStart, splitEnd = string.find( self, delimiter, start )
  end
  table.insert( result, string.sub( self, start ) )
  return result
end
--Function to read users. Users are stored in a table containing user "objects"
function ioHandler.readUsers()
  local usersTable = {}
  i = 1
  for line in io.open("TextFiles/users.txt"):lines()do
    local userTable = line:split(", ")
    usersTable[i] = User:new(userTable[1],userTable[2],userTable[3],userTable[4],userTable[5],userTable[6],userTable[7],userTable[8],userTable[9],userTable[10],userTable[11])
    i = i+1
  end
  return usersTable
end
-- Function to read pizzerias. Are stored in a table, every pizzeria has a table of pizzas. 
function ioHandler.readPizzerias()
  local pizzeriaTable = {}
  local pizzaTable = {}
  i = 1
  for line in io.open("TextFiles/pizzerias.txt"):lines()do
    local splitTable = line:split(", ")
    pizzaTable = ioHandler.readPizzas(splitTable[1])
    pizzeriaTable[i] = Pizzeria:new(splitTable[1], splitTable[2], splitTable[3], splitTable[4])
    pizzeriaTable[i].pizzas = pizzaTable
    i = i+1
  end
  return pizzeriaTable
end
--Function to read pizzas. Parameter id matches pizza to pizzeria. Return table of pizzas. 
function ioHandler.readPizzas(id)
  local pizzas = {}
  j = 1
  for line in io.open("TextFiles/pizzas.txt"):lines()do
    local splitTable = line:split(", ")
    --If pizzeria id matches id in pizza file
    if(splitTable[1] == id)then
      pizzas[j] = Pizza:new(splitTable[1],splitTable[2],splitTable[3])
      j=j+1
    end
  end
  return pizzas
end

--Function to save user to file. Appends string from userForm and saves it to file, file info i appended so nothing is overwritten. 
function ioHandler.saveUser(userForm)
  --Open file, append mode
  file = io.open("TextFiles/users.txt", "a")
  io.output(file)
  --Append string. Not the best solution at the moment, hard to iterate through table because the order is not sorted
  userString = userForm.name .. ", " .. userForm.address .. ", " .. userForm.zipCode .. ", " .. userForm.city .. ", " .. userForm.phone .. ", " .. userForm.email .. ", " .. userForm.pizzeria.name
  counter = 1
  for i=1,#userForm.pizzeria.pizza do
    userString = userString..", "..userForm.pizzeria.pizza[i].name
    counter = counter +1
  end
  while(counter <= 4)do
    userString = userString.. ", "
    counter = counter +1
  end
  io.write("\n")
  io.write(userString)
  io.close()
end
function main()
  ioHandler.readUsers()
end
main()
return ioHandler
