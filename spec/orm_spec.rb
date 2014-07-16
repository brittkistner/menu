require 'spec_helper.rb'
require 'pry-byebug'

describe 'Orm' do
  before(:all) do
    Restaurant.orm.instance_variable_set(:@db_adaptor, PG.connect(host: 'localhost', dbname: 'menu-db-test'))
  end

  before(:each) do
    Restaurant.orm.reset_tables
  end

  after(:all) do
    Restaurant.orm.drop_tables
  end

  it "is an Orm" do
    expect(Restaurant.orm).to be_a(Restaurant::Orm)
  end

  xit 'is created with a db adaptor' do
    expect(Restaurant.orm.db_adaptor).not_to be_nil
  end

  ####FOOD CLASS ######
  describe '#create_food' do
    it 'adds a tuple to the food table and returns an array with the food information' do
      expect(Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")).to be_a(Array)
    end
  end

  describe '#get_food' do
    it 'looks up a food tuple by id and returns an array with the food information' do
      Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")
      expect(Restaurant.orm.get_food(1)).to be_a(Array)
    end
  end

  describe '#remove_food' do
    it 'removes a tuple from the food table and returns true' do
      Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")
      expect(Restaurant.orm.remove_food(1)).to eq(true)
    end
  end

  describe '#list_all_food' do
    it 'retrieves all information from the food table and returns as an array of arrays' do
      Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")
      Restaurant.orm.create_food("burrito", 8, "lunch", "entree")
      expect(Restaurant.orm.list_all_food.length).to eq(2)
    end
  end

  #####CUSTOMER CLASS#####
  describe '#create_customer' do
    it 'adds a tuple to the customer table and returns an array with the customer information' do
      expect(Restaurant.orm.create_customer("Benny")).to be_a(Array)
    end
  end

  describe '#get_customer' do
    it 'looks up a customer tuple by id and returns an array with the customer information' do
      Restaurant.orm.create_customer("Benny")
      expect(Restaurant.orm.get_customer(1)).to be_a(Array)
    end
  end

  ####SHOPPING_CART CLASS####
  describe '#add_shopping_cart'do
    it 'adds a tuple to the shopping_cart table and returns an array with the shopping_cart information' do
      Restaurant.orm.create_customer("Benny")
      expect(Restaurant.orm.add_shopping_cart(1)).to be_a(Array)
    end
  end

  describe '#get_shopping_cart' do
    it 'looks up a shopping_cart tuple by id and returns an array with the shopping_cart information' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)
      expect(Restaurant.orm.get_shopping_cart(1)).to be_a(Array)
      expect(Restaurant.orm.get_shopping_cart(1).length).to eq(2)
    end
  end

  describe '#add_food_item' do
    it 'adds a food item by id, with a specified quantity to a shopping cart with given id and returns true' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")

      expect(Restaurant.orm.add_food_item(1,1,2)).to eq(true)
    end
  end

  describe '#remove_food_item' do
    it 'removes a food item by id to a shopping cart with given id and returns true' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")

      Restaurant.orm.add_food_item(1,1,2)

      expect(Restaurant.orm.remove_food_item(1,1)).to eq(true)
    end
  end

  describe '#list_items_in_shopping_cart' do
    it 'retrieves all information from the shopping_cart, given the id, returns as an array of arrays with food entity information' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")
      Restaurant.orm.add_food_item(1,1,2)

      # binding.pry

      expect(Restaurant.orm.list_items_in_shopping_cart(1).length).to eq(1)
    end

    it 'returns an empty array when a food item is removed from the shopping cart' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")
      Restaurant.orm.add_food_item(1,1,2)
      Restaurant.orm.remove_food_item(1,1)

      expect(Restaurant.orm.list_items_in_shopping_cart(1).length).to eq(0)
    end
  end

  describe '#shopping_cart_item_prices' do
    it 'retrieves the prices for all items in a shopping_cart and returns as an array of prices' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")
      Restaurant.orm.create_food("burrito", 8, "lunch", "entree")

      Restaurant.orm.add_food_item(1,1,2)
      Restaurant.orm.add_food_item(1,2,1)

      expect(Restaurant.orm.shopping_cart_item_prices(1).length).to eq(2)
    end
  end

  describe '#increase_quantity_of_item' do
  end

  describe '#decrease_quantity_of_item' do
  end
#### MENU CLASS ####
  describe '#add_menu' do
    it 'creates a menu given a name and returns an array of menu information' do
      expect(Restaurant.orm.add_menu("lunch")).to be_a(Array)
    end
  end

  describe '#get_menu' do
    it 'looks up a menu tuple by id and returns an array with the menu information' do
      Restaurant.orm.add_menu("lunch")
      expect(Restaurant.orm.get_menu(1).length).to eq(2)
    end
  end

  describe '#get_food_items' do
    xit 'lists all food items given a menu id and category of food' do
      Restaurant.orm.add_menu("lunch")

      Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")
      Restaurant.orm.create_food("burrito", 8, "lunch", "entree")
      Restaurant.orm.create_food("pancakes", 8, "breakfast", "entree")

      binding.pry

      expect(Restaurant.orm.get_food_items(1,"lunch")).to be_a(Array)
      expect(Restaurant.orm.get_food_items(1,"lunch").length).to eq(2)
    end
  end

  describe '#get_beverages' do
    xit 'returns an array of all beverage items given a menu id and category of food' do
      Restaurant.orm.add_menu("lunch")

      Restaurant.orm.create_food("coke", 2, "lunch", "beverage")
      Restaurant.orm.create_food("burrito", 8, "lunch", "beverage")

      expect(Restaurant.orm.get_beverages(1,"lunch")).to be_a(Array)
      expect(Restaurant.orm.get_beverages(1,"lunch").length).to eq(2)
    end
  end
#### ORDER CLASS ####
  describe '#add_order' do
  end

  describe '#get_order' do
  end

  describe '#list_orders' do
  end

  describe '#list_items_in_order' do
  end

  describe '#list_open_orders' do
  end

  describe '#list_closed_orders' do
  end

  describe '#mark_complete' do
  end
#### STAFF CLASS ####
  describe '#create_staff' do
    it 'creates a staff member given a name and returns an array of staff information' do
      expect(Restaurant.orm.create_staff("Sara")).to be_a(Array)
    end
  end

  describe '#get_staff' do
    it 'looks up a staff tuple by id and returns an array with the staff information' do
      Restaurant.orm.create_staff("Sara")
      expect(Restaurant.orm.get_staff(1)).to be_a(Array)
      expect(Restaurant.orm.get_staff(1).length).to eq(2)
    end
  end

end
