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

  ####FOOD CLASS ######
  describe '#create_food' do
    it 'adds a tuple to the food table and returns an array with the food information' do
      expect(Restaurant.orm.create_food("hamburger", 10, "entree")).to be_a(Array)
    end
  end

  describe '#read_food_by_id' do
    it 'looks up a food tuple by id and returns an array with the food information' do
      Restaurant.orm.create_food("hamburger", 10,"entree")
      expect(Restaurant.orm.read_food_by_id(1)).to be_a(Array)
    end
  end

  describe '#delete_food' do
    it 'removes a tuple from the food table and returns true' do
      Restaurant.orm.create_food("hamburger", 10, "entree")
      Restaurant.orm.delete_food(1)
      expect(Restaurant.orm.read_food_by_id(1)).to be_nil
    end
  end

  describe '#read_foods' do
    it 'retrieves all information from the food table and returns as an array of arrays' do
      Restaurant.orm.create_food("hamburger", 10, "entree")
      Restaurant.orm.create_food("burrito", 8, "entree")
      expect(Restaurant.orm.read_foods.length).to eq(2)
    end
  end

  #####CUSTOMER CLASS#####
  describe '#create_customer' do
    it 'adds a tuple to the customer table and returns an array with the customer information' do
      expect(Restaurant.orm.create_customer("Benny")).to be_a(Array)
    end
  end

  describe '#read_customer' do
    it 'looks up a customer tuple by id and returns an array with the customer information' do
      Restaurant.orm.create_customer("Benny")
      expect(Restaurant.orm.read_customer(1)).to be_a(Array)
    end
  end

  describe 'update_customer_add_shopping_cart' do
    it 'adds a shopping cart given a customer id and returns the shopping cart id' do
    end
  end

  describe 'read_customer_shopping_carts' do
    it 'looks up all customer shopping carts and returns an array with shopping cart id and customer id' do
    end
  end

  ####SHOPPING_CART CLASS####

  describe 'read_shopping_cart_food_quantity' do
    xit 'given the shopping cart id and food id, returns the food id and quantity' do
      # Restaurant.orm.create_customer("Benny")
      # Restaurant.orm.add_shopping_cart(1)

      # Restaurant.orm.create_food("hamburger", 10, "entree")

      # Restaurant.orm.add_food_item(1,1,2)

      # expect(Restaurant.orm.get_food_quantity_from_shopping_cart(1,1)).to eq(2)
    end

    xit 'returns false if no food matching the food is is in the shopping cart' do
      # Restaurant.orm.create_customer("Benny")
      # Restaurant.orm.add_shopping_cart(1)

      # expect(Restaurant.orm.get_food_quantity_from_shopping_cart(1,1)).to eq(0)
    end
  end

  describe '#read_shopping_cart_foods' do
    it 'given a shopping cart id, retrieves all food ids and quantities of each food as an array' do
      # Restaurant.orm.create_customer("Benny")
      # Restaurant.orm.add_shopping_cart(1)

      # Restaurant.orm.create_food("hamburger", 10, "entree")
      # Restaurant.orm.add_food_item(1,1,2)

      # expect(Restaurant.orm.list_items_in_shopping_cart(1).length).to eq(1)
    end
  end
  describe '#update_shopping_cart_remove_food' do
    xit 'adds food to an empty cart' do
    end
    xit 'increases the quantity of food in the shopping cart' do
    end
  end


  describe '#update_shopping_cart_remove_food' do
    xit 'checks if the food item exists in the shopping cart' do
      # Restaurant.orm.create_customer("Benny")
      # Restaurant.orm.add_shopping_cart(1)

      # expect(Restaurant.orm.decrease_quantity_of_item(1,1,2)).to eq(false)
    end

    xit 'updates the quantity of a food item in the shopping cart' do
      # Restaurant.orm.create_customer("Benny")
      # Restaurant.orm.add_shopping_cart(1)

      # Restaurant.orm.create_food("hamburger", 10, "entree")

      # Restaurant.orm.add_food_item(1,1,4)

      # Restaurant.orm.decrease_quantity_of_item(1,1,2)
      # expect(Restaurant.orm.list_items_in_shopping_cart(1)[0][4]).to eq(2)
    end

    xit 'does not allow the quantity of food items in a shopping cart to go negative' do
      # Restaurant.orm.create_customer("Benny")
      # Restaurant.orm.add_shopping_cart(1)

      # Restaurant.orm.create_food("hamburger", 10, "entree")

      # Restaurant.orm.add_food_item(1,1,4)

      # expect(Restaurant.orm.decrease_quantity_of_item(1,1,5)).to eq(false)
    end

    xit 'removes an item from the shopping cart when the quantity is zero' do
      # Restaurant.orm.create_customer("Benny")
      # Restaurant.orm.add_shopping_cart(1)

      # Restaurant.orm.create_food("hamburger", 10, "entree")

      # Restaurant.orm.add_food_item(1,1,4)

      # Restaurant.orm.decrease_quantity_of_item(1,1,4)

      # expect(Restaurant.orm.get_food_from_shopping_cart(1,1)).to eq(false)
    end
  end

#### MENU CLASS ####
  describe '#create_menu' do
    xit 'creates a menu given a name and returns the menu id' do
      expect(Restaurant.orm.create_menu("lunch")[0].to_i).to eq(1)
    end
  end

  describe 'read_menus' do
    xit 'lists all menus and menu information' do
      Restaurant.orm.create_menu("lunch")
      Restaurant.orm.create_menu("dinner")

      expect(Restaurant.orm.read_menus).to be_a(Array)
      expect(Restaurant.orm.read_menus[0][1]).to eq("lunch")
    end
  end

  describe '#add_menus_food' do
    xit 'adds a food item to the menu given a menu_id and food_id and returns a boolean' do
      Restaurant.orm.create_menu("lunch")

      # Restaurant.orm.create_food("hamburger", 10, "entree")

      # expect(Restaurant.orm.add_food_to_menu(1,1)).to be_a(Array)
    end
  end

  describe '#read_menu_foods' do
    xit 'returns all food listed on a menu given a menu id' do
      Restaurant.orm.create_menu("lunch")
      ##COMPLETE

    end
  end

#### ORDER CLASS ####


  describe '#list_orders' do
    it 'lists all orders and returns an array of arrays with order information' do

    end
  end

  describe '#read_orders_by_status' do
    xit 'returns an array of orders by id and status' do

    end
  end

  describe '#mark_complete' do
    xit 'marks an order complete by id' do

    end
  end




#### STAFF CLASS ####
  describe '#create_staff' do
    it 'creates a staff member given a name and returns a staff id' do
      expect(Restaurant.orm.create_staff("Sara")[0].to_i).to eq(1)
    end
  end

end
