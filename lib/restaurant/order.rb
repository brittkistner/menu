class Restaurant::Order

  attr_reader :id, :table_number, :creation_time
  attr_accessor :status

  def initialize(id, customer_id, creation_time, status)
    @id = id
    @customer_id = customer_id
    @creation_time = creation_time
    @status = status
  end

  def self.create_order_delete_shopping_cart(shopping_cart_id)
    result = Restaurant.orm.create_order_delete_shopping_cart(shopping_cart_id)
    order = Restaurant::Order.new(result[:id],result[:customer_id],result[:creation_time], result[:status])
    order
  end

  def self.get_orders_by_status
    result = Restaurant.orm.read_orders_by_status

    list = []
    if result.nil?
      return nil
    else
      result.each do |x|
        list << [x[:order_id], x[:status]]
      end
    end

    list
  end

  # def update_order_status(status)
  #   if status != "open" || "closed"
  #     return nil
  #   else
  #     Restaurant.orm.update_order_status(@id,status) #returns boolean
  #   end
  # end

  def read_order_foods
    result = Restaurant.orm.read_order_foods(@id)

    list = []
    if result.nil?
      return nil
    else
      result.each do |x|
        list << [x[:food_id], x[:food_quantity]]
      end
    end

    list
  end
end
