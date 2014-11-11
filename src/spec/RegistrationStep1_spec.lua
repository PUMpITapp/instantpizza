require "RegistrationStep1"

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

describe("Test UserRegistration1 onKey", function()
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
		local expected_value = "RegistrationStep2.lua"
		local got = onKey('blue','up')
		assert.are.same(expected_value,got)
		end)
	it("test Keyboard", function()
		local expected_value = "Keyboard.lua"
		local got = onKey("Return",'up')
		assert.are.same(expected_value,got)
		end)
	it("test Red", function()
		local expected_value = 'Menu.lua'
		local got = onKey('red','up')
		assert.are.same(expected_value,got)
		end)	
end)

describe("Test UserRegistration1 checkTestMode", function()

	it("test checkTestMode",function()
		local got = checkTestMode()
		assert.is_true(got)
		end)
end)


describe("Test UserRegistration1, moveHighlightedInputField", function()

	it("When not at the top, pressing up", function()
		setValuesForTesting((returnValuesForTesting("inputFieldStart")+1))
		moveHighlightedInputField('Up')
		local got = returnValuesForTesting("inputFieldY")
		local expected_value = (returnValuesForTesting("inputFieldStart")+1) - returnValuesForTesting("height")*(0.7/9)
		assert.are.same(expected_value,got)
	end)

	-- No testcase or function written for when at the top and pressing up

	it("When not at the bottom, pressing down", function()
		setValuesForTesting((returnValuesForTesting("inputFieldEnd")-1))
		moveHighlightedInputField('Down')
		local got = returnValuesForTesting("inputFieldY")
		local expected_value = (returnValuesForTesting("inputFieldEnd")-1) + returnValuesForTesting("height")*(0.7/9)
		assert.are.same(expected_value,got)
	end)

	it("When at the bottom, pressing down", function()
		setValuesForTesting((returnValuesForTesting("inputFieldEnd")))
		moveHighlightedInputField('Down')
		local got = returnValuesForTesting("inputFieldY")
		local expected_value = returnValuesForTesting("inputFieldStart")
		assert.are.same(expected_value,got)
	end)
end)
