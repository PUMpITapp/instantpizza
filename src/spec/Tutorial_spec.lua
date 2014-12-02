require "Tutorial"
describe("Test Tutorial, onKey", function()
	it("test Left", function()
		local expected_value = "left"
		local got = onKey('left','up')
		assert.are.same(expected_value,got)
		end)
	it("test Right", function()
		local expected_value = "right"
		local got = onKey('right','up')
		assert.are.same(expected_value,got)
		end)
	it("test Green", function()
		local expected_value = 'Menu.lua'
		local got = onKey('green','up')
		assert.are.same(expected_value,got)
		end)	
end)

describe("Test Tutorial, checkTestMode", function()

	it("test checkTestMode",function()
		local got = checkTestMode()
		assert.is_true(got)
		end)

	it("test chooseGfx", function()
		local got = chooseGfx()
		local expected_value = require "gfx_stub"
		assert.are.same(expected_value,got)
		end)
end)