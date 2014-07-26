require 'pg'
require 'pry-byebug'
require 'time'


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
        PRIMARY KEY (id),
        customer_id INTEGER REFERENCES customers(id),
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
        order_id INTEGER REFERENCES orders(id),
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
        SCID INTEGER REFERENCES shopping_carts(id),
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
        DROP TABLE IF EXISTS menus_foods CASCADE;
        DROP TABLE IF EXISTS staff CASCADE;
      SQL

      @db_adaptor.exec(command)
    end

    def reset_tables
      drop_tables
      create_tables
    end

  #   ##################
  #   ####Food Class####
  #   ##################
    def create_food(name, price, type_of_item)
      command = <<-SQL
      INSERT INTO foods (name, price, type_of_item)
      VALUES ('#{name}', '#{price}','#{type_of_item}')
      RETURNING id;
      SQL

      table = @db_adaptor.exec(command).values

      if table.empty?
        return nil
      else
        row = table[0]
        {id: Integer(row[0])}
      end
    end

    def read_food_by_id(id)
      command = <<-SQL
      SELECT name, price, type_of_item
      FROM foods
      WHERE id = '#{id}';
      SQL

      table = @db_adaptor.exec(command).values

      if table.empty?
        return nil
      else
        row = table[0]
        {name: row[0], price: Integer(row[1]), type_of_item: row[2]}
      end
    end

    def delete_food(id)
      command = <<-SQL
      DELETE
      FROM foods
      WHERE id = '#{id}';
      SQL

      @db_adaptor.exec(command)

      true
    end

    def read_foods
      command = <<-SQL
      SELECT id, name, price, type_of_item
      FROM foods;
      SQL

      table = @db_adaptor.exec(command).values

      if table.empty?
        return nil
      else
        list = []

        table.each do |x|
          list << {id: Integer(x[0]), name: x[1], price: Integer(x[2]), type_of_item: x[3]}
        end
      end

      list

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

      table = @db_adaptor.exec(command).values
      if table.empty?
        return nil
      else
        row = table[0]
        {id: Integer(row[0])}
      end

    end

    def read_customer(id)
      command = <<-SQL
      SELECT name
      FROM customers
      WHERE id = '#{id}';
      SQL

      table = @db_adaptor.exec(command).values

      if table.empty?
        return nil
      else
        row = table[0]
        {name: row[0]}
      end
    end

    def update_customer_add_shopping_cart(id)
      command = <<-SQL
      INSERT INTO shopping_carts (customer_id)
      VALUES ('#{id}')
      RETURNING id;
      SQL

      table = @db_adaptor.exec(command).values

      if table.empty?
        return nil
      else
        row = table[0]
        {id: Integer(row[0])}
      end
    end

    def read_customer_shopping_carts(id)
      command = <<-SQL
      SELECT id, customer_id
      FROM shopping_carts;
      SQL

      table = @db_adaptor.exec(command).values

      if table.empty?
        return nil
      else
        list = []

        table.each do |x|
          list << {id: Integer(x[0]), customer_id: Integer(x[1])}
        end
      end

      list
    end

  # #####################
  # #Shopping Cart Class
  # #####################

    def read_shopping_cart_food_quantity(shopping_cart_id, food_id)
      check_for_food = <<-SQL
      SELECT food_quantity
      FROM shopping_cart_foods
      WHERE food_id = '#{food_id}' AND SCID = '#{shopping_cart_id}';
      SQL

      table = @db_adaptor.exec(check_for_food).values

      if table.empty?
        return 0
      else
        row = table[0]
        {food_quantity: Integer(row[0])}
      end
    end

    def update_shopping_cart_add_food(shopping_cart_id, food_id, quantity)
      check_for_food = <<-SQL
      SELECT item_id
      FROM shopping_cart_foods AS scf
      WHERE food_id = '#{food_id}' AND SCID = '#{shopping_cart_id}';
      SQL

      update_food = <<-SQL
      UPDATE shopping_cart_foods
      SET food_quantity = food_quantity + '#{quantity}'
      WHERE SCID = '#{shopping_cart_id}' AND food_id = '#{food_id}';
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
      WHERE SCID = '#{shopping_cart_id}' AND food_id = '#{food_id}';
      SQL

      update_food = <<-SQL
      UPDATE shopping_cart_foods
      SET food_quantity = food_quantity - '#{quantity}'
      WHERE SCID = '#{shopping_cart_id}' AND food_id = '#{food_id}';
      SQL

      current_quantity = read_shopping_cart_food_quantity(shopping_cart_id, food_id)[:food_quantity]
      if current_quantity == 0
        return false
      elsif current_quantity - quantity == 0
        @db_adaptor.exec(delete_food)
        true
      elsif current_quantity - quantity < 0
        @db_adaptor.exec(delete_food)
        true
      else
        @db_adaptor.exec(update_food)
        true
      end
    end

    def read_shopping_cart_foods(id)
      command = <<-SQL
      SELECT food_id, food_quantity
      FROM shopping_cart_foods
      WHERE SCID = '#{id}';
      SQL

      table = @db_adaptor.exec(command).values #[[food_id1, quantity1],[food_id2, quantity2]]

      if table.empty?
        return nil
      else
        list = []

        table.each do |x|
          list << {food_id: Integer(x[0]), food_quantity: Integer(x[1])}
        end
      end

      list
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

      table = @db_adaptor.exec(command).values

      if table.empty?
        return nil
      else
        row = table[0]
        {id: Integer(row[0])}
      end
    end

    def read_menus
      command = <<-SQL
      SELECT id, name
      FROM menus;
      SQL

      table = @db_adaptor.exec(command).values

      if table.empty?
        return nil
      else
        result = []

        table.each do |x|
          result << {id: Integer(x[0]), name: x[1]}
        end

        result
      end

    end

    def add_menus_foods(menu_id, food_id)
      command = <<-SQL
      INSERT INTO menus_foods (menu_id, food_id)
      VALUES ('#{menu_id}', '#{food_id}');
      SQL
      @db_adaptor.exec(command)

      true
    end

    def read_menu_foods(menu_id)
      command = <<-SQL
      SELECT food_id
      FROM menus_foods
      WHERE menu_id = '#{menu_id}';
      SQL

      table = @db_adaptor.exec(command).values #[['food1'],['food2']]
      if table.empty?
        return nil
      else
        result = []

        table.each do |x|
          result << {id: Integer(x[0])}
        end

        result
      end
    end

    # ############
    # #Order Class
    # ############

    # def create_order_delete_shopping_cart(shopping_cart_id)
    #   creation_time = Time.now

    #   create_order = <<-SQL
    #   INSERT INTO orders (customer_id, creation_time, status)
    #   SELECT customer_id, '#{creation_time}', 'open'
    #   FROM shopping_carts
    #   WHERE id = '#{shopping_cart_id}'
    #   RETURNING id;
    #   SQL

    #   order_id = @db_adaptor.exec(create_order).values[0][0].to_i

    #   create_orders_foods = <<-SQL
    #   INSERT INTO orders_foods
    #   SELECT '#{order_id}', food_id, food_quantity
    #   FROM shopping_cart_foods
    #   WHERE SCID = '#{shopping_cart_id}';
    #   SQL

    #   @db_adaptor.exec(create_orders_foods)

    #   delete_shopping_cart_foods = <<-SQL
    #   DELETE
    #   FROM shopping_cart_foods
    #   WHERE SCID = '#{shopping_cart_id}';
    #   SQL

    #   delete_shopping_carts= <<-SQL
    #   DELETE
    #   FROM shopping_carts
    #   WHERE id = '#{shopping_cart_id}';
    #   SQL

    #   @db_adaptor.exec(delete_shopping_cart_foods)
    #   @db_adaptor.exec(delete_shopping_carts)

    #   read_order= <<-SQL
    #   SELECT customer_id, creation_time
    #   FROM orders
    #   WHERE id = '#{order_id}';
    #   SQL

    #   row = @db_adaptor.exec(read_order).values[0]

    #   {id: order_id, customer_id: Integer(row[0]), creation_time: DateTime.parse(row[1]), status: "open" }

    #   # order_id
    # end

    # def read_orders_by_status
    #   command = <<-SQL
    #   SELECT id,status
    #   FROM orders;
    #   SQL

    #   table = @db_adaptor.exec(command).values

    #   if table.empty?
    #     return nil
    #   else
    #     result = []

    #     table.each do |x|
    #       result << {order_id: Integer(x[0]), status: x[1]}
    #     end

    #     result
    #   end
    # end

    # def update_order_status(id,status)
    #   command = <<-SQL
    #   UPDATE orders
    #   SET status = '#{status}'
    #   WHERE id = '#{id}';
    #   SQL

    #   @db_adaptor.exec(command)

    #   true
    # end

    # def read_order_foods(id) #(food_id, quantity)
    #   command = <<-SQL
    #   SELECT food_id, food_quantity
    #   FROM orders_foods
    #   WHERE order_id = '#{id}';
    #   SQL

    #   table = @db_adaptor.exec(command).values
    #   if table.empty?
    #     return nil
    #   else
    #     result = []

    #     table.each do |x|
    #       result << {food_id: Integer(x[0]), food_quantity: Integer(x[1])}
    #     end

    #     result
    #   end
    # end

    ############
    #Staff Class
    ############
    def create_staff(name)
      command = <<-SQL
      INSERT INTO staff(name)
      VALUES ('#{name}')
      RETURNING id;
      SQL

      table = @db_adaptor.exec(command).values

      if table.empty?
        return nil
      else
        row = table[0]
        hash = {id: Integer(row[0])}
      end
    end
  end

  def self.orm
   @__orm_instance ||= Orm.new
  end
end




