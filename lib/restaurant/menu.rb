class Restaurant::Menu

  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def self.create_menu(name)
    result = Restaurant.orm.create_menu(name)
    Restaurant::Menu.new(result[:id], name)
  end

  def self.get_all
    result = Restaurant.orm.read_menus
    list = []

    if result.nil?
      return nil
    else
      result.each do |x|
        list << Restaurant::Menu.new(x[:id], x[:name])
      end
    end

    list #returns a nested array of menu instances
  end

  def add_food_to_menu(food_id)
    result = Restaurant.orm.add_menus_foods(@id,food_id) #returns boolean
  end

  def list_food
    result = Restaurant.orm.read_menu_foods(@id)

    list = []
    if result.nil?
      return nil
    else
      result.each do |x|
        list << Restaurant::Food.new(result[:id], result[:price], result[:type_of_item])
      end
    end

    list #return an array of foods
  end
end
