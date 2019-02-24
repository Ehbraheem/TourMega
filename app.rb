require 'csv'
require 'byebug'

require_relative 'product'

class App
  
  def self.start
    receipts = []
    puts "Quantity, Product, Price... example: \n 1, book, 12.7"
    loop do
      input = parse_inputs
      if input.length === 3 
        unless input.join(',').match(/\A\d,[a-zA-Z]+,[-+]?[0-9]*\.?[0-9]+\z/)
          print "\n\n\nInvalid input values received\n\n\n\nUsage: ruby app.rb 1, book, 12.7" 
          break
        end
        qty = input.shift
        product = Product.new input
        receipts << [qty, product]
      elsif input.length > 3
        print "\n\n\nToo many values received\n\n\n\nUsage: ruby app.rb 1, book, 12.7"
        break
      else
        print "\n\n\nNo product received\n\n\n\nUsage: ruby app.rb 1, book, 12.7" unless !receipts.empty?
        break
      end
    end
    output receipts unless receipts.empty?
  end

  def self.output receipts
    out_file = 'receipts.csv'
    puts "Writing receipts to file: `#{out_file}`"
    total_tax = 0
    total_price = 0
    receipts = receipts.map do |receipt|
      # byebug
      qty, product = receipt
      qty = qty.to_i
      price = (qty * product.tax).round(2)
      total_price += price
      total_tax += (price - (qty * product.price)).round(2) 
      [qty, product.name, price]
    end
    File.open(out_file, "w") do |f|
      f.write receipts.map(&:to_csv).join
      f.write CSV.generate_line(["Sales Taxes: #{total_tax}"])
      f.write CSV.generate_line(["Total: #{total_price}"])
    end
    puts "Receipt Written successfully to file: `#{out_file}`"
  end

  def self.parse_inputs
    gets.chomp.split(',').map(&:strip)
  end
end

if __FILE__ === $0
  App.start
end