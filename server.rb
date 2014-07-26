require 'sinatra'
# require 'lib/restaurant.rb'

get '/' do
  @title = "Restaurant"
  erb :index
end

get '/:id' do
  @title = params[:id]

end
