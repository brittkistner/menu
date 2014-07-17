class Restaurant::Menu

  attr_reader :id, :name
  attr_accessor :menu_list

  def initialize(id, name)
    @id = Integer(id)
    @name = name
    @menu_list = []
  end

  def self.get(id)
    result = Restaurant.orm.get_menu(id)
    Restaurant::Menu.new(result[0],result[1])
  end

  def self.create_menu(name)
    result = Restaurant.orm.add_menu(name)
    menu = Restaurant::Menu.new(result[0],result[1])
    menu
  end

  def add_food_to_menu(fid)
    result = Restaurant.orm.add_food_to_menu(@id,fid)

    food = Restaurant::Food.new(result[0],result[1],result[2],result[3])

    menu_list << food

    '#{food.name} added to #{@name}'
  end

  def get_beverages
    menu_list.each do |x|
      if x.type_of_item == "beverage"
        x.name
      end
    end
  end

  def get_appetizers
    menu_list.each do |x|
      if x.type_of_item == "appetizer"
        x.name
      end
    end
  end

  def get_entrees
    menu_list.map do |x|
      if x.type_of_item == "entree"
        x.name
      end
    end
  end

end
