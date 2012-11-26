class LandingController < ApplicationController
	before_filter :authenticate_user!
	
	def index
		if !current_user
			@user = User.new
		end
	end
	
end
