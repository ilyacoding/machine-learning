require 'ruby2d'
require 'pry'
require_relative 'algo.rb'

WIDTH = 1200
HEIGHT = 900

DOTS = 20_000
K = 11

data = Array.new(DOTS) { Point.new(rand(WIDTH), rand(HEIGHT)) }

# Maximin
clusters = initialize_dynamic_kmeans(data, K)
clusters = dynamic_kmeans(data, clusters)

# K-means
# clusters = kmeans(data, K)

set(height: HEIGHT + 10, width: WIDTH + 10)

clusters.each do |cluster|
  colour = random_color
  Square.new(x: cluster.center.x, y: cluster.center.y, size: 10, color: colour)

  cluster.points.each do |point|
    Square.new(x: point.x, y: point.y, size: 2, color: colour)
  end
end

show
