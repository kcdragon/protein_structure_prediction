# author mike dalton
# date created august 17, 2009
# last modified august 17, 2009
# todo
# => this needs to be refactored, but it works

class Display
  # hp is a string, dir is a string, @coord is a list of lists, @norm is a grid
  def initialize(hp_seq,dir_seq)
    @hp,@dir = hp_seq,dir_seq

    @coord = generatecoord
    #@coord.each { |e| puts "#{e[0]} #{e[1]}" }
    #puts
    @norm = coordtonorm
    #@norm.each { |e| puts "#{e[0]} #{e[1]}" }
    @grid = normtogrid
    
    raise "Sequences are not compatible" if @hp.size!=(@dir.size+1)
  end

  def display
    for i in (0...@grid.size)
      for j in (0...@grid[0].size)
        print((@grid[i][j]==nil) ? " " : @grid[i][j])
      end
      puts
    end
  end

private

  def generatecoord
    list = [[0,0]]
    @dir.each_char { |c| list << get_next(list.last,c) }
    return list
  end

  def coordtonorm
    u_bound = get_u
    d_bound = get_d
    l_bound = get_l
    r_bound = get_r
    x_correcting = l_bound < 0 ? -l_bound : 0
    y_correcting = d_bound < 0 ? -d_bound : 0
    norm = []
    @coord.each { |e| norm << [ (e[0]+x_correcting) , (e[1]+y_correcting) ] }
    return norm
  end

  def normtogrid
    u_bound = get_u
    d_bound = get_d
    l_bound = get_l
    r_bound = get_r
    y_range = u_bound - d_bound
    x_range = r_bound - l_bound
    grid = Array.new((x_range+1)*2) { Array.new((y_range+1)*2) }

    for i in (0...@norm.size)
      x1 = @norm[i][0]*2
      y1 = @norm[i][1]*2
      if i < @norm.size-1 # if we are on the last spot just place it there  
        x2 = @norm[i+1][0]*2
        y2 = @norm[i+1][1]*2

        middle = getmiddle([x1,y1],[x2,y2])
        symbol = getsymbol([x1,y1],[x2,y2])

        grid[middle[0]][middle[1]] = symbol
      end
      grid[x1][y1] = @hp[i]
    end

    return grid
  end

  def getmiddle(a,b)
    return [ (a[0]+b[0])/2 , (a[1]+b[1])/2 ]
  end

  def getsymbol(a,b)
    if a[0]==b[0] # horizontal move
      return "-"
    else  # vertical move
      return "|"
    end
  end

  def get_next(prev,dir)
    if dir == "u"
      return [prev[0],prev[1]+1]
    elsif dir == "d"
      return [prev[0],prev[1]-1]
    elsif dir == "l"
      return [prev[0]-1,prev[1]]
    else
      return [prev[0]+1,prev[1]]
    end
  end

  def get_u
    max = -1000
    @coord.each { |e| max = e[1] if e[1] > max}
    return max
  end

  def get_d
    min = 1000
    @coord.each { |e| min = e[1] if e[1] < min}
    return min
  end

  def get_l
    min = 1000
    @coord.each { |e| min = e[0] if e[0] < min }
    return min
  end

  def get_r
    max = -1000
    @coord.each { |e| max = e[0] if e[0] > max }
    return max
  end
end
