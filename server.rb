require 'sinatra'

require_relative 'lib/restaurant.rb'

set :port, 4567

get '/' do
  @title = "Welcome Page"
  erb :index
end

get '/customer/login' do
  @title = "Customer Login"
  erb :"/customer/login_customer"
end

get '/staff/login' do
  @title = "Staff Login"
  erb :"/staff/login_staff"
end

get '/menu' do
  @title = "Menu"
  @menus = Restaurant::Menu.get_all
  for menu in @menus
    menu.get_foods #list_food
  end
  #create a dictionary
  @type_of_item =
  erb :"/customer/customer_menu"
end
