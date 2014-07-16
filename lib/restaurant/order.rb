require 'date'
require 'time'

class Restaurant::Order

  attr_reader :id, :table_number, :creation_time

  def initialize(id, customer_id, creation_time)
    @id = id
    @customer_id = customer_id
    @creation_time = DateTime.parse(creation_time)
  end

  def self.get(id)
    result = Restaurant.orm.get_order(id)
    Restaurant::Order.new(result[0], result[1], result[2])
  end

  def create_order(customer_id)
    result = Restaurant.orm.add_order(customer_id)
    order = Restaurant::Order.new(result[0],result[1],result[2])
    order
  end

  #list order


end
