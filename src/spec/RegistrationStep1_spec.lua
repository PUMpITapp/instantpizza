require "RegistrationStep1"

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
	it("Forms equal, states equal", function()
		createFormsForTest("Equal, State equal")
		checkForm()
		newForm = returnNewForm()
		lastForm = returnLastForm()
		assert.are.same(newForm,lastForm)
	end)
end)

describe("Test UserRegistration1, Empty Form", function()
	it("Every field left blank", function()
		local testForm = {
			zipCode ="",
			phone="",
			email = "",
		}
		emptyFormValidation(testForm)
		local got = returnForms("emptyTextFields")
		local expected_value = {
			"zipCode",
			"phone",
			"email",
		}
		assert.are.same(got,expected_value)
	end)
	it("Correct Zipcode entered", function()
		local testForm = {
			zipCode ="58439",
			phone="",
			email = "",
		}
		emptyFormValidation(testForm)
		local got = returnForms("emptyTextFields")
		local expected_value = {
			"phone",
			"email",
		}
		assert.are.same(got,expected_value)
	end)
	it("Correct Zipcode and phone entered", function()
		local testForm = {
			zipCode ="58439",
			phone="0736176314",
			email = "",
		}
		emptyFormValidation(testForm)
		local got = returnForms("emptyTextFields")
		local expected_value = {
			"email",
		}
		assert.are.same(got,expected_value)
	end)
	it("Correct Zipcode, phone and email entered", function()
		local testForm = {
			zipCode ="58439",
			phone="0736176314",
			email = "mikael.lietha@gmail.com",
		}
		emptyFormValidation(testForm)
		local got = returnForms("emptyTextFields")
		local expected_value = {
		}
		assert.are.same(got,expected_value)
	end)
	it("Wrong Zipcode, phone and email entered", function()
		local testForm = {
			zipCode ="Hejsan",
			phone="Mobilen eller?",
			email = "Rydsvägen 156a",
		}
		emptyFormValidation(testForm)
		local got = returnForms("emptyTextFields")
		local expected_value = {
		}
		assert.are.same(got,expected_value)
	end)
end)

describe("Test UserRegistration1, Invalid Form", function()
	it("Every field left blank", function()
		local testForm = {
			zipCode ="",
			phone="",
			email = "",
		}
		invalidFormValidation(testForm)
		local got = returnForms("invalidFields")
		local expected_value = {}
		assert.are.same(got,expected_value)
	end)
	it("Incorrect ZipCode", function()
		local testForm = {
			zipCode ="1a2a3a4a5a",
			phone="",
			email = "",
		}
		invalidFormValidation(testForm)
		local got = returnForms("invalidFields")
		local expected_value = {}
		expected_value["zipCode"] = "Incorrect zip-code, write five digits(no spaces)"
		assert.are.same(got,expected_value)
	end)
	it("Incorrect phone", function()
		local testForm = {
			zipCode ="",
			phone="1a2a3a4a5a6a7a8a9a0a",
			email = "",
		}
		invalidFormValidation(testForm)
		local got = returnForms("invalidFields")
		local expected_value = {}
		expected_value["phone"] = "Incorrect phone number, write ten digits(no spaces)"
		assert.are.same(got,expected_value)
	end)
	it("Incorrect zipCode and Phone number", function()
		local testForm = {
			zipCode = "blah",	
			phone="1a2a3a4a5a6a7a8a9a0a",
			email = "",
		}
		invalidFormValidation(testForm)
		local got = returnForms("invalidFields")
		local expected_value = {}
		expected_value["zipCode"] = "Incorrect zip-code, write five digits(no spaces)"
		expected_value["phone"] = "Incorrect phone number, write ten digits(no spaces)"
		assert.are.same(got,expected_value)
	end)
	it("Incorrect zipCode, Phone number and email", function()
		local testForm = {
			zipCode = "Postnummer: blah",
			phone="Noll-åtta-femhundra-tretti-fem",
			email = "Bossen91@gmail.5",
		}
		invalidFormValidation(testForm)
		local got = returnForms("invalidFields")
		local expected_value = {}
		expected_value["zipCode"] = "Incorrect zip-code, write five digits(no spaces)"
		expected_value["phone"] = "Incorrect phone number, write ten digits(no spaces)"
		expected_value["email"] = "Incorrect email, use valid characters"
		assert.are.same(got,expected_value)
	end)
end)
