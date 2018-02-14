require_relative 'point.rb'
require_relative 'cluster.rb'

def dynamic_kmeans(data, clusters)
  loop do
    next_cluster = clusters.map(&:max_distance_point).max_by { |_, v| v }

    distances = clusters.combination(2).to_a

    if average_distance(distances) / 2 >= next_cluster[1]
      return put_dots_into_clusters(data, clusters)
    end

    data.delete(next_cluster.first)

    clusters = put_dots_into_clusters(data, clusters << Cluster.new(next_cluster.first))
  end
end

def average_distance(distances)
  distances.map { |pair| pair[0].center.dist_to(pair[1].center) }.reduce(:+) / distances.length
end

def initialize_dynamic_kmeans(data, k)
  seed_clusters = generate_clusters(data, k)
  first_cluster = seed_clusters.sample

  clusters = [first_cluster, max_distanced_cluster(first_cluster, seed_clusters)]

  put_dots_into_clusters(data, clusters)
end

def max_distanced_cluster(from_cluster, to_clusters)
  to_clusters.map do |seed_cluster|
    [seed_cluster, from_cluster.center.dist_to(seed_cluster.center)]
  end.to_h.max_by{ |_, v| v }.first
end

def generate_clusters(data, amount)
  Array.new(amount) do
    index = (data.length * rand).to_i
    rand_point = data[index]
    Cluster.new(rand_point)
  end
end

def put_dots_into_clusters(data, clusters)
  clusters.map(&:clear_point)
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
  clusters
end

def kmeans(data, k, delta = 0.001)
  clusters = generate_clusters(data, k)

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
