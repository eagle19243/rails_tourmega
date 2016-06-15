require 'database_cleaner'
require 'open-uri'

DatabaseCleaner[:active_record].clean_with(:truncation, only: %w[countries cities slides categories])
# DatabaseCleaner[:active_record].clean_with(:truncation, only: %w[tours users locations tour_imports categories_tours])

begin
  AdminUser.create!(email: 'admin@tourmega.com', password: 'password17e3', password_confirmation: 'password17e3')
  User.create!(email: 'support@tourmega.com', password: 'password17e3')
  User.create!(email: 'bdthinh@tourmega.com', password: 'password17e3', first_name: 'Thinh', last_name: 'Bui')
rescue
  p "Admin and user are already existed"
end

puts "Creating Country Data"
Country.delete_all
code_index = 0
lng_index = 1
lat_index = 2
name_index = 3
file = open('db/countries.csv').read
CSV.parse(file, headers: true) do |row|
  begin
    Country.create(code: row[code_index], name: row[name_index], lng: row[lng_index], lat: row[lat_index])
    p "#{row[code_index]}, #{row[name_index]}, #{row[lng_index]}, #{row[lat_index]}"
  rescue
    p "Cannot create country data for #{row[name_index]}"
  end
end

countries = [
  {
    slug: 'cambodia',
    scene_images: [open(File.join(Rails.root, '/app/assets/images/countries/small/small_cambodia.jpg'))]
  },
  {
    slug: 'china',
    scene_images: [open(File.join(Rails.root, '/app/assets/images/countries/small/small_china.jpg'))]
  },
  {
    slug: 'indonesia',
    scene_images: [open(File.join(Rails.root, '/app/assets/images/countries/small/small_indonesia.jpg'))]
  },
  {
    slug: 'japan',
    scene_images: [open(File.join(Rails.root, '/app/assets/images/countries/small/small_japan.jpg'))]
  },
  {
    slug: 'malaysia',
    scene_images: [open(File.join(Rails.root, '/app/assets/images/countries/small/small_malaysia.jpg'))]
  },
  {
    slug: 'philippines',
    scene_images: [open(File.join(Rails.root, '/app/assets/images/countries/small/small_philippines.jpg'))]
  },
  {
    slug: 'bangladesh',
    scene_images: [open(File.join(Rails.root, '/app/assets/images/countries/small/small_bangladesh.jpg'))]
  },
  {
    slug: 'india',
    scene_images: [open(File.join(Rails.root, '/app/assets/images/countries/small/small_india.jpg'))]
  },
  {
    slug: 'laos',
    scene_images: [open(File.join(Rails.root, '/app/assets/images/countries/small/small_laos.jpg'))]
  },
  {
    slug: 'singapore',
    scene_images: [open(File.join(Rails.root, '/app/assets/images/countries/small/small_singapore.jpg'))]
  },
  {
    slug: 'thailand',
    scene_images: [open(File.join(Rails.root, '/app/assets/images/countries/small/small_thailand.jpg'))]
  },
  {
    slug: 'vietnam',
    scene_images: [open(File.join(Rails.root, '/app/assets/images/countries/small/small_vietnam.jpg'))]
  }
]
countries.each do |country_params|
  @country = Country.find_by(slug: country_params[:slug])
  @country.scene_images = country_params[:scene_images]
  @country.save!
end

puts "Creating City Data"
City.delete_all
File.open(File.join(Rails.root, "db/active_countries.txt"), 'r').each_line do |line|
  code, cities = line.chomp.split("|")
  @country = Country.find_by(code: code)
  @country.update_attributes(is_searching_active: true)
  cities.split(",").each do |city|
    City.create(name: city, country: @country, is_searching_active: true)
    p "#{code}: #{city}"
  end
end

puts "Creating Slide Data"
Slide.delete_all
slides = [
  {
    caption: 'Love Helping People',
    location: 'Create new income for locals while enjoying unique experiences',
    remote_image_url: 'https://d1fivur53ms4lq.cloudfront.net/assets/new_banners/3-e6f36c7899b0ac8bb69bbc05bc2aa9d7.jpg'
  },
  {
    caption: 'Taking a trip',
    location: 'Request a tour and enjoy authentic experiences',
    remote_image_url: 'https://d1fivur53ms4lq.cloudfront.net/assets/new_banners/8-7839c4f2ad131f62546781a7407deec1.jpg'
  },
  {
    caption: 'Feeling Advanturous',
    location: 'Get submersed in the local culture and travel safely',
    remote_image_url: 'https://d1fivur53ms4lq.cloudfront.net/assets/new_banners/2-0aa5ce8f94472890834aeff279ddd5a5.jpg'
  }
]

slides.each do |slide|
  @slide = Slide.create(caption: slide[:caption], location: slide[:location], remote_image_url: slide[:remote_image_url])
  p slide[:caption]
end

puts "Creating Category Data"
Category.delete_all
categories = [
  {
    symbol: 'art',
    name: I18n.t('search.tour_types.art'),
    icon: open(File.join(Rails.root, '/app/assets/images/categories/art.png'))
  },
  {
    symbol: 'tech',
    name: I18n.t('search.tour_types.tech'),
    icon: open(File.join(Rails.root, '/app/assets/images/categories/tech.png'))
  },
  {
    symbol: 'shopping',
    name: I18n.t('search.tour_types.shopping'),
    icon: open(File.join(Rails.root, '/app/assets/images/categories/shopping.png'))
  },
  {
    symbol: 'food',
    name: I18n.t('search.tour_types.food'),
    icon: open(File.join(Rails.root, '/app/assets/images/categories/food.png'))
  },
  {
    symbol: 'night_life',
    name: I18n.t('search.tour_types.night_life'),
    icon: open(File.join(Rails.root, '/app/assets/images/categories/night_life.png'))
  },
  {
    symbol: 'photography',
    name: I18n.t('search.tour_types.photography'),
    icon: open(File.join(Rails.root, '/app/assets/images/categories/photography.png'))
  },
  {
    symbol: 'excursion',
    name: I18n.t('search.tour_types.excursion'),
    icon: open(File.join(Rails.root, '/app/assets/images/categories/excursion.png'))
  },
  {
    symbol: 'sightseeing',
    name: I18n.t('search.tour_types.sightseeing'),
    icon: open(File.join(Rails.root, '/app/assets/images/categories/sightseeing.png'))
  },
  {
    symbol: 'cruises',
    name: I18n.t('search.tour_types.cruises'),
    icon: open(File.join(Rails.root, '/app/assets/images/categories/cruises.png'))
  },
  {
    symbol: 'sports',
    name: I18n.t('search.tour_types.sports'),
    icon: open(File.join(Rails.root, '/app/assets/images/categories/sports.png'))
  }
]

categories.each do |category|
  @category = Category.create(category)
  p category[:name]
end
