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

  @types_of_item_by_menu = {}
  @menus.each do |menu|
    types_of_item = []
    foods = menu.list_food
    foods.each do |food|
      types_of_item.include?(food.type_of_item) ?  nil : types_of_item << food.type_of_item
      types_of_item.compact!
    end
    @types_of_item_by_menu[menu] = types_of_item
  end

  # @food_name_by_type_and_menu = {}
  # @menu.each do |menu|
  #   types_of_item = []
  #   foods = menu.list_food
  #   foods.each do |food|
  #     types_of_item.include?(food.type_of_item) ?  nil : types_of_item << food.type_of_item
  #     types_of_item.compact!
  #   end
  #   food_by_type = []

  #first loop will iterate through the different menus
  #second loop will put out the index, type of item, and food information
  erb :"/customer/customer_menu"
end
