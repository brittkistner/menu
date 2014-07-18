require './lib/restaurant.rb'
# require 'silent-postgres'


RSpec.configure do |config|
  config.before(:all) do
    Restaurant.orm.instance_variable_set(:@db_adaptor, PG.connect(host: 'localhost', dbname: 'menu-db-test'))
  end

  config.before(:each) do
    Restaurant.orm.reset_tables
  end

  config.after(:all) do
    Restaurant.orm.drop_tables
  end

  # config.before(:all) do
  #   min_messages: WARNING
  # end
end
