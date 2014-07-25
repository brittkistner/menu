require 'spec_helper.rb'
require 'pry-byebug'

describe 'Restaurant::Staff' do
  it 'exists' do
    expect(Restaurant::Staff).to be_a(Class)
  end

  describe '.create_staff' do
    it 'returns a new Restaurant::Staff instance given a name' do
      expect(Restaurant::Staff.create_staff("Benny")).to be_a(Restaurant::Staff)
    end
  end
end
