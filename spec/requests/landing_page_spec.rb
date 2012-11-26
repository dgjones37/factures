require 'spec_helper'

describe "" do
describe "When I visit the home page of the website" do
	subject {page}
	
	before do
		visit root_path
	end
	
	
	context "as a user that has not yet logged in" do
		
		it "I can see a login form" do
			should have_selector('form[name = "login"]')
			
		end	
		
		it "and I can also see a register now button" do
			should have_selector('a', text: 'Register')
		end
		
	end
	
end

end
