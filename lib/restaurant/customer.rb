class Restaurant::Customer

  attr_reader :id, :name

  def initialize(id, name)
    @id = Integer(id)
    @name = name
  end

  def self.get(id)
    result = Restaurant.orm.get_customer(id)
    Restaurant::Customer.new(result[0],result[1])
  end

  def self.create_customer(name)
    result = Restaurant.orm.create_customer(name)
    Restaurant::Customer.new(result[0], result[1])
  end

  def get_menu(mid)
    Restaurant::Menu.get(mid)
  end

  def get_shopping_cart
    Restaurant::Shopping_Cart.create_shopping_cart(@id)
  end

#call submit on the shopping cart for the order?
  # def order
  #   Restaurant::Order.create(@id)
  # end

  #login,username, password, payment information

end
