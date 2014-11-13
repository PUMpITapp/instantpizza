require "RegistrationStep2"

describe("Test UserRegistration2, checkTestMode", function()

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

describe("Test UserRegistration2, onKey", function()
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
	it("test blue, isChoosen true", function()
		setIsChoosen(true)
		local expected_value = "RegistrationStep3.lua"
		local got = onKey('blue','up')
		assert.are.same(expected_value,got)
		end)
	it("test blue, isChoosen false", function()
		setIsChoosen(false)
		local expected_value = "Need pizzeria to proceed"
		local got = onKey('blue','up')
		assert.are.same(expected_value,got)
		end)
	it("test Return", function()
		local expected_value = "Return"
		local got = onKey("Return",'up')
		assert.are.same(expected_value,got)
		end)
	it("test Red", function()
		local expected_value = "RegistrationStep1.lua"
		local got = onKey('red','up')
		assert.are.same(expected_value,got)
		end)
end)

describe("Test UserRegistration2, moveHighlightedInputField", function()

	it("When not at the top, pressing up", function()
		setValuesForTesting((returnValuesForTesting("inputFieldStart")+1))
		moveHighlightedInputField('Up')
		local got = returnValuesForTesting("inputFieldY")
		local expected_value = (returnValuesForTesting("inputFieldStart")+1) - returnValuesForTesting("inputMovement")
		assert.are.same(expected_value,got)
	end)

	-- No testcase or function written for when at the top and pressing up

	it("When not at the bottom, pressing down", function()
		setValuesForTesting((returnValuesForTesting("inputFieldEnd")-1))
		moveHighlightedInputField('Down')
		local got = returnValuesForTesting("inputFieldY")
		local expected_value = (returnValuesForTesting("inputFieldEnd")-1) + returnValuesForTesting("inputMovement")
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