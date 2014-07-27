require 'sinatra'
require 'rubygems'
# require 'lib/restaurant.rb'

set :port, 9494

get '/' do
  @title = "Welcome Page"
  erb :index
end

get '/login' do
  @title = "Customer Login"
  erb :"/customer/login_customer"
end

get '/login-staff' do
  @title = "Staff Login"
  erb :"/staff/login_staff"
end

get '/menu' do
  @title = "Menu"
  erb :"/customer/customer_menu"
end
