require 'spec_helper.rb'
require 'pry-byebug'

describe 'Restaurant::Order' do
  xit 'exists' do
    expect(Restaurant::Order).to be_a(Class)
  end

  describe '.create_order_delete_shopping_cart' do
    xit 'creates a new order given a shopping_cart_id and deletes the shopping_cart and returns an order instance' do
      customer = Restaurant::Customer.create_customer("Crissy")
      shopping_cart_id = customer.create_shopping_cart.id

      expect(Restaurant::Order.create_order_delete_shopping_cart(shopping_cart_id)).to be_a(Restaurant::Order)
    end
  end

  describe '.get_orders_by_status' do
    xit 'returns an array of orders by id and status'
      customer = Restaurant::Customer.create_customer("Crissy")
      shopping_cart_id = customer.create_shopping_cart.id
  end

  describe '#update_order_status' do
    xit 'changes the status of an order to open or closed' do
    end
  end

  describe '#read_order_foods' do
    xit 'looks up order by id and returns a nested array with food ids and food quantities' do
    end
  end
end
