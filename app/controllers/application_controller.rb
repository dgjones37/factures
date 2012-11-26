class ApplicationController < ActionController::Base
  
	before_filter :set_user
	
	protect_from_forgery
  
  
  def set_user
  	if current_user
  		@user = current_user
  	else 
			@user = User.new
		end
	end
	
end
