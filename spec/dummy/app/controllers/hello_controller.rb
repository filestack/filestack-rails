class HelloController < ApplicationController
  def index
    @user = User.new
  end
end
