class Restaurant::Customer

  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def self.create_customer(name)
    result = Restaurant.orm.create_customer(name)
    Restaurant::Customer.new(result[:id],name)
  end

  def self.get(id)
    result = Restaurant.orm.read_customer(id)
    Restaurant::Customer.new(id,result[:name])
  end

  def create_shopping_cart
    result = Restaurant.orm.update_customer_add_shopping_cart(@id)
    Restaurant::Shopping_Cart.new(result[:id], @id)
  end

  def get_all_shopping_carts
    result = Restaurant.orm.read_customer_shopping_carts(@id)

    if result.nil?
      return nil
    else
      list = []

      result.each do |shopping_cart|
        list << Restaurant::Shopping_Cart.new(shopping_cart[:id], shopping_cart[:customer_id])
      end

      list
    end
  end

end
