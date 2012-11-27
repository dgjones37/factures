require 'spec_helper'

describe "" do
	describe "When I visit the home page of the website" do
		subject {page}
		
		before do
			visit root_path
		end
		
		
		context "as a user that has not yet logged in" do
			
			it "I can see a login form" do
				should have_selector('form[id="new_user"]')
			end	
			
			it {should have_selector('a', text: 'Register')}
			
			context "in the head nav" do
				
				it "there will be a login form in the header" do
					should have_selector('div[class="navbar"] form[id="new_user"]')	
				end
				
				it "There will be a brand Link" do
					should have_selector('a[class="brand"]', text: "Factures" )
				end
				
			end
			
		end
		
	end
end
