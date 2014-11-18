require "RegistrationStep1"

--[[describe("Test newForm format", function()
	it("name", function()
		local expected_value="name"
		local got = inputFieldTable[0]
		assert.are.same(expected_value,got)
		end)
	it("address", function()
		local expected_value="address"
		local got = inputFieldTable[1]
		assert.are.same(expected_value,got)
		end)
	it("zipCode", function()
		local expected_value="zipCode"
		local got = inputFieldTable[2]
		assert.are.same(expected_value,got)
		end)
	it("city", function()
		local expected_value="city"
		local got = inputFieldTable[3]
		assert.are.same(expected_value,got)
		end)
	it("phone", function()
		local expected_value="phone"
		local got = inputFieldTable[4]
		assert.are.same(expected_value,got)
		end)
	it("email", function()
		local expected_value="email"
		local got = inputFieldTable[5]
		assert.are.same(expected_value,got)
		end
	end)
]]
describe("Test UserRegistration1, onKey", function()
	it("test Up", function()
		local expected_value = "up"
		local got = onKey('up','up')
		assert.are.same(expected_value,got)
		end)
	it("test Down", function()
		local expected_value = "down"
		local got = onKey('down','up')
		assert.are.same(expected_value,got)
		end)
	it("test blue", function()
		local expected_value = "RegistrationStep2.lua"
		local got = onKey('blue','up')
		assert.are.same(expected_value,got)
		end)
	it("test Keyboard", function()
		local expected_value = 'Keyboard.lua'
		local got = onKey("ok",'up')
		assert.are.same(expected_value,got)
		end)
	it("test Green", function()
		local expected_value = 'Menu.lua'
		local got = onKey('green','up')
		assert.are.same(expected_value,got)
		end)	
end)

describe("Test UserRegistration1, checkTestMode", function()

	it("test checkTestMode",function()
		local got = checkTestMode()
		assert.is_true(got)
		end)

	it("test chooseGfx", function()
		local got = chooseGfx()
		local expected_value = require "gfx_stub"
		assert.are.same(expected_value,got)
		end)

	it("test chooseText", function()
		local got = chooseText()
		local expected_value = require "write_text_stub"
		assert.are.same(expected_value,got)
		end)
end)


describe("Test UserRegistration1, moveHighlightedInputField", function()

	it("When not at the top, pressing up", function()
		setValuesForTesting((returnValuesForTesting("lowerBoundary")+1))
		moveHighlightedInputField('up')
		local got = returnValuesForTesting("highlightPosY")
		local expected_value = returnValuesForTesting("lowerBoundary") 
		assert.are.same(expected_value,got)
	end)

	it("When at the top, pressing up", function()
		setValuesForTesting((returnValuesForTesting("lowerBoundary")))
		moveHighlightedInputField('up')
		local got = returnValuesForTesting("highlightPosY")
		local expected_value = returnValuesForTesting("upperBoundary") 
		assert.are.same(expected_value,got)
	end)

	it("When at the bottom, pressing down", function()
		setValuesForTesting((returnValuesForTesting("upperBoundary")))
		moveHighlightedInputField('down')
		local got = returnValuesForTesting("highlightPosY")
		local expected_value = returnValuesForTesting("lowerBoundary") 
		assert.are.same(expected_value,got)
	end)

	it("When not at the bottom, pressing down", function()
		setValuesForTesting((returnValuesForTesting("upperBoundary")-1))
		moveHighlightedInputField('down')
		local got = returnValuesForTesting("highlightPosY")
		local expected_value = returnValuesForTesting("upperBoundary") 
		assert.are.same(expected_value,got)
	end)
end)

describe("Test UserRegistration1, checkForm()", function()
	it("Forms not equal, states equal", function()
		createFormsForTest("Not equal, State equal")
		checkForm()
		newForm = returnNewForm()
		lastForm = returnLastForm()
		assert.are.same(newForm,lastForm)
	end)
	it("Forms not equal, states not equal", function()
		createFormsForTest("Not equal, State not equal")
		checkForm()
		newForm = returnNewForm()
		lastForm = returnLastForm()
		for key,value in pairs(lastForm) do
			if key == "laststate" then
				assert.are_not.equal(lastForm[key],newForm[key])
			else
				assert.are.same(lastForm[key],newForm[key])
			end
		end
	end)
	it("Forms equal, states equal", function()
		createFormsForTest("Equal, State equal")
		checkForm()
		newForm = returnNewForm()
		lastForm = returnLastForm()
		assert.are.same(newForm,lastForm)
	end)
	it("Forms equal, states not equal", function()
		createFormsForTest("Equal, State not equal")
		checkForm()
		newForm = returnNewForm()
		lastForm = returnLastForm()
		for key,value in pairs(lastForm) do
			if key == "laststate" then
				assert.are_not.equal(lastForm[key],newForm[key])
			else
				assert.are.same(lastForm[key],newForm[key])
			end
		end
	end)
end)

