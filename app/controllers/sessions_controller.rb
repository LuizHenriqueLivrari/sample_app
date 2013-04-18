class SessionsController < ApplicationController

	def new
	end

	def create

		user = User.where(email: params[:email].downcase).first

		if user && user.authenticate(params[:password])
			sign_in user
			redirect_back_or user
		else
			flash.now[:error] = 'Invalid email/password combination'
			params[ :password ] = ''
			render 'new'
		end

	end

	def destroy
		sign_out
		redirect_to root_url
	end

end