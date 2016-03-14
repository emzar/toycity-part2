require 'json'

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $stdout.reopen(File.open('report.txt', 'w+'))
end

# Print "Sales Report" in ascii art
def print_sales_report_ascii
  puts "  ______       _                ______                                "
  puts " / _____)     | |              (_____ \\                           _   "
  puts "( (____  _____| | _____  ___    _____) )_____ ____   ___   ____ _| |_ "
  puts " \\____ \\(____ | || ___ |/___)  |  __  /| ___ |  _ \\ / _ \\ / ___|_   _)"
  puts " _____) ) ___ | || ____|___ |  | |  \\ \\| ____| |_| | |_| | |     | |_ "
  puts "(______/\\_____|\\_)_____|___/   |_|   |_|_____)  __/ \\___/|_|      \\__)"
  puts "                                             |_|  "
end

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

def print_divider
  puts "********************"
end

def print_blank_line
  print "\n"
end

def print_product(product)
  print_blank_line
  puts product[:title]
  print_divider
  puts "Retail Price: $#{product[:retail_price]}"
  puts "Total Purchases: #{product[:purchases_number]}"
  puts "Total Sales: $#{product[:total_sales]}"
  average_price = product[:total_sales] / product[:purchases_number]
  average_discount = product[:retail_price] - average_price
  average_discount_percentage = (average_discount * 100 / product[:retail_price]).round(2)
  puts "Average Price: $#{average_price}"
  puts "Average Discount: $#{average_discount}"
  puts "Average Discount Percentage: #{average_discount_percentage}%"
  print_divider
end

def collect_brand_info(toy, product)
  brand_title = toy["brand"]
  if (!$brands.has_key?(brand_title))
  $brands[brand_title] = {stock: 0, prices: [], total_sales: []}
  end
  $brands[brand_title][:stock] += toy["stock"].to_i
  $brands[brand_title][:prices].push(product[:retail_price])
  $brands[brand_title][:total_sales].push(product[:total_sales])
end

def handle_products
  print_products_ascii
  $brands = {}
  $products_hash["items"].each do |toy|
    product = get_product(toy)
    print_product(product)
    collect_brand_info(toy, product)
  end
  print_blank_line
end

# Print "Brands" in ascii art
def print_brands_ascii
  puts " _                         _     "
  puts "| |                       | |    "
  puts "| |__  _ __ __ _ _ __   __| |___ "
  puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
  puts "| |_) | | | (_| | | | | (_| \\__ \\"
  puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
  puts
end

# For each brand in the data set:
  # Print the name of the brand
  # Count and print the number of the brand's toys we stock
  # Calculate and print the average price of the brand's toys
  # Calculate and print the total sales volume of all the brand's toys combined

def print_brands
  print_brands_ascii
  $brands.each do |title, value|
    puts title
    print_divider
    puts "Number of Products: #{value[:stock]}"
    average_price = (value[:prices].reduce(:+) / value[:prices].length).round(2)
    puts "Average Product Price: $#{average_price}"
    total_sales = value[:total_sales].reduce(:+).round(2)
    puts "Total Sales: $#{total_sales}"
    print_blank_line
  end
end

def create_report
  print_sales_report_ascii
  print_date
  handle_products
  print_brands
end

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

start # call start method to trigger report generation
