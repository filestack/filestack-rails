class WelcomeController < ApplicationController
  def index
    @user = User.new
  end
end
