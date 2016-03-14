require 'json'

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $stdout.reopen(File.open('report.txt', 'w+'))
end

# Print "Sales Report" in ascii art

# Print today's date
def print_date
  puts Time.now.strftime("Today's Date: %d/%m/%Y")
end

# Print "Products" in ascii art
def print_products_ascii
  puts "                     _            _       "
  puts "                    | |          | |      "
  puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
  puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
  puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
  puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
  puts "| |                                       "
  puts "|_|                                       "
end

# For each product in the data set:
  # Print the name of the toy
  # Print the retail price of the toy
  # Calculate and print the total number of purchases
  # Calculate and print the total amount of sales
  # Calculate and print the average price the toy sold for
  # Calculate and print the average discount (% or $) based off the average sales price

def get_product(toy)
  product = {
    title: toy["title"],
    retail_price: toy["full-price"].to_f,
    purchases_number: toy["purchases"].length,
    total_sales: 0
  }
  toy["purchases"].each do |purchase|
    product[:total_sales] += purchase["price"].to_f
  end
  return product
end

def print_separator
  puts "********************"
end

def print_blank_line
  print "\n"
end

def print_product(product)
  print_blank_line
  puts product[:title]
  print_separator
  puts "Retail Price: $#{product[:retail_price]}"
  puts "Total Purchases: #{product[:purchases_number]}"
  puts "Total Sales: $#{product[:total_sales]}"
  average_price = product[:total_sales] / product[:purchases_number]
  average_discount = product[:retail_price] - average_price
  average_discount_percentage = (average_discount * 100 / product[:retail_price]).round(2)
  puts "Average Price: $#{average_price}"
  puts "Average Discount: $#{average_discount}"
  puts "Average Discount Percentage: #{average_discount_percentage}%"
  print_separator
end

def init_brand_info(brand_title)
  $brands[brand_title] = {stock: 0, prices: [], total_sales: []}
end

def collect_brand_info(brand_title, toy, product)
	brand = $brands[brand_title]
	brand[:stock] += toy["stock"].to_i
  brand[:prices].push(product[:retail_price])
  brand[:total_sales].push(product[:total_sales])
end

def handle_products
  print_products_ascii
  $products_hash["items"].each do |toy|
    product = get_product(toy)
    print_product(product)
    brand_title = toy["brand"]
    init_brand_info(brand_title) if !$brands.has_key?(brand_title)
    collect_brand_info(brand_title, toy, product)
  end
  print_blank_line
end

# Print "Brands" in ascii art

# For each brand in the data set:
  # Print the name of the brand
  # Count and print the number of the brand's toys we stock
  # Calculate and print the average price of the brand's toys
  # Calculate and print the total sales volume of all the brand's toys combined

def create_report
  print_date
  $brands = {}
  handle_products
end

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

start # call start method to trigger report generation
