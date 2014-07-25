class Restaurant::Staff

  attr_reader :id, :name

  def initialize (id, name)
    @id = Integer(id)
    @name = name
  end

  def self.create_staff(name)
    staff = Restaurant.orm.create_staff(name)
    Restaurant::Staff.new(staff[:id],name)
  end
end
