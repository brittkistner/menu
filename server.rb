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


#types_of_item_by_menu = {'menu1'=> [{'beverages'=> ['coke', 'coffee']},{'pancakes'=> ['1stack', '2stack']}], 'menu2'=> [{'beverages'=> ['coke', 'coffee']},{'entrees'=> ['hamburger', 'salad']}] }
  @types_of_item_by_menu = {}
  @menus.each do |menu|
    types_of_items = []
    foods_by_type_of_item = {}
    foods = menu.list_food
    foods.each do |food|
      if types_of_items.include?(food.type_of_item)
        types_of_items << food.type_of_item
      end
      if foods_by_type_of_item.include?(food.type_of_item)
        @foods_by_type_of_item[type_of_item] << food
      else
        @foods_by_type_of_item[type_of_item] = [food]
      end
      types_of_items
    end
    @types_of_item_by_menu[menu] = types_of_items
  end

  erb :"/customer/customer_menu"
end
