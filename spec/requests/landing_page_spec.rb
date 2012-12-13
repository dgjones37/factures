require 'spec_helper'

describe "" do
	describe "When I visit the home page of the website" do
		subject {page}
		
		before do
			visit root_path
		end
		
		
		context "as a user that has not yet logged in" do
				
			
			context "in the top nav", js: true do
				
				it "there will be a login form in the header" do
					should have_selector('div[class="navbar"] form[id="new_user"]')	
				end
				
				it "and the login form should have an an input texbox for email" do
				  should have_selector('div[class="navbar"] form[id="new_user"] input[name="user[email]"]')	
				end
				
				it "and an input textbox for password" do
				  should have_selector('div[class="navbar"] form[id="new_user"] input[name="user[password]"]')	
				end
				
				it "and a button for submitting the form" do
				  should have_selector('div[class="navbar"] form[id="new_user"] input[type="submit"]')
				  
				end
				
				it "There will be a brand Link" do
					should have_selector('div[class="navbar"] a[class="brand"]', text: "Factures" )
				end
				
				it {should have_selector('div[class="navbar"] a', text: 'Register')}
				
			end
			
      context "attempts to log in" do
        context "with valid credentials" do
          before do
            @user = FactoryGirl.create(:user, email: 'tara@underbar.com', password: 'password')
            fill_in 'Email', with: 'tara@underbar.com'
            fill_in 'Password', with: 'password'
            click_button 'Sign in'
          end
          it {current_path.should == root_path}
          it "there will not be a login form in the header" do
            should_not have_selector('div[class="navbar"] form[id="new_user"]')	
          end
          it {should_not have_selector('div[class="navbar"] a', text: 'Register')}
          context "and then logs out" do
             before do
               click_link "Sign Out"
             end
             it {current_path.should == root_path}
             it {should have_selector('div[class="navbar"] a', text: 'Register')}
          end
        end
        context "with invalid credentials" do
          before do
            FactoryGirl.create(:user, email: 'tara@underbar.com', password: 'password')
            fill_in 'Email', with: 'tara@underbar.com'
            fill_in 'Password', with: 'wrong_password'
            click_button 'Sign in'
          end
          it {current_path.should == new_user_session_path}
          it {should have_selector('div[class="navbar"] a', text: 'Register')}          
        end
      end
			
		end
		
	end
end
