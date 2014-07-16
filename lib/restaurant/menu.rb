class Restaurant::Menu

  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def self.get(id)
    result = Restaurant.orm.get_menu(id)
    Restaurant::Menu.new(result[0],result[1])
  end

  def create_menu(name)
    result = Restaurant.orm.add_menu(name)
    menu = Restaurant::Menu.new(result[0],result[1])
    menu
  end

  def get_food_items(category) #brings back info for all food items for a particular category in no particular order
    result = Restaurant.orm.get_food_items(@id, category)
    items = []

    result.each do |item|
      items << Restaurant::Food.new(item[0], item[1], item[2], item[3], item[4])
    end

    items #returns an array of food items
  end

  def get_beverages(category)
    get_food_items(category) #return the items array

  end

end
