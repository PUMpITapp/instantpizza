require "RegistrationReview"

describe("Test RegistrationReview, checkTestMode", function()

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

describe("Test RegistrationReview, onKey", function()
	it("test Green", function()
		local expected_value = 'Menu.lua'
		local got = onKey('green','up')
		assert.are.same(expected_value,got)
		end)
	it("test Red", function()
		local expected_value = 'RegistrationStep3.lua'
		local got = onKey('red','up')
		assert.are.same(expected_value,got)
	end)
	it("test Yellow", function()
		local expected_value = 'Menu.lua'
		local got = onKey('yellow','up')
		assert.are.same(expected_value,got)
	end)		
end)