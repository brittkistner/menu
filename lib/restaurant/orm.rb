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
      CREATE TABLE IF NOT EXISTS shopping_cart(
        id SERIAL,
        customer_id INTEGER REFERENCES customers(id),
        PRIMARY KEY (id)
        );
      CREATE TABLE IF NOT EXISTS shopping_cart_food(
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
        DROP TABLE IF EXISTS food CASCADE;
        DROP TABLE IF EXISTS orders_foods CASCADE;
        DROP TABLE IF EXISTS shopping_cart CASCADE;
        DROP TABLE IF EXISTS shopping_cart_food CASCADE;
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
      INSERT INTO food (name, price, type_of_item)
      VALUES ('#{name}', '#{price}','#{type_of_item}')
      RETURNING *;
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def get_food(id) # * read_food_by_id(id) -> dict (hash)
      command = <<-SQL
      SELECT * FROM food
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def remove_food(id) #delete_food
      command = <<-SQL
      DELETE
      FROM food
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command)
    end

    def list_all_food # * read_foods -> array(dict)
      command = <<-SQL
      SELECT * FROM food;
      SQL

      @db_adaptor.exec(command).values
    end

  # ###############
  # #Customer Class
  # ###############

# * read_customer_shopping_carts(id) -> array(dict)
    def get_customer(id) # * read_customer(id) -> dict
      command = <<-SQL
      SELECT * FROM customers
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command).values[0] #returns [id,name]
    end

    def create_customer(name) # * create_customer(name) -> integer (id)
      command = <<-SQL
      INSERT INTO customers (name)
      VALUES ('#{name}')
      RETURNING *;
      SQL

      @db_adaptor.exec(command).values[0] #returns [id,name]
    end

    # * update_customer_add_shopping_cart(id) -> integer (id) LOOK BELOW TODO

    # * read_customer_shopping_carts(id) -> array(dict) TODO

  # #####################
  # #Shopping Cart Class
  # #####################

    def add_shopping_cart(customer_id)
      command = <<-SQL
      INSERT INTO shopping_cart (customer_id)
      VALUES ('#{customer_id}')
      RETURNING *;
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def get_food_quantity_from_shopping_cart(scid, fid) # * read_shopping_cart_food_quantity(shopping_cart_id, food_id) -> integer (quantity)
      check_for_food = <<-SQL
      SELECT item_quantity
      FROM shopping_cart_food AS scf
      WHERE item_id = '#{fid}'
      SQL

      if @db_adaptor.exec(check_for_food).values == []
        0
      else
        @db_adaptor.exec(check_for_food).values[0][0].to_i
      end

    end

    def add_food_item (scid, fid, quantity)  # * update_shopping_cart_add_food(shopping_cart_id, food_id, quantity) -> boolean
      check_for_food = <<-SQL
      SELECT item_id
      FROM shopping_cart_food AS scf
      WHERE item_id = '#{fid}' AND SCID = '#{scid}'
      SQL
      #Returns the item

      update_food = <<-SQL
      UPDATE shopping_cart_food
      SET item_quantity = item_quantity + '#{quantity}'
      WHERE SCID = '#{scid}' AND item_id = '#{fid}'
      SQL

      add_food = <<-SQL
      INSERT INTO shopping_cart_food (SCID, item_id, item_quantity)
      VALUES ('#{scid}', '#{fid}', '#{quantity}');
      SQL

      if @db_adaptor.exec(check_for_food).values == []
        @db_adaptor.exec(add_food)
        true
      else
        @db_adaptor.exec(update_food)
        true
      end

    end

    # def remove_food_item (scid, fid)
    #   command = <<-SQL
    #   DELETE
    #   FROM shopping_cart_food
    #   WHERE SCID = '#{scid}' AND item_id = '#{fid}';
    #   SQL

    #   @db_adaptor.exec(command)

    #   true
    # end

    def decrease_quantity_of_item(scid, fid, quantity) # * update_shopping_cart_remove_food(shopping_cart_id, food_id, quantity) -> boolean

      update_food = <<-SQL
      UPDATE shopping_cart_food
      SET item_quantity = item_quantity - '#{quantity}'
      WHERE SCID = '#{scid}' AND item_id = '#{fid}'
      SQL

      if get_food_quantity_from_shopping_cart(scid, fid).values < quantity
        return false
      else
        db_quantity = @db_adaptor.exec(return_quantity).values[0][0]
        if db_quantity - quantity == 0
          Restaurant.orm.remove_food_item(scid,fid)
        elsif db_quantity - quantity < 0
          false
        else
          @db_adaptor.exec(update_food)
          true
        end
      end

    end

    def list_items_in_shopping_cart(scid) # * read_shopping_cart_foods(id) -> array(dict) (food_id, quantity)
      command = <<-SQL
      SELECT f.id, f.name, f.price, f.type_of_item, scf.item_quantity
      FROM shopping_cart_food AS scf
      JOIN food AS f
      ON scf.item_id = f.id
      WHERE scf.scid= '#{scid}';
      SQL

      @db_adaptor.exec(command).values
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
