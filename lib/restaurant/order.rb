require 'date'
require 'time'

class Restaurant::Order

  attr_reader :id, :table_number, :creation_time
  attr_accessor :status

  def initialize(id, customer_id, creation_time, status)
    @id = id
    @customer_id = customer_id
    @creation_time = DateTime.parse(creation_time)
    @status = status
  end

  def self.get(id)
    result = Restaurant.orm.get_order(id)
    Restaurant::Order.new(result[0], result[1], result[2], result[3])
  end

  def create_order(customer_id)
    result = Restaurant.orm.add_order(customer_id)
    order = Restaurant::Order.new(result[0],result[1],result[2], result[3])
    order
  end

  def self.list_orders
    result = Restaurant.orm.list_orders
    orders = []

    result.each do |order|
      orders << Restaurant::Order.new(order[0],order[1],order[2], order[3])
    end

    orders
  end

  def list_items_in_order
    result = Restaurant.orm.list_items_in_order(@id)
    items = []
    result.each do |item|
      items << Restaurant::Food.new(item[0],item[1],item[2],item[3],item[4])
    end

    items
  end
end
