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
    result = Restaurant.orm.get_food_items(category)
    menu = Restuarant::Menu.new(result[1], result[2])#enter needed info)
    menu

    #return a menu instance, would like to add categories (beverages, apps, etc to the menu instance)
  end

end
