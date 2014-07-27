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
      expect(Restaurant.orm.create_food("hamburger", 10, "entree")[:id]).to eq(1)
    end
  end

  describe '#read_food_by_id' do
    it 'looks up a food tuple by id and returns a hash with the food information' do
      food_id = Restaurant.orm.create_food("hamburger", 10,"entree")[:id]
      expect(Restaurant.orm.read_food_by_id(food_id)[:name]).to eq("hamburger")
    end
  end

  describe '#delete_food' do
    it 'removes a tuple from the food table and returns true' do
      food_id = Restaurant.orm.create_food("hamburger", 10,"entree")[:id]
      expect(Restaurant.orm.delete_food(food_id)).to be_true
      expect(Restaurant.orm.read_food_by_id(food_id)).to be_nil
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
      customer_id = Restaurant.orm.create_customer("Benny")[:id]
      expect(Restaurant.orm.read_customer(customer_id)[:name]).to eq("Benny")
    end
  end

  describe 'update_customer_add_shopping_cart' do
    it 'adds a shopping cart given a customer id and returns the shopping cart id' do
      customer_id = Restaurant.orm.create_customer("Benny")[:id]
      expect(Restaurant.orm.update_customer_add_shopping_cart(customer_id)[:id]).to eq(1)
    end
  end

  describe 'read_customer_shopping_carts' do
    it 'looks up all customer shopping carts and returns an array with shopping cart id and customer id' do
      customer_id = Restaurant.orm.create_customer("Benny")[:id]
      Restaurant.orm.update_customer_add_shopping_cart(customer_id)
      Restaurant.orm.update_customer_add_shopping_cart(customer_id)

      expect(Restaurant.orm.read_customer_shopping_carts(customer_id).length).to eq(2)
    end
  end

  ####SHOPPING_CART CLASS####

  describe 'read_shopping_cart_food_quantity' do
    it 'given the shopping cart id and food id, returns the food id and quantity' do
      customer_id = Restaurant.orm.create_customer("Benny")[:id]
      shopping_cart_id = Restaurant.orm.update_customer_add_shopping_cart(customer_id)[:id]

      food_id = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]

      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id,2)

      expect(Restaurant.orm.read_shopping_cart_food_quantity(shopping_cart_id,food_id)[:food_quantity]).to eq(2)
    end
  end

  describe '#update_shopping_cart_remove_food' do
    it 'adds food to an empty cart' do
      customer_id = Restaurant.orm.create_customer("Benny")[:id]
      shopping_cart_id = Restaurant.orm.update_customer_add_shopping_cart(customer_id)[:id]

      food_id = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]

      expect(Restaurant.orm.read_shopping_cart_food_quantity(shopping_cart_id,food_id)).to be_nil

      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(1,1)[:food_quantity]).to eq(2)
    end

    it 'if food already exists in shopping cart, will increase the food quantity' do
      customer_id = Restaurant.orm.create_customer("Benny")[:id]
      shopping_cart_id = Restaurant.orm.update_customer_add_shopping_cart(customer_id)[:id]
      food_id = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]

      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(shopping_cart_id,food_id)[:food_quantity]).to eq(2)

      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(shopping_cart_id,food_id)[:food_quantity]).to eq(4)
    end
  end


  describe '#update_shopping_cart_remove_food' do
    it 'updates the quantity of a food item in the shopping cart' do
      customer_id = Restaurant.orm.create_customer("Benny")[:id]
      shopping_cart_id = Restaurant.orm.update_customer_add_shopping_cart(customer_id)[:id]
      food_id = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]

      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(shopping_cart_id,food_id)[:food_quantity]).to eq(2)

      Restaurant.orm.update_shopping_cart_remove_food(shopping_cart_id,food_id,1)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(shopping_cart_id,food_id)[:food_quantity]).to eq(1)
    end

    it 'does not allow the quantity of food items in a shopping cart to go negative' do
      customer_id = Restaurant.orm.create_customer("Benny")[:id]
      shopping_cart_id = Restaurant.orm.update_customer_add_shopping_cart(customer_id)[:id]
      food_id = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]

      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(shopping_cart_id,food_id)[:food_quantity]).to eq(2)

      Restaurant.orm.update_shopping_cart_remove_food(shopping_cart_id,food_id,3)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(shopping_cart_id,food_id)).to be_nil
    end

    it 'removes an item from the shopping cart when the quantity is zero' do
      customer_id = Restaurant.orm.create_customer("Benny")[:id]
      shopping_cart_id = Restaurant.orm.update_customer_add_shopping_cart(customer_id)[:id]
      food_id = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]

      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(shopping_cart_id,food_id)[:food_quantity]).to eq(2)

      Restaurant.orm.update_shopping_cart_remove_food(shopping_cart_id,food_id,2)
      expect(Restaurant.orm.read_shopping_cart_food_quantity(shopping_cart_id,food_id)).to be_nil
    end

    describe '#read_shopping_cart_foods' do
      it 'returns an array of food id and quantity for a shopping cart' do
        customer_id = Restaurant.orm.create_customer("Benny")[:id]
        shopping_cart_id = Restaurant.orm.update_customer_add_shopping_cart(customer_id)[:id]
        food_id1 = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]
        food_id2 = Restaurant.orm.create_food("burrito", 8, "entree")[:id]

        Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id1,2)
        Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id2,10)

        expect(Restaurant.orm.read_shopping_cart_foods(shopping_cart_id).length).to eq(2)
      end
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

  describe '#add_menus_foods' do
    it 'adds a food item to the menu given a menu_id and food_id' do
      menu_id = Restaurant.orm.create_menu("lunch")[:id]
      food_id = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]
      Restaurant.orm.add_menus_foods(menu_id, food_id)
      expect(Restaurant.orm.read_menu_foods(menu_id)[0][:id]).to eq(1)
    end
  end

  describe '#read_menu_foods' do
    it 'returns all food listed on a menu given a menu id' do
      menu_id = Restaurant.orm.create_menu("lunch")[:id]
      food_id = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]
      Restaurant.orm.add_menus_foods(menu_id, food_id)
      expect(Restaurant.orm.read_menu_foods(menu_id)[0][:id]).to eq(1)
    end
  end

