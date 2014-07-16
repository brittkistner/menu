class Restaurant::Staff

  attr_reader :id, :name

  def initialize (id, name)
    @id = id
    @name = name
  end

  def self.get_id(id)
    staff = Restaurant.orm.get_staff(id)
    Restaurant::Staff.new(staff[0],staff[1])
  end

  def self.create_staff(name)
    Restaurant.orm.create_staff(name)
    Restaurant::Staff.new(staff[0],staff[1])
  end

  def list_open_orders #redundant?
    Restaurant::Order.list_open_orders
  end

  def list_closed_orders
    Restaurant::Order.list_closed_orders
  end

  def list_all_orders
    Restaurant::Order.list_orders
  end

  #complete an order

end
