require_relative 'point.rb'
require_relative 'cluster.rb'

def kmeans(data, k, delta = 0.001)
  clusters = []

  (1..k).each do
    index = (data.length * rand).to_i
    rand_point = data[index]
    clusters.push(Cluster.new(rand_point))
  end

  loop do
    data.each do |point|
      min_dist = Float::INFINITY
      min_cluster = nil

      clusters.each do |cluster|
        dist = point.dist_to(cluster.center)

        if dist < min_dist
          min_dist = dist
          min_cluster = cluster
        end
      end

      min_cluster.points.push(point)
    end

    max_delta = -Float::INFINITY

    clusters.each do |cluster|
      dist_moved = cluster.recenter!
      max_delta = dist_moved if dist_moved > max_delta
    end

    return clusters if max_delta < delta

    clusters.each do |cluster|
      cluster.points = []
    end
  end
end

def random_color
  '#' + "%06x" % (rand * 0xffffff)
end
