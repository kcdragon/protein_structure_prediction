require 'set'

class HashTable

  def initialize
    @set = Set.new
  end

  def include?(item)
    @set.include?(item)
  end

  def each
    @set.each { |a| yield(a) }
  end

  def each_neighbor(item)
    @set.each { |a| yield(a) }
  end

  def add(item)
    @set << item
  end

  def remove(item)
    @set.delete(item)
  end
end
