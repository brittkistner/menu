require 'spec_helper.rb'
require 'pry-byebug'

describe 'Shopping_Cart' do

  describe '#read_shopping_cart_food_quantity' do
    it 'returns food_quantity when given a food id' do
      cust = Restaurant::Customer.create_customer("Crissy")
      food_id = Restaurant::Food.create("Coke", 2, "beverage").id

      cart = cust.create_shopping_cart
      cart.update_shopping_cart_add_food(food_id,2)

      expect(cart.read_shopping_cart_food_quantity(food_id)).to eq(2)
    end
  end

  describe '#update_shopping_cart_add_food' do
    it 'adds a food item to the shopping cart given a food id and quantity of food' do
      cust = Restaurant::Customer.create_customer("Crissy")
      food_id = Restaurant::Food.create("Coke", 2, "beverage").id

      cart = cust.create_shopping_cart
      cart.update_shopping_cart_add_food(food_id,2)

      expect(cart.read_shopping_cart_food_quantity(food_id)).to eq(2)
    end

    it 'increases the quantity of a food item which is already in the shopping cart' do
      cust = Restaurant::Customer.create_customer("Crissy")
      food_id = Restaurant::Food.create("Coke", 2, "beverage").id

      cart = cust.create_shopping_cart
      cart.update_shopping_cart_add_food(food_id,2)

      expect(cart.read_shopping_cart_food_quantity(food_id)).to eq(2)

      cart.update_shopping_cart_add_food(food_id,2)
      expect(cart.read_shopping_cart_food_quantity(food_id)).to eq(4)
    end
  end

  describe '#update_shopping_cart_remove_food' do
    it 'removes a food item from the shopping cart given a food id and quantity of food' do
      cust = Restaurant::Customer.create_customer("Crissy")
      food_id = Restaurant::Food.create("Coke", 2, "beverage").id

      cart = cust.create_shopping_cart
      cart.update_shopping_cart_add_food(food_id,2)
      expect(cart.read_shopping_cart_food_quantity(food_id)).to eq(2)

      cart.update_shopping_cart_remove_food(food_id,1)
      expect(cart.read_shopping_cart_food_quantity(food_id)).to eq(1)
    end

    it 'will not allow customer to decrease item below zero, will remove food item instead' do
      cust = Restaurant::Customer.create_customer("Crissy")
      food_id = Restaurant::Food.create("Coke", 2, "beverage").id

      cart = cust.create_shopping_cart
      cart.update_shopping_cart_add_food(food_id,2)
      expect(cart.read_shopping_cart_food_quantity(food_id)).to eq(2)

      cart.update_shopping_cart_remove_food(food_id,3)
      expect(cart.read_shopping_cart_food_quantity(food_id)).to eq(0)
    end
  end

  describe '#get_all_food_and_quantity' do
    it 'returns list of food id and quantity for shopping cart' do
      cust = Restaurant::Customer.create_customer("Crissy")
      food_id1 = Restaurant::Food.create("Coke", 2, "beverage").id
      food_id2 = Restaurant::Food.create("Pepsi", 2, "beverage").id

      cart = cust.create_shopping_cart
      cart.update_shopping_cart_add_food(food_id1,2)
      cart.update_shopping_cart_add_food(food_id2,5)

      expect(cart.get_all_food_and_quantity.length).to eq(2)
      expect(cart.get_all_food_and_quantity[0][1]).to eq(2)
    end
  end

end
