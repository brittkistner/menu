require 'spec_helper.rb'
require 'pry-byebug'

describe 'Restaurant::Menu' do
  it 'exists' do
    expect(Restaurant::Menu).to be_a(Class)
  end

  describe '.create_menu' do
    it 'creates a Restaurant::Menu instance given a name' do
      expect(Restaurant::Menu.create_menu('lunch')).to be_a(Restaurant::Menu)
    end
  end

  describe '.get_all' do
    it 'retrieves a list of all menus' do
      Restaurant::Menu.create_menu('lunch')
      Restaurant::Menu.create_menu('dinner')

      expect(Restaurant::Menu.get_all.length).to eq(2)
      expect(Restaurant::Menu.get_all[0].id).to eq(1)
    end
  end


  describe '#add_food_to_menu' do
    it 'adds food to menu given a food_id' do
      lunch = Restaurant::Menu.create_menu('lunch')
      food_1 = Restaurant::Food.create("Coke", 2, "beverage").id
      food_2 = Restaurant::Food.create("Pepsi", 5, "beverage").id

      lunch.add_food_to_menu(food_1)
      lunch.add_food_to_menu(food_2)

      expect(lunch.list_food.length).to eq(2)
      expect(lunch.list_food[0][0]).to eq(food_1)
    end
  end

  describe '#list_food' do
    it 'retrieves a list of all food ids on a menu' do
      lunch = Restaurant::Menu.create_menu('lunch')
      food_1 = Restaurant::Food.create("Coke", 2, "beverage").id
      food_2 = Restaurant::Food.create("Pepsi", 5, "beverage").id

      lunch.add_food_to_menu(food_1)
      lunch.add_food_to_menu(food_2)

      expect(lunch.list_food.length).to eq(2)
      expect(lunch.list_food[0]).to eq(food_1)
    end
  end
end
