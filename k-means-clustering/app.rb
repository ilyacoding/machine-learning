require_relative 'algo.rb'
require 'ruby2d'

DOTS = 30_000
K = 7
WIDTH = 1200
HEIGHT = 900

data = DOTS.times.map { Point.new(rand(WIDTH), rand(HEIGHT)) }

clusters = kmeans(data, K)

set(height: HEIGHT, width: WIDTH)

clusters.each do |cluster|
  colour = random_color
  Square.new(x: cluster.center.x, y: cluster.center.y, size: 10, color: colour)

  cluster.points.each do |point|
    Square.new(x: point.x, y: point.y, size: 2, color: colour)
  end
end

show
