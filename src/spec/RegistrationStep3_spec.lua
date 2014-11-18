require "RegistrationStep3"

describe("Test UserRegistration3, checkTestMode", function()

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

describe("Test UserRegistration2, checkForm()", function()
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

describe("Test UserRegistration3, moveHighlightedInputField", function()

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

describe("Test UserRegistration3, onKey", function()
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
	it("test blue, pizzas chosen", function()
		setIsChosen(true)
		local expected_value = "RegistrationReview.lua"
		local got = onKey('blue','up')
		assert.are.same(expected_value,got)
		end)
	it("test blue, pizzas not chosen", function()
		setIsChosen(false)
		local expected_value = "Need to choose pizza"
		local got = onKey('blue','up')
		assert.are.same(expected_value,got)
		end)
	it("test ok", function()
		local expected_value = "ok"
		local got = onKey('ok','up')
		assert.are.same(expected_value,got)
		end)
	it("test red", function()
		local expected_value = "RegistrationStep2.lua"
		local got = onKey('red','up')
		assert.are.same(expected_value,got)
		end)	
end)
