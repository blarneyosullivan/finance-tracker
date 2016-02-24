class UsersController < ApplicationController
  
  def my_portfolio
    #association lets us get stocks for current user
    @user_stocks = current_user.stocks
    
    @user = current_user
    
  end
  
  def my_friends
    
  end
  
  
end