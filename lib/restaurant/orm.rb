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
        id SERIAL,
        customer_id INTEGER REFERENCES customers(id),
        PRIMARY KEY (id),
        creation_time TIMESTAMP,
        status TEXT
        );
      CREATE TABLE IF NOT EXISTS food(
        id SERIAL,
        PRIMARY KEY (id),
        name TEXT,
        price INTEGER,
        type_of_item TEXT
        );
      CREATE TABLE IF NOT EXISTS orders_food(
        order_id INTEGER REFERENCES orders(id),
        item_id INTEGER REFERENCES food(id),
        item_quantity INTEGER
        );
      CREATE TABLE IF NOT EXISTS shopping_cart(
        id SERIAL,
        customer_id INTEGER REFERENCES customers(id),
        PRIMARY KEY (id)
        );
      CREATE TABLE IF NOT EXISTS shopping_cart_food(
        SCID INTEGER REFERENCES shopping_cart(id),
        item_id INTEGER REFERENCES food(id),
        item_quantity INTEGER
        );
       CREATE TABLE IF NOT EXISTS menus(
        id SERIAL,
        PRIMARY KEY (id),
        name TEXT
        );
       CREATE TABLE IF NOT EXISTS menus_food(
        menu_id INTEGER REFERENCES menus(id),
        food_id INTEGER REFERENCES food(id)
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
        DROP TABLE IF EXISTS orders_food CASCADE;
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

    def get_food(id)
      command = <<-SQL
      SELECT * FROM food
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def remove_food(id)
      command = <<-SQL
      DELETE
      FROM food
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command)
    end

    def list_all_food
      command = <<-SQL
      SELECT * FROM food;
      SQL

      @db_adaptor.exec(command).values
    end

  # ###############
  # #Customer Class
  # ###############
    def get_customer(id)
      command = <<-SQL
      SELECT * FROM customers
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command).values[0] #returns [id,name]
    end

    def create_customer(name)
      command = <<-SQL
      INSERT INTO customers (name)
      VALUES ('#{name}')
      RETURNING *;
      SQL

      @db_adaptor.exec(command).values[0] #returns [id,name]
    end
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

    def get_shopping_cart(scid)
      command = <<-SQL
      SELECT *
      FROM shopping_cart
      WHERE id = '#{scid}';
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def add_food_item (scid, fid, quantity)
      #SELECT to see if item is there
      #if not then I would insert
      #else, increase the quantity
      #remove increase quantity
      command = <<-SQL
      INSERT INTO shopping_cart_food (SCID, item_id, item_quantity)
      VALUES ('#{scid}', '#{fid}', '#{quantity}');
      SQL
#RETURNING* in order to show the deleted item

      @db_adaptor.exec(command)
      true
    end

    def remove_food_item (scid, fid)
      command = <<-SQL
      DELETE
      FROM shopping_cart_food
      WHERE SCID = '#{scid}' AND item_id = '#{fid}';
      SQL

      @db_adaptor.exec(command)
#RETURNING* in order to return the deleted item
      true
    end

    def list_items_in_shopping_cart(scid)
      command = <<-SQL
      SELECT f.id, f.name, f.price, , f.type_of_item, scf.item_quantity
      FROM shopping_cart_food AS scf
      JOIN food AS f
      ON scf.item_id = f.id
      WHERE scf.scid= '#{scid}';
      SQL

      #code works but does not allocate the quantity of the food

      @db_adaptor.exec(command).values
    end

    def shopping_cart_item_prices(scid)
      command = <<-SQL
      SELECT f.price, scf.item_quantity
      FROM shopping_cart_food AS scf
      JOIN food AS f
      ON scf.item_id = f.id
      WHERE scf.scid = '#{scid}';
      SQL

      @db_adaptor.exec(command).values
      #returns an array of prices and quantity of each item
    end


      def increase_quantity_of_item(scid, fid, quantity)
      command = <<-SQL
      UPDATE shopping_cart_food
      SET quantity = quantity + '#{quantity}'
      WHERE SCID = '#{scid}' AND fid = '#{fid}'
      SQL
      end

      # # def decrease_quantity_of_item(fid)
      #0 and negative numbers at 0 remove row, negative raise an error
      # # end

  # # ###########
  # # #Menu Class
  # # ###########
    def add_menu(name)
      command = <<-SQL
      INSERT INTO menus (name)
      VALUES ('#{name}')
      RETURNING *;
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def get_menu(id)
      command = <<-SQL
      SELECT * FROM menus
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def add_menus_food(mid, fid)
      command = <<-SQL
      INSERT INTO menus_food (menu_id, food_id)
      VALUES ('#{mid}', '#{fid}');
      SQL
      @db_adaptor.exec(command)
    end

    def add_food_to_menu(mid,fid)
      Restaurant.orm.add_menus_food(mid,fid)

      command = <<-SQL
        SELECT f.id, f.name, f.price, f.type_of_item
        FROM menus_food AS mf
        JOIN Food AS f
        ON mf.food_id = f.id
        WHERE mf.menu_id = '#{mid}' AND f.id = '#{fid}';
      SQL

      @db_adaptor.exec(command).values[0]
    end

  # ############
  # #Order Class
  # ############

    def add_order(customer_id)
      status = "open"
      creation_time = Time.now
      command = <<-SQL
      INSERT INTO Orders (customer_id, creation_time, status)
      VALUES ('#{customer_id}', '#{creation_time}', '#{status}')
      RETURNING *;
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def get_order(id)
      command = <<-SQL
      SELECT * FROM Orders
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def list_orders
      command = <<-SQL
      SELECT * FROM ORDERS
      SQL

      @db_adaptor.exec(command).values
    end

    def list_items_in_order(order_id)
      command = <<-SQL
      SELECT f.id, f.name, f.price, f.type_of_item
      FROM orders_food AS of
      JOIN food AS f
      ON of.item_id = f.id
      WHERE of.order_id= '#{order_id}';
      SQL

      @db_adaptor.exec(command).values
    end
    #shopping cart order join table

    def list_open_orders
      command = <<-SQL
      SELECT *
      FROM orders
      WHERE status = 'open';
      SQL

      @db_adaptor.exec(command).values
    end

    def list_closed_orders
      command = <<-SQL
      SELECT *
      FROM orders
      WHERE status = 'closed';
      SQL

      @db_adaptor.exec(command).values
    end

    def mark_complete(order_id)
      command = <<-SQL
      UPDATE orders
      SET status = 'closed'
      WHERE id = '#{order_id}';
      SQL

      @db_adaptor.exec(command)

      true
    end

  ############
  #Staff Class
  ############
    def create_staff(name)
      command = <<-SQL
      INSERT INTO staff(name)
      VALUES ('#{name}')
      RETURNING *;
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def get_staff(id)
      command = <<-SQL
      SELECT * FROM staff
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command).values[0]
    end
  end

  def self.orm
   @__orm_instance ||= Orm.new
  end

end
