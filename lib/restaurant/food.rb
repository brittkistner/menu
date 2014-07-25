class Restaurant::Food

  attr_reader :id, :name, :price, :type_of_item

  def initialize(id, name, price, type_of_item)
    @id = id
    @name = name
    @price = price
    @type_of_item = type_of_item
  end

  def self.create(name, price, type_of_item)
    result = Restaurant.orm.create_food(name,price,type_of_item)
    Restaurant::Food.new(result[:id],result[:name],result[:price],result[:type_of_item])
  end

  def self.get(id)
    result = Restaurant.orm.read_food_by_id(id)
    result == nil ? nil : Restaurant::Food.new(result[:id],result[:name],result[:price],result[:type_of_item])
  end

  def self.get_all
    result = Restaurant.orm.read_foods
    list = []

    result.each do |item|
      list << Restaurant::Food.new(result[:id],result[:name],result[:price],result[:type_of_item])
    end

    list
  end

  def self.delete_food(id)
    Restaurant.orm.delete_food(id) #returns true
  end


end

