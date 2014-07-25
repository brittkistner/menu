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
    it 'adds a tuple to the food table and returns a hash with the food information' do
      expect(Restaurant.orm.create_food("hamburger", 10, "entree")[:name]).to eq("hamburger")
    end
  end

  describe '#read_food_by_id' do
    it 'looks up a food tuple by id and returns a hash with the food information' do
      Restaurant.orm.create_food("hamburger", 10,"entree")
      expect(Restaurant.orm.read_food_by_id(1)[:name]).to eq("hamburger")
    end
  end

  describe '#delete_food' do
    it 'removes a tuple from the food table and returns true' do
      Restaurant.orm.create_food("hamburger", 10, "entree")
      expect(Restaurant.orm.delete_food(1)).to be_true
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
    it 'adds a tuple to the customer table and returns customer id' do
      expect(Restaurant.orm.create_customer("Benny")[:id]).to eq(1)
    end
  end

  describe '#read_customer' do
    it 'looks up a customer tuple by id and returns a hash with the customer information' do
      Restaurant.orm.create_customer("Benny")
      expect(Restaurant.orm.read_customer(1)[:name]).to eq("Benny")
    end
  end

  describe 'update_customer_add_shopping_cart' do
    it 'adds a shopping cart given a customer id and returns the shopping cart id' do
      Restaurant.orm.create_customer("Benny")
      expect(Restaurant.orm.update_customer_add_shopping_cart(1)[:id]).to eq(1)
    end
  end

  describe 'read_customer_shopping_carts' do
    xit 'looks up all customer shopping carts and returns an array with shopping cart id and customer id' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.update_customer_add_shopping_cart(1)
      Restaurant.orm.update_customer_add_shopping_cart(1)

      expect(Restaurant.orm.read_customer_shopping_carts(1).length).to eq(2)
    end
  end

  ####SHOPPING_CART CLASS####

  describe 'read_shopping_cart_food_quantity' do
    it 'given the shopping cart id and food id, returns the food id and quantity' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.update_customer_add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "entree")

      Restaurant.orm.update_shopping_cart_add_food(1,1,2)

      expect(Restaurant.orm.read_shopping_cart_food_quantity(1,1)[:food_quantity]).to eq(2)
    end
  end

  describe '#update_shopping_cart_remove_food' do
    it 'adds food to an empty cart' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.update_customer_add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "entree")

      expect(Restaurant.orm.read_shopping_cart_food_quantity(1,1)).to eq(0)

      Restaurant.orm.update_shopping_cart_add_food(1,1,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(1,1)[:food_quantity]).to eq(2)
    end

    it 'if food already exists in shopping cart, will increase the food quantity' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.update_customer_add_shopping_cart(1)
      Restaurant.orm.create_food("hamburger", 10, "entree")

      Restaurant.orm.update_shopping_cart_add_food(1,1,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(1,1)[:food_quantity]).to eq(2)

      Restaurant.orm.update_shopping_cart_add_food(1,1,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(1,1)[:food_quantity]).to eq(4)
    end
  end


  describe '#update_shopping_cart_remove_food' do
    it 'updates the quantity of a food item in the shopping cart' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.update_customer_add_shopping_cart(1)
      Restaurant.orm.create_food("hamburger", 10, "entree")

      Restaurant.orm.update_shopping_cart_add_food(1,1,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(1,1)[:food_quantity]).to eq(2)

      Restaurant.orm.update_shopping_cart_remove_food(1,1,1)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(1,1)[:food_quantity]).to eq(1)
    end

    it 'does not allow the quantity of food items in a shopping cart to go negative' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.update_customer_add_shopping_cart(1)
      Restaurant.orm.create_food("hamburger", 10, "entree")

      Restaurant.orm.update_shopping_cart_add_food(1,1,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(1,1)[:food_quantity]).to eq(2)

      Restaurant.orm.update_shopping_cart_remove_food(1,1,3)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(1,1)).to eq(0)
    end

    it 'removes an item from the shopping cart when the quantity is zero' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.update_customer_add_shopping_cart(1)
      Restaurant.orm.create_food("hamburger", 10, "entree")

      Restaurant.orm.update_shopping_cart_add_food(1,1,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(1,1)[:food_quantity]).to eq(2)

      Restaurant.orm.update_shopping_cart_remove_food(1,1,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(1,1)).to eq(0)
    end
  end

#### MENU CLASS ####
  describe '#create_menu' do
    it 'creates a menu given a name and returns the menu id' do
      expect(Restaurant.orm.create_menu("lunch")[:id]).to eq(1)
    end
  end

  describe 'read_menus' do
    it 'lists menu id and name for each menu' do
      Restaurant.orm.create_menu("lunch")
      Restaurant.orm.create_menu("dinner")

      expect(Restaurant.orm.read_menus[1][:name]).to eq("dinner")
    end
  end

  describe '#add_menus_food' do
    it 'adds a food item to the menu given a menu_id and food_id' do
      Restaurant.orm.create_menu("lunch")
      Restaurant.orm.create_food("hamburger", 10, "entree")
      Restaurant.orm.add_menus_foods(1,1)
      expect(Restaurant.orm.read_menu_foods(1)[0][:id]).to eq(1)
    end
  end

  describe '#read_menu_foods' do
    it 'returns all food listed on a menu given a menu id' do
      Restaurant.orm.create_menu("lunch")
      Restaurant.orm.create_food("hamburger", 10, "entree")
      Restaurant.orm.add_menus_foods(1,1)

      expect(Restaurant.orm.read_menu_foods(1)[0][:id]).to eq(1)
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
      expect(Restaurant.orm.create_staff("Sara")[:id]).to eq(1)
    end
  end

end
