require "byebug"

class Tax
  BASE = 1.1

  def initialize(product)
    @product = product
  end
  
  def calculate_tax
    rate = taxable? ? BASE : 1.0
    rate += 0.05 if imported?
    @product.price * rate
  end

  def taxable?
    !@product.name.match(/.*book|choco|pills/i)
  end

  def imported?
    @product.name.match /.*imported/i
  end
end