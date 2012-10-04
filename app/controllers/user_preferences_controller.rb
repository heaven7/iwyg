class UserPreferencesController < ApplicationController
	
	layout 'userarea'
  helper :users
  before_filter :authenticate_user!

  def index
    render :action => "show"
  end

	def show
#		@user = User.find(params[:user_id])
#	  @user_preferences = @user.user_preferences
	end

	def edit
		@user = User.where(:id => params[:user_id]).first
	  if !@user.user_preferences
			@user.user_preferences = UserPreferences.new(:user_id => @user.id)
		end
		edit!
	end

	def new
		@user = User.find(params[:user_id])
	  @user.user_preferences = UserPreferences.new(:user_id => params[:user_id])
	end

end
