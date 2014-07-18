require './lib/restaurant.rb'


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
end
