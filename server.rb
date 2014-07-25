require 'sinatra'
# require 'lib/restaurant.rb'

get '/index' do
  @title = "Restaurant"
  erb :index
end

get '/:id' do
  @title = params[:id]

end
