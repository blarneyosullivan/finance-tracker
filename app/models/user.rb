class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  
  
  # this sets up many to many association
  has_many :friendships
  has_many :friends, through: :friendships
  
  
  
  def full_name
  
  return "#{first_name} #{last_name}".strip if (first_name || last_name)
  "Anonymous"
  end
  
  

  def can_add_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_added?(ticker_symbol)
    
  end
  
  def under_stock_limit?
    (user_stocks.count < 10)
  end
  
  def stock_already_added?(ticker_symbol)
    stock = Stock.find_by_ticker(ticker_symbol)
    return false unless stock
    user_stocks.where(stock_id: stock.id).exists?
    
  end
  
  
  # add methods for partial friends _lookup
  
  def not_friends_with?(friend_id)
    friendships.where(friend_id: friend_id).count < 1  
  end
  
  def except_current_user(users)
    # loop through object and reject element where userid = caller userid ie current user
    users.reject { |user| user.id == self.id }
    
  end
  
  def self.search(param)
    # if blank
    return User.none if param.blank?
    # if not blank
    param.strip!
    param.downcase!
    
    (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    
  end
  
  # class function starts with self
  def self.first_name_matches(param)
  # call matches with field name to match  
    matches('first_name', param)
  end
  
  
  def self.last_name_matches(param)
    matches('last_name', param)
    
  end
  
  def self.email_matches(param)
    matches('email', param)

  end
  
  def self.matches(field_name, param)
    where("lower(#{field_name}) like ?", "%#{param}%")  
  end
  
  
  
  
  
  
  
end