#### ORDER CLASS ####
  describe '#create_order_delete_shopping_cart' do
    it 'creates a new order given a shopping_cart_id and deletes the shopping_cart' do
      customer_id = Restaurant.orm.create_customer("Benny")[:id]
      shopping_cart_id = Restaurant.orm.update_customer_add_shopping_cart(customer_id)[:id]
      food_id = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]
      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id,2)

      expect(Restaurant.orm.create_order_delete_shopping_cart(shopping_cart_id)[:id]).to eq(1)
    end
  end

  describe '#read_orders_by_status' do
    it 'returns an array of orders by id and status' do
      #order_1
      customer_id1 = Restaurant.orm.create_customer("Benny")[:id]
      shopping_cart_id1 = Restaurant.orm.update_customer_add_shopping_cart(customer_id1)[:id]
      food_id1 = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]
      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id1,food_id1,2)
      Restaurant.orm.create_order_delete_shopping_cart(shopping_cart_id1)

      #order_2
      customer_id2 = Restaurant.orm.create_customer("Fred")[:id]
      shopping_cart_id2 = Restaurant.orm.update_customer_add_shopping_cart(customer_id2)[:id]
      food_id2 = Restaurant.orm.create_food("tuna", 1, "entree")[:id]
      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id2,food_id2,20)
      Restaurant.orm.create_order_delete_shopping_cart(shopping_cart_id2)

      expect(Restaurant.orm.read_orders_by_status).to be_a(Array)
      expect(Restaurant.orm.read_orders_by_status.length).to eq(2)
    end
  end

  describe '#update_order_status' do
    xit 'changes the status of an order' do
      customer_id = Restaurant.orm.create_customer("Benny")[:id]
      shopping_cart_id = Restaurant.orm.update_customer_add_shopping_cart(customer_id)[:id]
      food_id = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]
      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id,2)
      order_id = Restaurant.orm.create_order_delete_shopping_cart(shopping_cart_id)[:id]

      expect(update_order_status(order_id, "closed")).to eq(true)
      expect(Restaurant.orm.read_orders_by_status[0][:status]).to eq("closed")
    end
  end

  describe '#read_order_foods' do
    xit 'looks up order by id and returns an array of hashes with food ids and food quantities' do
      customer_id = Restaurant.orm.create_customer("Fred")[:id]
      shopping_cart_id = Restaurant.orm.update_customer_add_shopping_cart(customer_id)[:id]
      food_id1 = Restaurant.orm.create_food("hamburger", 10, "entree")[:id]
      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id1,2)
      food_id2 = Restaurant.orm.create_food("tuna", 1, "entree")[:id]
      Restaurant.orm.update_shopping_cart_add_food(shopping_cart_id,food_id2,20)

      order_id = Restaurant.orm.create_order_delete_shopping_cart(shopping_cart_id)[:id]

      expect(read_order_foods(order_id)).to be_a(Array)
      expect(read_order_foods(order_id)[0][:food_id]).to eq(food_id1)
    end
  end

#### STAFF CLASS ####
  describe '#create_staff' do
    it 'creates a staff member given a name and returns a staff id' do
      expect(Restaurant.orm.create_staff("Sara")[:id]).to eq(1)
    end
  end

end
