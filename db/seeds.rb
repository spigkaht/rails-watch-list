# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
require 'json'

puts "Clearing out your junk.."
List.destroy_all
Bookmark.destroy_all
Movie.destroy_all

movies = []
lists = []

descs = ["Laughs", "Feels", "Really Feels", "Bang Bang", "Alex Lives Here", "Bruce Willis?", "Science is Golden", "Just Tolkien", "Tuesday Nights", "Weird Shit", "For Dog", "Wes Anderson 4EVA"]

puts "Creating Lists.."
12.times do |i|
  list = List.create!(name: "#{descs[i]}")
  lists << list

  file = File.open("public/images/poster#{i + 1}.jpg")
  list.photo.attach(io: file, filename: "")
  puts "##{i} done"
end
puts "Lists done!"

puts "Creating movies.."
uri = "https://tmdb.lewagon.com/movie/top_rated"
html_file = URI.open(uri).read
srlzd = JSON.parse(html_file)

18.times do |i|
  result = srlzd["results"][i]
  title = result["title"]
  overview = result["overview"]
  poster = result["poster_path"]
  rating = result["vote_average"]
  poster_url = "https://image.tmdb.org/t/p/w500#{poster}"
  movie = Movie.create!(title: title, overview: overview, poster_url: poster_url, rating: rating)
  movies << movie
  puts "##{i} done"
end

uri = "https://tmdb.lewagon.com/movie/popular"
html_file = URI.open(uri).read
srlzd = JSON.parse(html_file)

18.times do |x|
  result = srlzd["results"][x]
  title = result["title"]
  overview = result["overview"]
  overview = "No overview provided" if overview == ""
  poster = result["poster_path"]
  rating = result["vote_average"]
  poster_url = "https://image.tmdb.org/t/p/w500#{poster}"
  movie = Movie.create!(title: title, overview: overview, poster_url: poster_url, rating: rating)
  movies << movie
  puts "##{x} done"
end
puts "All movies added!"

puts "Creating bookmarks.."
100.times do |i|
  comment = Faker::Fantasy::Tolkien.poem
  bookmark = Bookmark.create(comment: comment, movie: movies.sample, list: lists.sample)
  bookmark.save
  puts "##{i} done"
end
puts "All bookmarks added!"
