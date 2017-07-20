class HelloController < ApplicationController
  def index
    @user = User.new
  end

  def show
    @users = User.all
  end 
end
