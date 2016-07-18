# author mike dalton
# date created august 14, 2009
# last modified august 19, 2009
# another possible way to generate population - pick direction randomly, then call reconform to put back in valid order

class Pop
  DIRECTIONS = ["u","d","l","r"]

  def initialize(hp,size)
    @hp,@size = hp,size
  end

  def generate
    pop = []
    @size.times { pop << create }
    return pop
  end

private

  # returns a string
  def create
    return backtrack([""],[[0,0]])
  end

  # standard backtracking algorithm
  # returns a string
  def backtrack(chromosomelist,coordinates)
    chrom = chromosomelist.last
    coord = coordinates
    
    return nil if chrom.length == @hp.size-1

    possible = randomize_directions(possible_directions(coord))
    return "failed" if possible == nil

    possible.each_char do |dir|
      newChrom = chrom+dir
      newChromList = chromosomelist.push(newChrom)
      newCoord = coord+directiontocoordinate(dir,coord.last)
      path = backtrack(newChromList,newCoord)
      if path != "failed"
        if path == nil
          return dir
        else
          return path+dir
        end
      end
    end
    return "failed"
  end

  # returns a string of valid directions to move in
  def possible_directions(coordinates)
    prev = coordinates.last
    poss = [ [prev[0],prev[1]+1] , [prev[0],prev[1]-1] , [prev[0]-1,prev[1]] , [prev[0]+1,prev[1]] ] # the list of possible moves
    valid = ""
    for i in (0..3)
      valid << DIRECTIONS[i] if !coordinates.include?(poss[i])
    end
    return valid
  end

  # return directions in a random order
  # this prevents always trying the directions in the same order (i.e. u d l r)
  def randomize_directions(directions)
    dir = directions
    dir2 = ""
    while dir != ""
      r = rand(dir.length)
      dir2 << dir[r]
      dir[r]=""
    end
    return dir2
  end

  # gets the new corrdinates given the direction and previous coordinates
  # returns an array of an array of two ints
  def directiontocoordinate(direction,previous)
    case direction
    when "u"
      new_dir = [[previous[0],previous[1]+1]]
    when "d"
      new_dir = [[previous[0],previous[1]-1]]
    when "l"
      new_dir = [[previous[0]-1,previous[1]]]
    when "r"
      new_dir = [[previous[0]+1,previous[1]]]
    else
      raise "Incorrect character in direction sequence"
    end
    return new_dir
  end
end