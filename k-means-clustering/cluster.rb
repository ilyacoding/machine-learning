class Cluster
  attr_accessor :center, :points, :color

  def initialize(center)
    @center = center
    @points = []
  end

  def recenter!
    xa = ya = 0
    old_center = @center

    @points.each do |point|
      xa += point.x
      ya += point.y
    end

    if points.length.positive?
      xa /= points.length
      ya /= points.length
    end

    @center = Point.new(xa, ya)
    old_center.dist_to(center)
  end

  def clear_point
    @points = []
  end

  def max_distance_point
    points.map { |point| [point, @center.dist_to(point)] }.to_h.max_by { |_, v| v } || default_point
  end

  def default_point
    [Point.new(0,0), 0]
  end
end
