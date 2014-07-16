require 'spec_helper.rb'
require 'pry-byebug'

describe 'Orm' do
  before(:all) do
    Restaurant.orm.instance_variable_set(:@db_adaptor, PG.connect(host: 'localhost', dbname: 'menu-db-test'))
  end

  before(:each) do
    Restaurant.orm.reset_tables
  end

  after(:all) do
    Restaurant.orm.drop_tables
  end

  it "is an Orm" do
    expect(Restaurant.orm).to be_a(Restaurant::Orm)
  end

  xit 'is created with a db adaptor' do
    expect(Restaurant.orm.db_adaptor).not_to be_nil
  end

  ####FOOD CLASS ######
  describe '#create_food' do
    it 'adds a tuple to the food table and returns an array with the food information' do
      expect(Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")).to be_a(Array)
    end
  end

  describe '#get_food' do
    it 'looks up a food tuple and returns an array with the food information' do
      Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")

      expect(Restaurant.orm.get_food(1)).to be_a(Array)
      expect(Restaurant.orm.get_food(1).length).to eq(1)
    end
  end

  describe '#remove_food' do
    it 'removes a tuple from the food table and returns true' do
      Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")
      expect(Restaurant.orm.remove_food(1)).to eq(true)
    end
  end

  describe '#list_all_food' do
    it 'retrieves all information from the food table and returns as an array of arrays' do
      Restaurant.orm.create_food("hamburger", 10, "lunch", "entree")
      Restaurant.orm.create_food("burrito", 8, "lunch", "entree")
      expect(Restaurant.orm.list_all_food.length).to eq(2)
    end
  end

  #####CUSTOMER CLASS#####
end
