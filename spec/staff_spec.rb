require 'spec_helper.rb'
require 'pry-byebug'

describe 'Restaurant::Staff' do
  xit 'exists' do
    expect(Restaurant::Staff).to be_a(Class)
  end

  describe '.create_staff' do
    xit 'returns a new Restaurant::Staff instance given a name' do
      expect(Restaurant::Staff.create_staff("Benny")).to be_a(Restaurant::Staff)
    end
  end

  describe '.get_id' do
    xit 'returns a Restaurant::Staff instance given an id' do
      Restaurant::Staff.create_staff("Benny")
      expect(Restaurant::Staff.get_id(1).name).to eq("Benny")
    end
  end

  describe '#complete_order' do
    xit 'returns the order number which was marked complete' do
      Benny = Restaurant::Staff.create_staff("Benny")
      Restaurant::Customer.create_customer("Sara")
      Restaurant::Order.create_order(1)

      expect(Benny.complete_order(1)).to eq("Order 1 marked complete")
    end
  end

  describe '#list_open_orders' do
    xit 'returns Restaurant::Order instances for all open orders' do
      Benny = Restaurant::Staff.create_staff("Benny")
      Restaurant::Customer.create_customer("Sara")
      Restaurant::Customer.create_customer("Betsy")
      Restaurant::Order.create_order(1)
      Restaurant::Order.create_order(2)

      expect(Benny.list_open_orders.length).to eq(2)
    end
  end

  describe '#list_closed_orders' do
    xit 'returns Restaurant::Order instances for all closed orders' do
      Benny = Restaurant::Staff.create_staff("Benny")
      Restaurant::Customer.create_customer("Sara")
      Restaurant::Customer.create_customer("Betsy")
      Restaurant::Order.create_order(1)
      Restaurant::Order.create_order(2)

      Benny.complete_order(1)

      expect(Benny.list_open_orders[0].id).to eq(2)
    end
  end

  describe '#list_all_orders' do
    xit 'returns Restaurant::Order instances for all orders' do
      Benny = Restaurant::Staff.create_staff("Benny")
      Restaurant::Customer.create_customer("Sara")
      Restaurant::Customer.create_customer("Betsy")
      Restaurant::Order.create_order(1)
      Restaurant::Order.create_order(2)

      Benny.complete_order(1)

      expect(Benny.list_all_orders.length).to eq(2)
    end
  end

  # describe '#list_items_in_order' do
  # end
end
