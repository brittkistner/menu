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

  describe '#get_food' do
    it 'looks up a food tuple by id and returns an array with the food information' do
      Restaurant.orm.create_food("hamburger", 10,"entree")
      expect(Restaurant.orm.get_food(1)).to be_a(Array)
    end
  end

  describe '#remove_food' do
    it 'removes a tuple from the food table and returns true' do
      Restaurant.orm.create_food("hamburger", 10, "entree")
      Restaurant.orm.remove_food(1)
      expect(Restaurant.orm.get_food(1)).to be_nil
    end
  end

  describe '#list_all_food' do
    it 'retrieves all information from the food table and returns as an array of arrays' do
      Restaurant.orm.create_food("hamburger", 10, "entree")
      Restaurant.orm.create_food("burrito", 8, "entree")
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

      Restaurant.orm.create_food("hamburger", 10, "entree")

      expect(Restaurant.orm.add_food_item(1,1,2)).to eq(true)
    end

    it 'updates a food item by id, with a specified quantity to a shopping cart with given id and returns true' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "entree")

      Restaurant.orm.add_food_item(1,1,2)

      expect(Restaurant.orm.get_food_quantity_from_shopping_cart(1,1)).to eq(2)

      Restaurant.orm.add_food_item(1,1,1)

      expect(Restaurant.orm.get_food_quantity_from_shopping_cart(1,1)).to eq(3)
    end
  end

  describe 'get_food_quantity_from_shopping_cart' do
    it 'given the shopping cart id and food id, returns the food id and quantity' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "entree")

      Restaurant.orm.add_food_item(1,1,2)

      expect(Restaurant.orm.get_food_quantity_from_shopping_cart(1,1)).to eq(2)
    end

    xit 'returns false if no food matching the food is is in the shopping cart' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      expect(Restaurant.orm.get_food_quantity_from_shopping_cart(1,1)).to eq(0)
    end
  end

  describe '#remove_food_item' do
    xit 'removes a food item by id to a shopping cart with given id' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "entree")

      Restaurant.orm.add_food_item(1,1,2)

      Restaurant.orm.remove_food_item(1,1)

      expect(Restaurant.orm.get_food_quantity_from_shopping_cart(1,1)).to eq(0)
    end
  end

  describe '#list_items_in_shopping_cart' do
    it 'retrieves all information from the shopping_cart, given the id, returns as an array of arrays with food entity information' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "entree")
      Restaurant.orm.add_food_item(1,1,2)

      expect(Restaurant.orm.list_items_in_shopping_cart(1).length).to eq(1)
    end

    it 'returns an empty array when a food item is removed from the shopping cart' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "entree")
      Restaurant.orm.add_food_item(1,1,2)
      Restaurant.orm.remove_food_item(1,1)

      expect(Restaurant.orm.list_items_in_shopping_cart(1).length).to eq(0)
    end
  end

  describe '#shopping_cart_item_prices' do
    it 'retrieves the prices for all items in a shopping_cart and returns as an array of prices' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "entree")
      Restaurant.orm.create_food("burrito", 8, "entree")

      Restaurant.orm.add_food_item(1,1,2)
      Restaurant.orm.add_food_item(1,2,1)

      expect(Restaurant.orm.shopping_cart_item_prices(1).length).to eq(2)
    end
  end

  describe '#decrease_quantity_of_item' do
    xit 'checks if the food item exists in the shopping cart' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      expect(Restaurant.orm.decrease_quantity_of_item(1,1,2)).to eq(false)
    end

    xit 'updates the quantity of a food item in the shopping cart' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "entree")

      Restaurant.orm.add_food_item(1,1,4)

      Restaurant.orm.decrease_quantity_of_item(1,1,2)
      expect(Restaurant.orm.list_items_in_shopping_cart(1)[0][4]).to eq(2)
    end

    xit 'does not allow the quantity of food items in a shopping cart to go negative' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "entree")

      Restaurant.orm.add_food_item(1,1,4)

      expect(Restaurant.orm.decrease_quantity_of_item(1,1,5)).to eq(false)
    end

    xit 'removes an item from the shopping cart when the quantity is zero' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_shopping_cart(1)

      Restaurant.orm.create_food("hamburger", 10, "entree")

      Restaurant.orm.add_food_item(1,1,4)

      Restaurant.orm.decrease_quantity_of_item(1,1,4)

      expect(Restaurant.orm.get_food_from_shopping_cart(1,1)).to eq(false)
    end
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

  describe '#add_food_to_menu' do
    it 'adds a food item to the menu given a menu_id and food_id' do
      Restaurant.orm.add_menu("lunch")

      Restaurant.orm.create_food("hamburger", 10, "entree")

      expect(Restaurant.orm.add_food_to_menu(1,1)).to be_a(Array)
    end
  end

#### ORDER CLASS ####
  describe '#add_order' do
    it 'creates a new order and returns an array with order information' do
      Restaurant.orm.create_customer("Benny")
      expect(Restaurant.orm.add_order(1)).to be_a(Array)
    end
  end

  describe '#get_order' do
    it 'retrieves an order, given an id, and returns an array with order information' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_order(1)

      expect(Restaurant.orm.get_order(1)).to be_a(Array)
      expect(Restaurant.orm.get_order(1).length).to eq(4)
    end
  end

  describe '#list_orders' do
    it 'lists all orders and returns an array of arrays with order information' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.create_customer("Caitlin")

      Restaurant.orm.add_order(1)
      Restaurant.orm.add_order(2)

      expect(Restaurant.orm.list_orders.length).to eq(2)
    end
  end

  describe '#submit_order' do
    xit 'submits all food items and quantities from the shopping_cart to the order' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.create_food("hamburger", 10, "entree")
      Restaurant.orm.add_shopping_cart(1)
      Restaurant.orm.add_food_item(1,1,4)

      Restaurant.orm.add_order(1)

      Restaurant.orm.submit_order(1,1)

      expect(Restaurant.orm.list_items_in_order[0][0]).to eq(1)
    end
  end

  describe '#list_items_in_order' do
    xit 'returns an array of arrays with food information for a specific order given an order id' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_order(1)

    end
  end

  describe '#mark_complete' do
    it 'updates the status of an order to closed given an order id' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_order(1)

      expect(Restaurant.orm.mark_complete(1)).to eq(true)
    end
  end

  describe '#list_open_orders' do
    it 'lists all orders with an open status and returns an array of arrays with order information' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.create_customer("Caitlin")

      Restaurant.orm.add_order(1)
      Restaurant.orm.add_order(2)

      Restaurant.orm.mark_complete(1)

      expect(Restaurant.orm.list_open_orders.length).to eq(1)
    end
  end

  describe '#list_closed_orders' do
    it 'lists all orders with a closed status and returns an array of arrays with order information' do
      Restaurant.orm.create_customer("Benny")
      Restaurant.orm.add_order(1)

      Restaurant.orm.mark_complete(1)

      expect(Restaurant.orm.list_closed_orders.length).to eq(1)
    end
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
