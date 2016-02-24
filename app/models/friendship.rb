class Friendship < ActiveRecord::Base
  
  belongs_to :user
  
  # this class dosent exist so point it into User class
  belongs_to :friend, :class_name => 'User'
end
