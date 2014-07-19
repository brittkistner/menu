require 'spec_helper.rb'
require 'pry-byebug'

describe 'Restaurant::Food' do
  it 'exists' do
    expect(Restaurant::Food).to be_a(Class)
  end

  describe '.add_food' do
    it 'adds food to the food list given a name, price, and type_of_item and returns a food instance' do
      expect(Restaurant::Food.add_food("Coke", 2, "beverage")).to be_a(Restaurant::Food)
    end
  end

  describe '.get' do
    it 'takes a food id and returns a food instance' do
      Restaurant::Food.add_food("Coke", 2, "beverage")
      expect(Restaurant::Food.get(1)).to be_a(Restaurant::Food)
    end
  end

  describe '.remove_food' do
    it 'removes a food item from the food list given a food id' do
      Restaurant::Food.add_food("Coke", 2, "beverage")
      Restaurant::Food.remove_food(1)
      expect(Restaurant::Food.get(1)).to be_nil
    end
  end

  describe '.list' do
    it 'lists all food on the food list' do
      Restaurant::Food.add_food("Coke", 2, "beverage")
      Restaurant::Food.add_food("Pepsi", 5, "beverage")

      expect(Restaurant::Food.list.length).to eq(2)
    end
  end
end
