require "OrderStep1"
describe("Test OrderStep1, onKey", function()
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
	it("test Confirmation", function()
		local expected_value = 'OrderStep2.lua'
		local got = onKey("ok",'up')
		assert.are.same(expected_value,got)
		end)
	it("test Green", function()
		local expected_value = 'Menu.lua'
		local got = onKey('green','up')
		assert.are.same(expected_value,got)
		end)	
end)

describe("Test OrderStep1, checkTestMode", function()

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

describe("Test OrderStep1, moveHighlightedInputField", function()

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

	it("When not at the bottom, pressing up", function()
		setValuesForTesting((returnValuesForTesting("upperBoundary")-1))
		moveHighlightedInputField('down')
		local got = returnValuesForTesting("highlightPosY")
		local expected_value = returnValuesForTesting("upperBoundary") 
		assert.are.same(expected_value,got)
	end)
end)