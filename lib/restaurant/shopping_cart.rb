class Restaurant::Shopping_Cart

  attr_reader :id, :customer_id
  def initialize(id, customer_id)
    @id = Integer(id)
    @customer_id = Integer(customer_id)
  end

  def self.create_shopping_cart(customer_id)
    result = Restaurant.orm.add_shopping_cart(customer_id)
    shopping_cart = Restaurant::Shopping_Cart.new(result[0],result[1])
    shopping_cart
  end

  def self.get(id)
    result = Restaurant.orm.get_shopping_cart(id)
    Restaurant::Shopping_Cart.new(result[0], result[1])
  end

  def add_item(fid,quantity)
    Restaurant.orm.add_food_item(@id,fid,quantity)
  end

  def decrease_food(fid, quantity)
    Restaurant.orm.decrease_food(@id,fid,quantity)
  end

  def food_quantity(fid) #will return the food id and food quantity from the shopping cart as an array [food_id, food_quantity]
    result=Restaurant.orm.get_food_from_shopping_cart(@id,fid)
    array = [result[0].to_i, result[1].to_i]
    array
  end

  def list_items
    result = Restaurant.orm.list_items_in_shopping_cart(@id)
    items = []

    result.each do |item|
      items << Restaurant::Food.new(item[0], item[1], item[2], item[3])
    end

    items #returns an array of food items
  end

##Need a method with a food instance + quantity


  def decrease_quantity_of_item(fid, quantity)
    Restaurant.orm.decrease_quantity_of_item(@id, fid, quantity)
  end

  def total #totals order for customer prior to submitting
    # result = Restaurant.orm.shopping_cart_item_prices(@id) #returns an array of arrays of [food_price, food_quantity]
    # # total = result.each {|price| sum += price}
    # result.each do |array|
    #   array.each do
    # total #changed how it's returned in orm

    #list items
    #iterate through each object food.price * food.quantity
  end

  def submit(customer_id) #allows the customer to submit order to restaurant staff
    order = Restaurant::Order.create(customer_id)
    Restaurant.orm.submit(@id, order.id)
    'Order #{order.id} created'
  end
end
