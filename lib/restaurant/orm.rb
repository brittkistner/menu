require 'pg'
require 'pry-byebug'

module Restaurant
  class Orm
    def initialize
      @db_adaptor = PG.connect(host: 'localhost', dbname: 'menu-db')
    end

    def create_tables
      command = <<-SQL
      CREATE TABLE IF NOT EXISTS customers(
        id SERIAL,
        PRIMARY KEY (id),
        name TEXT
        );
      CREATE TABLE IF NOT EXISTS orders(
        id INTEGER REFERENCES orders_food(order_id),
        customer_id INTEGER REFERENCES customers(id),
        PRIMARY KEY (id),
        creation_time TIMESTAMP,
        status TEXT
        );
      CREATE TABLE IF NOT EXISTS foods(
        id SERIAL,
        PRIMARY KEY (id),
        name TEXT,
        price INTEGER,
        type_of_item TEXT
        );
      CREATE TABLE IF NOT EXISTS orders_foods(
        order_id SERIAL,
        PRIMARY KEY (order_id),
        food_id INTEGER REFERENCES foods(id),
        food_quantity INTEGER
        );
      CREATE TABLE IF NOT EXISTS shopping_carts(
        id SERIAL,
        customer_id INTEGER REFERENCES customers(id),
        PRIMARY KEY (id)
        );
      CREATE TABLE IF NOT EXISTS shopping_cart_foods(
        SCID INTEGER REFERENCES shopping_cart(id),
        food_id INTEGER REFERENCES foods(id),
        food_quantity INTEGER
        );
       CREATE TABLE IF NOT EXISTS menus(
        id SERIAL,
        PRIMARY KEY (id),
        name TEXT
        );
       CREATE TABLE IF NOT EXISTS menus_foods(
        menu_id INTEGER REFERENCES menus(id),
        food_id INTEGER REFERENCES foods(id)
        );
       CREATE TABLE IF NOT EXISTS staff(
        id SERIAL,
        PRIMARY KEY(id),
        name TEXT
        );
       SQL

      @db_adaptor.exec(command)
    end

    def drop_tables
      command = <<-SQL
        DROP TABLE IF EXISTS orders CASCADE;
        DROP TABLE IF EXISTS customers CASCADE;
        DROP TABLE IF EXISTS foods CASCADE;
        DROP TABLE IF EXISTS orders_foods CASCADE;
        DROP TABLE IF EXISTS shopping_carts CASCADE;
        DROP TABLE IF EXISTS shopping_cart_foods CASCADE;
        DROP TABLE IF EXISTS menus CASCADE;
        DROP TABLE IF EXISTS menus_food CASCADE;
        DROP TABLE IF EXISTS staff CASCADE;
      SQL

      @db_adaptor.exec(command)
    end

    def reset_tables
      drop_tables
      create_tables
    end

  ##################
  ####Food Class####
  ##################
    def create_food(name, price, type_of_item)
      command = <<-SQL
      INSERT INTO foods (name, price, type_of_item)
      VALUES ('#{name}', '#{price}','#{type_of_item}')
      RETURNING *;
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def read_food_by_id(id)
      command = <<-SQL
      SELECT * FROM foods
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def delete_food(id)
      command = <<-SQL
      DELETE
      FROM foods
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command)
    end

    def read_foods
      command = <<-SQL
      SELECT * FROM foods;
      SQL

      @db_adaptor.exec(command).values
    end

  # ###############
  # #Customer Class
  # ###############

    def create_customer(name)
      command = <<-SQL
      INSERT INTO customers (name)
      VALUES ('#{name}')
      RETURNING id;
      SQL

      @db_adaptor.exec(command).values[0] #returns ['id']
    end

    def read_customer(id)
      command = <<-SQL
      SELECT * FROM customers
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command).values[0] #returns ['id',name]
    end

    def update_customer_add_shopping_cart(id)
      command = <<-SQL
      INSERT INTO shopping_carts (customer_id)
      VALUES ('#{id}')
      RETURNING id;
      SQL

      @db_adaptor.exec(command).values[0][0].to_i
    end

    def read_customer_shopping_carts(id)
      command = <<-SQL
      SELECT * FROM shopping_carts;
      SQL

      @db_adaptor.exec(command).values #returns an array with id, customer_id
    end

  # #####################
  # #Shopping Cart Class
  # #####################

    def read_shopping_cart_food_quantity(shopping_cart_id, food_id)
      check_for_food = <<-SQL
      SELECT food_quantity
      FROM shopping_cart_foods
      WHERE item_id = '#{food_id}' AND SCID = '#{shopping_cart_id';
      SQL

      if @db_adaptor.exec(check_for_food).values == []
        0
      else
        @db_adaptor.exec(check_for_food).values[0][0].to_i #returns a number
      end

    end

    def update_shopping_cart_add_food(shopping_cart_id, food_id, quantity)
      check_for_food = <<-SQL
      SELECT item_id
      FROM shopping_cart_foods AS scf
      WHERE item_id = '#{fid}' AND SCID = '#{scid}';
      SQL
      #Returns the item

      update_food = <<-SQL
      UPDATE shopping_cart_foods
      SET food_quantity = food_quantity + '#{quantity}'
      WHERE SCID = '#{shopping_cart_id}' AND food_id = '#{fid}';
      SQL

      add_food = <<-SQL
      INSERT INTO shopping_cart_foods (SCID, food_id, food_quantity)
      VALUES ('#{shopping_cart_id}', '#{food_id}', '#{quantity}');
      SQL

      if read_shopping_cart_food_quantity(shopping_cart_id, food_id) == 0
        @db_adaptor.exec(add_food)
        true
      else
        @db_adaptor.exec(update_food)
        true
      end
    end

    def update_shopping_cart_remove_food(shopping_cart_id, food_id, quantity)
      delete_food = <<-SQL
      DELETE
      FROM shopping_cart_foods
      WHERE SCID = '#{scid}' AND item_id = '#{fid}';
      SQL

      update_food = <<-SQL
      UPDATE shopping_cart_foods
      SET item_quantity = item_quantity - '#{quantity}'
      WHERE SCID = '#{scid}' AND item_id = '#{fid}';
      SQL

      current_quantity = read_shopping_cart_food_quantity(shopping_cart_id, food_id)
      if current_quantity == 0
        return false
      elsif current_quantity - quantity == 0
        @db_quantity.exec(delete_food)
        true
      elsif current_quantity - quantity < 0
        false
      else
        @db_adaptor.exec(update_food)
        true
      end
    end

    def read_shopping_cart_foods(id)
      command = <<-SQL
      SELECT food_id, food_quantity
      FROM shopping_cart_food
      WHERE SCID = '#{id}';
      SQL

      @db_adaptor.exec(command).values #[[food_id1, quantity1],[food_id2, quantity2]]
    end

  # ###########
  # #Menu Class
  # ###########

    def create_menu(name)
      command = <<-SQL
      INSERT INTO menus (name)
      VALUES ('#{name}')
      RETURNING id;
      SQL

      @db_adaptor.exec(command).values[0] #returns ['id']
    end

    def read_menus
      command = <<-SQL
      SELECT * FROM menus;
      SQL

      @db_adaptor.exec(command).values
    end

    def add_menus_food(menu_id, food_id)
      command = <<-SQL
      INSERT INTO menus_food (menu_id, food_id)
      VALUES ('#{menu_id}', '#{food_id}');
      SQL
      @db_adaptor.exec(command)

      true
    end

    def read_menu_foods(menu_id)
      command = <<-SQL
      SELECT food_id
      FROM menus_food
      WHERE menu_id = '#{menu_id}';
      SQL

      @db_adaptor.exec(command).values #[['food1'],['food2']]
    end

  # ############
  # #Order Class
  # ############

    # def add_order(customer_id)
    #   status = "open"
    #   creation_time = Time.now
    #   command = <<-SQL
    #   INSERT INTO Orders (customer_id, creation_time, status)
    #   VALUES ('#{customer_id}', '#{creation_time}', '#{status}')
    #   RETURNING *;
    #   SQL


    def create_order_delete_shopping_cart(shopping_cart_id)
      read_shopping_cart_food_by_items_and_quantity = <<-SQL
      SELECT food_id, food_quantity
      FROM shopping_cart_food
      WHERE SCID = '#{shopping_cart_id}';
      SQL


      create_orders_food = <<-SQL
      INSERT INTO orders_foods(item_id, item_quantity, )
      Values ('#{food_id}', '#{food_quantity}')
      RETURNING order_id;
      SQL

      delete_shopping_cart = <<-SQL
      DELETE
      FROM shopping_cart_food
      WHERE SCID = '#{shopping_cart_id}';
      SQL

      array = @db_adaptor.exec(read_shopping_cart_food_by_items_and_quantity).values

      @db_adaptor.exec(delete_shopping_cart)

      array.each do |x|
        item_id = x[0]
        item_quantity = x[1]
        ##THIS WILL CREATE MULTIPLE ORDERS, DO IT A DIFFERENT WAY (ADD ORDER, change tables)
        @db_adaptor.exec(create_orders_food)
      end
    end

    def read_orders_by_status
      command = <<-SQL
      SELECT id AND status
      FROM orders;
      SQL

      @db_adaptor.exec(command).values #array(dict) (order_id, status)
    end

    def mark_complete(id,status)
      command = <<-SQL
      UPDATE orders
      SET status = '#{status}'
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command)

      true
    end

    def read_orders_foods(id)
      command = <<-SQL
      SELECT food_id, food_quantity
      FROM orders_foods
      WHERE order_id = '#{id}';
      SQL

      @db_adaptor.exec(command).values
    end

  ############
  #Staff Class
  ############
    def create_staff(name)
      command = <<-SQL
      INSERT INTO staff(name)
      VALUES ('#{name}')
      RETURNING id;
      SQL

      @db_adaptor.exec(command).values[0] #['id']
    end

  end

  def self.orm
   @__orm_instance ||= Orm.new
  end

end
