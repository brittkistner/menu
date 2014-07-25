require 'spec_helper.rb'
require 'pry-byebug'

describe 'Restaurant::Food' do
  it 'exists' do
    expect(Restaurant::Food).to be_a(Class)
  end

  describe '.create' do
    it 'creates a new food given a name, price, and type_of_item and returns a food instance' do
      expect(Restaurant::Food.create("Coke", 2, "beverage")).to be_a(Restaurant::Food)
    end
  end

  describe '.get' do
    it 'takes a food id and returns a food instance' do
      Restaurant::Food.create("Coke", 2, "beverage")
      expect(Restaurant::Food.get(1)).to be_a(Restaurant::Food)
    end
  end

  describe '.delete_food' do
    xit 'deletes a food item from the food list given a food id' do
      Restaurant::Food.create("Coke", 2, "beverage")
      Restaurant::Food.delete_food(1)
      expect(Restaurant::Food.get(1)).to be_nil
    end
  end

  describe '.get_all' do
    xit 'retrieves all food on the food list' do
      Restaurant::Food.create("Coke", 2, "beverage")
      Restaurant::Food.create("Pepsi", 5, "beverage")

      expect(Restaurant::Food.get_all.length).to eq(2)
    end
  end
end
