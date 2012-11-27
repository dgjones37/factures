class LandingController < ApplicationController
	
	def index
		if !current_user
			@user = User.new
		end
	end
	
end
