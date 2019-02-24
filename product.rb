require_relative 'tax'
# require "byebug"

class Product
  attr_accessor :price, :name # , :tax 

  def initialize(args)
    # @name, @price = args
    @price = args[1].to_f
    @name = args[0]
    # byebug
    raise 'Invalid Format' unless @name.match?(/^[a-zA-Z\s]+/) # (@price.match(/\d/) && )
  end
  
  def tax
    Tax.new(self).calculate_tax
  end
  
end
