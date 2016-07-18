class HashTable
  def initialize(size=1)
    @hash = Array.new(size) { Array.new }
    @size = size
  end

  def include?(item)
    index = eval(item)
    @hash[index].include?(item)
  end

  def each
    @hash.each { |a| a.each { |l| yield(l) } }
  end

  def each_neighbor(item)
    index = eval(item)
    @hash[(index-1)%@size].each { |e| yield(e) }
    @hash[(index+1)%@size].each { |e| yield(e) }
  end

  def add(item)
    index = eval(item)
    @hash[index] << item
  end

  def remove(item)
    index = eval(item)
    @hash[index].delete(item)
  end

  def display
    for i in (0...@size)
      print "#{i}: "
      @hash[i].each { |e| print "#{e}," }
      puts
    end
  end

private

  def eval(item)
    (item[0].abs + item[1].abs)%@size
  end
end
