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
      Restaurant::Customer.create_customer("Crissy")
      expect(Restaurant::Customer.get(1)).to be_a(Restaurant::Customer)
    end
  end

  describe '#create_shopping_cart' do
    it 'creates a new shopping cart instance' do
      customer = Restaurant::Customer.create_customer("Crissy")
      expect(customer.create_shopping_cart).to be_a(Restaurant::Shopping_Cart)
    end
  end

  describe '#get_all_shopping_carts' do
    xit 'creates a new shopping cart instance' do
      customer = Restaurant::Customer.create_customer("Crissy")
      # FINISH
    end
  end

end
