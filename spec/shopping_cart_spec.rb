require 'spec_helper.rb'
require 'pry-byebug'

describe 'Shopping_Cart' do
  describe '.create_shopping_cart' do
    it 'creates a new instance of Restaurant::Shopping_Cart given a customer_id' do
      Restaurant::Customer.create_customer("Crissy")
      expect(Restaurant::Shopping_Cart.create_shopping_cart(1)).to be_a(Restaurant::Shopping_Cart)
    end
  end

  describe '.get' do
    it 'retrieves a Restaurant::Shopping_Cart instance given an id' do
      Restaurant::Customer.create_customer("Crissy")
      Restaurant::Shopping_Cart.create_shopping_cart(1)

      expect(Restaurant::Shopping_Cart.get(1)).to be_a(Restaurant::Shopping_Cart)
    end
  end

  describe '#add_item' do
    it 'adds a food item to the shopping cart given a food id and quantity of food' do
      Restaurant::Customer.create_customer("Crissy")
      Restaurant::Food.add_food("Coke", 2, "beverage")
      cart = Restaurant::Shopping_Cart.create_shopping_cart(1)

      expect(cart.list_items[0]).to eq(nil)

      cart.add_item(1,2)

      expect(cart.list_items[0]).to be_a(Restaurant::Food)
    end

    xit 'increases the quantity of a food item which is already in the shopping cart' do
      Restaurant::Customer.create_customer("Crissy")
      Restaurant::Food.add_food("Coke", 2, "beverage")
      cart = Restaurant::Shopping_Cart.create_shopping_cart(1)

      cart.add_item(1,2)

      # binding.pry

      expect(cart.food_quantity(1)[1]).to eq(2)

      cart.add_item(1,1)

      expect(cart.food_quantity(1)[1]).to eq(3)
    end
  end

  # describe '#food_quantity' do
  # end

  describe '#decrease_quantity_of_item' do
    xit 'removes a food item from the shopping cart given a food id and quantity of food' do
      Restaurant::Customer.create_customer("Crissy")
      Restaurant::Food.add_food("Coke", 2, "beverage")
      cart = Restaurant::Shopping_Cart.create_shopping_cart(1)
      cart.add_item(1,2)

      expect(cart.food_quantity(1)[1]).to eq(2)

      cart.remove_item(1,1)

      expect(cart.food_quantity(1)[1]).to eq(1)
    end

    xit 'will not allow user to decrease item below zero' do
      Restaurant::Customer.create_customer("Crissy")
      Restaurant::Food.add_food("Coke", 2, "beverage")
      cart = Restaurant::Shopping_Cart.create_shopping_cart(1)
      cart.add_item(1,2)

      expect(cart.food_quantity(1)[1]).to eq(2)

      cart.remove_item(1,1)

      expect(cart.food_quantity(1)[1]).to eq(1)  ##WHAT SHOULD THIS RETURN??
    end

    xit 'will remove item from shopping cart if food quantity is zero' do
      Restaurant::Customer.create_customer("Crissy")
      Restaurant::Food.add_food("Coke", 2, "beverage")
      cart = Restaurant::Shopping_Cart.create_shopping_cart(1)
      cart.add_item(1,2)

      expect(cart.food_quantity(1)[1]).to eq(2)

      cart.remove_item(1,2)

      expect(cart.food_quantity(1)[1]).to eq(1) ##RETURN FALSE???
    end
  end

  describe 'list_items' do
    xit 'returns an array of food items in the shopping cart' do
      Restaurant::Customer.create_customer("Crissy")
      cart = Restaurant::Shopping_Cart.create_shopping_cart(1)
      Restaurant::Food.add_food("Coke", 2, "beverage")
      cart.add_item(1,2)

      expect(cart.list_items[0]).to be_a(Restaurant::Food)
    end
  end

  # describe '#total' do
  #   xit 'totals the shopping cart' do
  #     Restaurant::Customer.create_customer("Crissy")
  #     Restaurant::Shopping_Cart.create_shopping_cart(1)
  #   end
  # end

  # describe '#submit' do
  # end
end
