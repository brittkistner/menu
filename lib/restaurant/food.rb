class Restaurant::Food

  attr_reader :id, :name, :price, :type_of_item

  def initialize(id, name, price, type_of_item)
    @id = Integer(id)
    @name = name
    @price = Integer(price)
    @type_of_item = type_of_item
  end

  def self.get(id)
    result = Restaurant.orm.get_food(id)
    Restaurant::Food.new(result[0],result[1],result[2],result[3])
  end

  def self.add_food(name, price, type_of_item)
    result = Restaurant.orm.create_food(name,price,type_of_item)
    Restaurant::Food.new(result[0],result[1],result[2],result[3])
  end

  def self.remove_food(id)
    Restaurant.orm.remove_food(id)
  end

  def self.list
    result = Restaurant.orm.list_all_food
    list = []

    result.each do |item|
      list << Restaurant::Food.new(item[0],item[1],item[2],item[3])
    end

    list
  end
end
