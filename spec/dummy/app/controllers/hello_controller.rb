class HelloController < ApplicationController
  include FilestackRails::ApplicationHelper
  def index
    @user = User.new
  end

  def show
    @users = User.all
  end 
end
