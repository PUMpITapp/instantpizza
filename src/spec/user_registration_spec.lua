require "user_registration"

describe("Test newForm format", function()
	it("test form, name", function()
		local expected_value="name"
		local got = inputFieldTable[0]
		assert.are.same(expected_value,got)
		end)
	it("test form, address", function()
		local expected_value="address"
		local got = inputFieldTable[1]
		assert.are.same(expected_value,got)
		end)
	it("test form, zipCode", function()
		local expected_value="zipCode"
		local got = inputFieldTable[2]
		assert.are.same(expected_value,got)
		end)
	it("test form, city", function()
		local expected_value="city"
		local got = inputFieldTable[3]
		assert.are.same(expected_value,got)
		end)
	it("test form, phone", function()
		local expected_value="phone"
		local got = inputFieldTable[4]
		assert.are.same(expected_value,got)
		end)
	it("test form, email", function()
		local expected_value="email"
		local got = inputFieldTable[5]
		assert.are.same(expected_value,got)
		end)
	end)

describe("Test user_registration.lua onKey", function()
	it("test Up", function()
		local expected_value = "Up"
		local got = onKey('Up','up')
		assert.are.same(expected_value,got)
		end)
	it("test Down", function()
		local expected_value = "Down"
		local got = onKey('Down','up')
		assert.are.same(expected_value,got)
		end)
	it("test blue", function()
		local expected_value = "choose_Pizzeria.lua"
		local got = onKey('blue','up')
		assert.are.same(expected_value,got)
		end)
	it("test Keyboard", function()
		local expected_value = "keyboard.lua"
		local got = onKey("Return",'up')
		assert.are.same(expected_value,got)
		end)
	it("test Red", function()
		local expected_value = 'red'
		local got = onKey('red','up')
		end)	
end)

describe("Test user_registration.lua checkTestMode", function()

	it("test checkTestMode",function()
		local got = checkTestMode()
		assert.is_true(got)
		end)
end)

describe("Test user_registration.lua, moveHighlightedInputField", function()

	--it()

end)
