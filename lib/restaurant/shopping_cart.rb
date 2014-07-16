class Restaurant::Shopping_Cart

  attr_reader :id, :customer_id
  def initialize(id, customer_id)
    @id = id
    @customer_id = customer_id
  end

  def create_shopping_cart(customer_id)
    result = Restaurant.orm.add_shopping_cart(customer_id)
    shopping_cart = Restaurant::Shopping_Cart.new(result[0],result[1])
    shopping_cart
  end

  def self.get(id)
    result = Restaurant.orm.get_shopping_cart(id)
    Restaurant::Shopping_Cart.new(result[0], result[1])
  end

  def add_item(fid,quantity) #join table?
    Restaurant.orm.add_food_item(@id,fid,quantity)
    #what will it return?
  end

  def remove_item(fid)
    Restaurant.orm.remove_food_item(@id,fid)
    #what will it return?
  end

  def list_items
    result = Restaurant.orm.list_items_in_shopping_cart(@id)
    items = []

    result.each do |item|
      items << Restaurant::Food.new(item[0], item[1], item[2], item[3], item[4])
    end

    items #returns an array of food items
    #how to list the quantity of food items? look at change in orm to adjust for quantity
  end

  # def increase_quantity_of_item(fid)
  # end

  # def decrease_quantity_of_item(fid)
  # end

  def total #totals order for customer prior to submitting
  #return an array of the list items price
    result = Restaurant.orm.shopping_cart_item_prices(@id)
    total = result.each {|price| sum += price}
    total #changed how it's returned in orm
  end

  def submit(customer_id) #allows the customer to submit order to restaurant staff
    Restaurant::Order.create(customer_id)
  end
end
