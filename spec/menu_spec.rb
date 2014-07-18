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

  describe '.get' do
    it 'retrieves Restaurant::Menu instance given an id' do
      Restaurant::Menu.create_menu('lunch')
      expect(Restaurant::Menu.get(1).name).to eq('lunch')
    end
  end

  describe '#add_food_to_menu' do
    it 'adds food to menu given a food_id' do
      lunch = Restaurant::Menu.create_menu('lunch')
      Restaurant::Food.add_food("Coke", 2, "beverage")
      Restaurant::Food.add_food("Pepsi", 5, "beverage")

      lunch.add_food_to_menu(1)

      lunch.add_food_to_menu(2)

      expect(lunch.menu_list.length).to eq(2)
    end
  end

  describe '#get_beverages' do
    it 'lists all beverages on the menu instance' do
      lunch = Restaurant::Menu.create_menu('lunch')
      Restaurant::Food.add_food("Coke", 2, "beverage")
      Restaurant::Food.add_food("Pepsi", 5, "beverage")

      lunch.add_food_to_menu(1)
      lunch.add_food_to_menu(2)

      expect(lunch.get_beverages[0].name).to eq("Coke")
    end
  end

  describe '#get_appetizers' do
    it 'lists all appetizers on the menu instance' do
      lunch = Restaurant::Menu.create_menu('lunch')
      Restaurant::Food.add_food("Coke", 2, "beverage")
      Restaurant::Food.add_food("Nachos", 5, "appetizer")
      Restaurant::Food.add_food("Fries", 5, "appetizer")


      lunch.add_food_to_menu(1)
      lunch.add_food_to_menu(2)
      lunch.add_food_to_menu(3)

      expect(lunch.get_appetizers[0].name).to eq("Nachos")
    end
  end

  describe '#get_entrees' do
    it 'lists all entrees on the menu instance' do
      lunch = Restaurant::Menu.create_menu('lunch')
      Restaurant::Food.add_food("Coke", 2, "beverage")
      Restaurant::Food.add_food("Salmon", 5, "entree")

      lunch.add_food_to_menu(1)
      lunch.add_food_to_menu(2)

      expect(lunch.get_entrees[0].name).to eq("Salmon")
    end
  end
end
