class Restaurant::Shopping_Cart

  attr_reader :id, :customer_id
  def initialize(id, customer_id)
    @id =id
    @customer_id = customer_id
  end

  def update_shopping_cart_add_food(food_id,quantity)
    Restaurant.orm.update_shopping_cart_add_food(@id,food_id,quantity) #returns boolean
  end
def update_shopping_cart_remove_food(food_id, quantity)
    Restaurant.orm.update_shopping_cart_remove_food(@id,food_id,quantity) #returns boolean
  end

  def read_shopping_cart_food_quantity(food_id)
    result = Restaurant.orm.read_shopping_cart_food_quantity(@id, food_id) #returns food quantity
    if result.nil?
      return nil
    else
      result[:food_quantity]
    end
  end

  def get_all_food_and_quantity #returns list of [food_id, food_quantity]
    result = Restaurant.orm.read_shopping_cart_foods(@id)

    if result.nil?
      return nil
    else
      list = []

      result.each do |item|
        list << [item[:food_id],item[:food_quantity]]
      end

      list
    end
  end

end
