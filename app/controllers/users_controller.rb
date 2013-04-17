class UsersController < ApplicationController

	def show
		@user = User.where( id: params[ :id ] ).first
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new( params[ :user ] ) 
		if @user.save
			flash[ :success ] = 'Bem-vindo ao WebErp!!!'
			redirect_to @user
		else
			render 'new'
		end
	end

end
