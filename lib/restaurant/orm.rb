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
        category TEXT,
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

  #Food Class
    def create_food(name, price, category,type_of_item)
      command = <<-SQL
      INSERT INTO food (name, price, category, type_of_item)
      VALUES ('#{name}', '#{price}', '#{category}', '#{type_of_item}')
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

    def remove_food(id) #rescue??
      <<-SQL
      DELETE * FROM food
      WHERE id = '#{id}';
      SQL

      true
    end

    def list_all_food
      command = <<-SQL
      SELECT * FROM food;
      SQL

      @db_adaptor.exec(command).values
    end

  ###############
  #Customer Class
  ###############
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

      #customer id?

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
      SELECT f.id, f.name, f.price, f.category, f.type_of_item, scf.item_quantity
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


      # # def increase_quantity_of_item(fid)
      # # end

      # # def decrease_quantity_of_item(fid)
      # # end

  # ###########
  # #Menu Class
  # ###########
    def get_menu(id)
      command <<-SQL
      SELECT * FROM Menus
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command).values
    end

    def add_menu(name)
      command <<-SQL
      INSERT INTO Menus (name)
      VALUES ('#{name}')
      RETURNING *;
      SQL

      @db_adaptor.exec(command).values[0]
    end

    def get_food_items(mid,category)
      command = <<-SQL
        SELECT f.id, f.name, f.price, f.category, f.type_of_item
        FROM MenusFood AS mf
        JOIN Food AS f
        ON mf.food_id = f.id
        WHERE mf.menu_id = '#{mid}' AND f.category = '#{category}'
      SQL

      @db_adaptor.exec(command).values
    end

    def get_beverages(mid, category)
      command = <<-SQL
      SELECT f.id, f.name, f.price, f.category, f.type_of_item
      FROM MenusFood AS mf
      JOIN Food AS f
      ON mf.food_id = f.id
      WHERE mf.menu_id = '#{mid}' AND f.category = '#{category}' AND f.type_of_item = 'beverage'
      SQL

      @db_adaptor.exec(command).values
    end

  # ############
  # #Order Class
  # ############
  #   def get_order(id)
  #     command <<-SQL
  #     SELECT * FROM Orders
  #     WHERE id = '#{id}';
  #     SQL

  #     @db_adaptor.exec(command).values
  #   end

  #   def add_order(customer_id)
  #     status = "open"
  #     creation_time = Time.now
  #     command <<-SQL
  #     INSERT INTO Orders (customer_id, creation_time, status)
  #     VALUES ('#{customer_id}', '#{creation_time}', '#{status}')
  #     RETURNING *;
  #     SQL

  #     @db_adaptor.exec(command).values[0]
  #   end

  #   def list_orders
  #     command = <<-SQL
  #     SELECT * FROM ORDERS
  #     SQL

  #     @db_adaptor.exec(command).values
  #   end

  #   def list_items_in_order(order_id)
  #     command = <<-SQL
  #     SELECT f.id, f.name, f.price, f.category, f.type_of_item
  #     FROM OrdersFood AS of
  #     JOIN Food AS f
  #     ON of.item_id = f.id
  #     WHERE of.order_id= '#{order_id}';
  #     SQL

  #     @db_adaptor.exec(command).values
  #   end

  #   def list_open_orders
  #     command = <<-SQL
  #     SELECT *
  #     FROM Orders
  #     WHERE status = "open";
  #     SQL

  #     @db_adaptor.exec(command).values
  #   end

  #   def list_closed_orders
  #     command = <<-SQL
  #     SELECT *
  #     FROM Orders
  #     WHERE status = "closed";
  #     SQL

  #     @db_adaptor.exec(command).values
  #   end

  #   def mark_complete(order_id)
  #     <<-SQL
  #     UPDATE Orders
  #     SET status = 'closed'
  #     WHERE id = '#{order_id}';
  #     SQL

  #     true
  #   end

  # ############
  # #Staff Class
  # ############

  #   def get_staff(id)
  #     command <<-SQL
  #     SELECT * FROM Staff
  #     WHERE id = '#{id}';
  #     SQL

  #     @db_adaptor.exec(command).values
  #   end

  #   def create_staff(name)
  #     command <<-SQL
  #     INSERT INTO Staff(name)
  #     VALUES ('#{name}')
  #     RETURNING *;
  #     SQL

  #     @db_adaptor.exec(command).values[0]
  #   end
  end

  def self.orm
   @__orm_instance ||= Orm.new
  end

end
