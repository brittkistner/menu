class Restaurant::Orm
  def initialize
    @db_adaptor = PG.connect(host: 'localhost', dbname: 'menu-db')
  end

  def create_tables
    command = <<-SQL
    CREATE TABLE IF NOT EXISTS Orders(
      id SERIAL,
      customer_id INTEGER REFERENCES Customers(id),
      PRIMARY KEY (id),
      creation_time TIMESTAMP
      );
    CREATE TABLE IF NOT EXISTS Food(
      id SERIAL,
      PRIMARY KEY (id),
      name TEXT,
      price INTEGER,
      category TEXT
      );
    CREATE TABLE IF NOT EXISTS Customers(
      id SERIAL,
      PRIMARY KEY (id),
      name TEXT
      );
    CREATE TABLE IF NOT EXISTS OrdersFood(
      order_id INTEGER REFERENCES Orders(id),
      item_id INTEGER REFERENCES Food(id),
      item_quantity INTEGER
      );
    CREATE TABLE IF NOT EXISTS ShoppingCart(
      id = SERIAL,
      customer_id INTEGER REFERENCES Customers(id),
      PRIMARY KEY (id)
      );
    CREATE TABLE IF NOT EXISTS ShoppingCartFood(
      SCID INTEGER REFERENCES ShoppingCart(id),
      item_id INTEGER REFERENCES Food(id),
      item_quantity INTEGER
      );
     CREATE TABLE IF NOT EXISTS Customers(
      id = SERIAL,
      PRIMARY KEY (id)
      );
    SQL

    @db_adaptor.exec(command)

  end

  def drop_tables
    command = <<-SQL
      DROP TABLE IF EXISTS Orders CASCADE;
      DROP TABLE IF EXISTS Food CASCADE;
      DROP TABLE IF EXISTS OrdersFood CASCADE;
      DROP TABLE IF EXISTS ShoppingCart CASCADE;
      DROP TABLE IF EXISTS ShoppingCartFood CASCADE;
    SQL

    @db_adaptor.exec(command)
  end

  def reset_tables
    drop_tables
    create_tables
  end

#Food Class

  def get_food(id)
    command = <<-SQL
    SELECT * FROM Food
    WHERE id = '#{id}';
    SQL

    @db_adaptor.exec(command)
  end

  def create_food(name, price, category)
    command = <<-SQL
    INSERT INTO Food (name, price, category)
    VALUES ('#{name}', '#{price}', '#{category}')
    RETURNING *;
    SQL

    @db_adaptor.exec(command).values[0]
  end

  def remove_food(id) #rescue??
    <<-SQL
    DELETE * FROM Food
    WHERE id = '#{id}';
    SQL

    true
  end

  def list_all_food
    command = <<-SQL
    SELECT * FROM Food;
    SQL

    @db_adaptor.exec(command).values

  end

#Customer Class
  def get_customer(id)
    command = <<-SQL
    SELECT * FROM Customers
    WHERE id = '#{id}';
    SQL

    @db_adaptor.exec(command)
  end

  def create_customer(name)
    command = <<-SQL
    INSERT INTO Customers (name)
    VALUES ('#{name}')
    RETURNING *;
    SQL

    @db_adaptor.exec(command).values[0]
  end

#Shopping Cart Class

def add_shopping_cart(customer_id)
    command = <<-SQL
    INSERT INTO ShoppingCart (customer_id)
    VALUES ('#{customer_id}')
    RETURNING *;
    SQL

    #customer id?

    @db_adaptor.exec(command).values[0]
end

def get_shopping_cart(scid)
  command = <<-SQL
  SELECT *
  FROM ShoppingCart
  WHERE SCID = '#{scid}';
  SQL

  @db_adaptor.exec(command)
end

def add_food_item (scid, fid, quantity)
  <<-SQL
  INSERT INTO ShoppingCartFood (SCID, item_id, item_quantity)
  VALUES ('#{scid}', '#{fid}', '#{quantity}');
  SQL

  true
end

def remove_food_item (scid, fid)
  <<-SQL
  DELETE * FROM ShoppingCartFood
  WHERE SCID = '#{scid}' AND item_id = '#{fid}';
end

def list_items_in_shopping_cart(scid)
  command = <<-SQL
  SELECT f.id, f.name, f.price, f.category
  FROM ShoppingCartFood AS scf
  JOIN Food AS f
  ON scf.item_id = f.id
  WHERE scf.scid= '#{scid}';
  SQL

  @db_adaptor.exec(command).values
end

def shopping_cart_item_prices(scid)
  command = <<-SQL
  SELECT f.price
  FROM ShoppingCartFood AS scf
  JOIN Food AS f
  ON scf.item_id = f.id
  WHERE scf.scid = '#{scid}';
  SQL

  @db_adaptor.exec(command).values
  #return an array of the prices
end


  # # def increase_quantity_of_item(fid)
  # # end

  # # def decrease_quantity_of_item(fid)
  # # end

  # def get_food_items(category)
  #   command = <<-SQL
  #     SELECT * FROM Food
  #     WHERE category = '#{category}'
  #   SQL

  #   @db_adaptor.exec(command).values
  # end
end
