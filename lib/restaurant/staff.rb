class Restaurant::Staff

  attr_reader :id, :name

  def initialize (id, name)
    @id = Integer(id)
    @name = name
  end

  def self.get_id(id)
    staff = Restaurant.orm.get_staff(id)
    Restaurant::Staff.new(staff[0],staff[1])
  end

  def self.create_staff(name)
    staff = Restaurant.orm.create_staff(name)
    Restaurant::Staff.new(staff[0],staff[1])
  end

  def complete_order(order_id)
    if Restaurant.orm.mark_complete(order_id) == true
      "Order #{order_id} marked complete"
    end
  end

  def list_open_orders
    result = Restaurant.orm.list_open_orders
    orders = []

    result.each do |order|
      orders << Restaurant::Order.new(order[0],order[1],order[2], order[3])
    end

    orders
  end

  def list_closed_orders
    result = Restaurant.orm.list_closed_orders

    orders = []

    result.each do |order|
      orders << Restaurant::Order.new(order[0],order[1],order[2], order[3])
    end

    orders
  end

  def list_all_orders
    result = Restaurant.orm.list_orders

    orders = []

    result.each do |order|
      orders << Restaurant::Order.new(order[0],order[1],order[2], order[3])
    end

    orders
  end

  # def list_items_in_order(order_id)
  #   Restaurant.orm.list_items_in_order(order_id)
  # end
end
