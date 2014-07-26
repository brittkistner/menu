require 'spec_helper.rb'
require 'pry-byebug'

describe 'Restuarant::Customer' do
it 'exists' do
    expect(Restaurant::Customer).to be_a(Class)
  end

  describe '.create_customer' do
    it 'creates a new customer given a name' do
      customer = Restaurant::Customer.create_customer("Crissy")
      expect(customer.name).to eq("Crissy")
    end
  end

  describe '.get' do
    it 'returns a customer instance given an id' do
      customer_id = Restaurant::Customer.create_customer("Crissy").id
      expect(Restaurant::Customer.get(customer_id)).to be_a(Restaurant::Customer)
    end
  end

  describe '#create_shopping_cart' do
    it 'creates a new shopping cart instance' do
      customer = Restaurant::Customer.create_customer("Crissy")
      expect(customer.create_shopping_cart).to be_a(Restaurant::Shopping_Cart)
    end
  end

  describe '#get_all_shopping_carts' do
    it 'creates a new shopping cart instance' do
      customer = Restaurant::Customer.create_customer("Crissy")
      customer.create_shopping_cart
      customer.create_shopping_cart

      expect(customer.get_all_shopping_carts[0]).to be_a(Restaurant::Shopping_Cart)
      expect(customer.get_all_shopping_carts.length).to eq(2)
    end
  end

end
