require "user_registration"


describe("Test moveHighlightedInputField", function()
	
	it("Test moveHighlightedInputField, press 'red' when on the initial surface",function()
		
		-- the Y value for the last higlighted surface
		local excpected_y_value = 550

		moveHighlightedInputField('red')
		local got = inputFieldY

		assert.are.same(excpected_y_value,got)

		end)

it("Test moveHighlightedInputField, press 'green' when on the last surface",function()
		
		-- the Y value for the first higlighted surface		
		local excpected_y_value = 150

		moveHighlightedInputField('green')
		local got = inputFieldY

		assert.are.same(excpected_y_value,got)

		end)
		
	it("Test moveHighlightedInputField, press 'green' when on the initial surface",function()
		
		-- the Y value for the second higlighted surface
		local excpected_y_value = 230

		moveHighlightedInputField('green')
		local got = inputFieldY

		assert.are.same(excpected_y_value,got)

		end)
	it("Test moveHighlightedInputField, press 'red' when on the second surface",function()
		
		-- the Y value for the first higlighted surface
		local excpected_y_value = 150

		moveHighlightedInputField('red')
		local got = inputFieldY

		assert.are.same(excpected_y_value,got)

		end)


end)