# author mike dalton
# date created august 14, 2009
# last modified august 26, 2009
# todo
# => implement elitism

require 'hashtable'

class GA

  # hp is string, pop is list, maxgen is int, mutation is double, crossover is double, ctype is double
  def initialize(hp,pop,maxgen,mrate,crate,irate,ctype)
    @hp,@pop,@maxgen,@mrate,@crate,@irate,@ctype = hp,pop,maxgen,mrate,crate,irate,ctype

    odd = 0
    even = 0
    for i in (0...@hp.size)
      if @hp[i]=="h"
        if (i%2)==0
          even+=1
        else
          odd+=1
        end
      end
    end
    @term = 2*([even,odd].min)

    @val = 0
    for i in (1...@hp.size)
      if @hp[i]==@hp[i-1] && @hp[i]=="h"
        @val+=1
      end
    end

    @pval = 0
    for i in (1...@hp.size)
      if @hp[i]==@hp[i-1] && @hp[i]=="p"
        @pval+=1
      end
    end

    @reconform_dist = ((@hp.size-1)/10)

    @fitness_map = Hash.new

    @r = 0
    @n = 0
    @f = 0
  end

protected

  # @param chromosome string
  # @return fitness of chromosome, integer
  def fitness(chromosome)
    fitness=@fitness_map[chromosome]
    if fitness==nil
      fitness=0
      hash = newvirtual_coord_h(chromosome)
      hash.each do |c|
        hash.each_neighbor(c) do |n|
          if next_to?(c,n)
            fitness+=1
          end
        end
      end
      fitness = (fitness/2)-@val
      @fitness_map[chromosome]=fitness
    end
    return fitness
  end

  # @param fitnesslist list of corresponding fitnesses for population
  # @return new chromosome to add to new population, string
  # running time T(n)=2(n+k)+n^3+2(n^3)+2(n^2)=3n^3+2n^2+2n+2k, BigOh(n^3+k), n=chromosome.length k=population.size
  def selection(fitnesslist)
    chrom1,chrom2 = random_chromosome(fitnesslist),random_chromosome(fitnesslist)
    newchrom1,newchrom2 = crossover(chrom1,chrom2)
    newchrom1 = mutation(newchrom1)
    newchrom2 = mutation(newchrom2)
    #newchrom1 = inversion(newchrom1)
    #newchrom2 = inversion(newchrom2)
    newchrom = ((fitness(newchrom1)>fitness(newchrom2)) ? newchrom1 : newchrom2)
    return newchrom
  end

private

  # @param chromosome1, string
  # @param chromosome2, string
  # @return offspring of chromosome1 and chromosome2
  # running time: T(n)=(n^2+n^3)+(n^2+n^3), BigOh(n^3), n=chromosome.length
  def crossover(chromosome1,chromosome2)
    chrom1 = chromosome1[0...chromosome1.size]
    chrom2 = chromosome2[0...chromosome2.size]

    if rand < @crate
      len = chrom1.length
      if @ctype==1
        begin
          r1 = rand(len)
          c1p1,c1p2 = chrom1[0...r1],chrom1[r1..len]
          c2p1,c2p2 = chrom2[0...r1],chrom2[r1..len]

          newchrom1 = c1p1+c2p2
          newchrom2 = c2p1+c1p2

          find_collisions(newchrom1).each do |col|
            newchrom1 = reconform(newchrom1,col)
            if valid?(newchrom1)
              break
            end
          end

          find_collisions(newchrom2).each do |col|
            newchrom2 = reconform(newchrom2,col)
            if valid?(newchrom2)
              break
            end
          end
        end while !valid?(newchrom1) || !valid?(newchrom2)
      else # @ctype==2
        begin
          r1 = r2 = rand(len)
          r2 = rand(len) while r1==r2
          r1,r2=r2,r1 if r1>r2

          c1p1,c1p2,c1p3 = chrom1[0...r1],chrom1[r1...r2],chrom1[r2..len]
          c2p1,c2p2,c2p3 = chrom2[0...r1],chrom2[r1...r2],chrom2[r2..len]

          newchrom1 = c1p1+c2p2+c1p3
          newchrom2 = c2p1+c1p2+c2p3

          find_collisions(newchrom1).each do |col|
            newchrom1 = reconform(newchrom1,col)
            if valid?(newchrom1)
              break
            end
          end

          find_collisions(newchrom2).each do |col|
            newchrom2 = reconform(newchrom2,col)
            if valid?(newchrom2)
              break
            end
          end
        end while !valid?(newchrom1) || !valid?(newchrom2)
      end
    else
      newchrom1,newchrom2 = chrom1,chrom2
    end
    return newchrom1,newchrom2
  end

  # @param chromosome string
  # @return mutated chromosome
  # running time: T(n)=n*(n^2+n^3), BigOh(n^3), n=chromosome.length
  def mutation(chromosome)
    chrom = chromosome[0...chromosome.size]
    for i in (0...chrom.size)
      if rand < @mrate
        prev = chrom
        chrom[i] = (["u","d","l","r"]-[chrom[i]])[rand(3)]
        chrom = reconform(chrom,i)

#        collisions = find_collisions(chrom)
#        collisions.each do |col|
#          chrom = reconform(chrom,col)
#          if valid?(chrom)
#            break
#          end
#        end

        if !valid?(chrom)
          chrom = prev
        end
      end
    end
    return chrom
  end

  def inversion(chromosome)
    chrom = chromosome[0...chromosome.size]
    if rand < @irate
      len = chrom.size
      r1 = r2 = rand(len)
      r2 = rand(len) while r1==r2
      r1,r2=r2,r1 if r1>r2

      a = chrom[0...r1]
      m = chrom[r1..r2]
      b = chrom[r2+1...len]

      newchrom = a + m.reverse + b

      collisions = find_collisions(newchrom)
      if collisions.nil?
        chrom = newchrom
      end

      collisions.each do |col|
        newchrom = reconform(newchrom,col)
        if valid?(newchrom)
          chrom = newchrom
          break
        end
      end
    end
    return chrom
  end

  # @param fitnesslist list of corresponding fitnesses for population
  # @return random chromosome from population
  # running time: T(n)=n+n+k, BigOh(n+k), n=chromosome.length k=pop.size
  def random_chromosome(fitnesslist)
    fitnesstotal = 0
    cumlativefitness = []
    total = 0
    fitnesslist.each { |c| fitnesstotal+=c }
    fitnesslist.each { |c| total+=c ; cumlativefitness << ((total.to_f)/fitnesstotal) }
    r = rand
    for i in (0...@pop.size)
      if r < cumlativefitness[i]
        return @pop[i]
      end
    end
  end

  # @param chromosome string
  # @return false if there is a collision, true otherwise
  def valid?(chromosome)
    coord = HashTable.new
    last = [0,0]
    coord.add(last)
    chromosome.each_char do |c|
      new = next_location(last,c)
      if coord.include?(new)
        return false
      else
        coord.add(new)
        last = new
      end
    end
    return true
  end

  # @param chromosome string
  # @return list of collision indeces
  def find_collisions(chromosome)
    coord = HashTable.new
    last = [0,0]
    coord.add(last)
    collisions = []
    i=0
    chromosome.each_char do |c|
      new = next_location(last,c)
      if coord.include?(new)
        collisions << i
      end
      coord.add(new)
      last = new
      i+=1
    end
    return collisions
  end

  # @param chromosome string
  # @param collision index on string where collision occurs, integer
  # @return original chromosome if it is valid, backtrack(chromosome,collision) if not valid
  # running time: BigOh(n^3), n=chromosome.length
def reconform(chromosome,collision)
  if !valid?(chromosome)
    chrom = chromosome[0...chromosome.size]
    if chromosome.size<=collision+@reconform_dist
      return backtrack(chrom,collision,collision)
    else
      return backtrack(chrom,collision,collision+@reconform_dist)
    end
  end
  return chromosome
end

  # @param chromosome string
  # @param collision index on string where collision occurs, integer
  # @param index currently being looked at, integer
  # @return original chromosome if the string has ben fully backtracked
  #         new chrom if a change made the chromosome valid
  #         recurse, backtrack(chromosome,collision-1), if no new directions made it valid and there is still room to backtrack
  def backtrack(chromosome,collision,index)
    if index < (collision-@reconform_dist)
      @n+=1
      return chromosome
    end
    chrom = chromosome[0...chromosome.size]
    directions = (["u","d","l","r"]-[chrom[index]]).sort_by { |x| rand } # sort new directions in a random order
    directions.each do |dir|
      chrom[index]=dir
      if valid?(chrom)
        @r+=1
        return chrom
      end
    end
    return backtrack(chromosome,collision,index-1) # if there is nothing possible at collision try collision-1
  end

  # @param a chromosome, string
  # @param b chromosome, string
  # @return true if a and b are touching on grid
  # running time: BigTheta(1)
  def next_to?(a,b)
    return [ [a[0]+1,a[1]], [a[0]-1,a[1]] , [a[0],a[1]+1] ,[a[0],a[1]-1] ].include?(b)
  end

  # @param chromosome string
  # @return coordinates for string
  # running time: BigTheta(n), n=chromosome.length
  def newvirtual_coord(chromosome)
    coord = HashTable.new
    coord.add([0,0])
    chromosome.each_char { |c| coord.add(next_location(coord.last,c)) }
    return coord
  end

  # @param chromosome string
  # @return coordinates for string
  # running time: BigTheta(n), n=chromosome.length
  def newvirtual_coord_h(chromosome)
    coord = HashTable.new
    last = [0,0]
    coord.add(last)
    remove = (@hp[0]=="p")?[[0,0]]:[]
    i=1
    chromosome.each_char do |c|
      n = next_location(last,c)
      last = n
      coord.add(n)
      remove << n if @hp[i]=="p"
      i+=1
    end
    remove.each { |c| coord.remove(c) }
    return coord
  end

  # @param prev previous location, array of two integers
  # @param dir next direction to move in (u,d,l,r), string
  # @return next location,array of two integers
  # running time: BigTheta(1)
  def next_location(prev,dir)
    case dir
    when "u"
      return [prev[0],prev[1]-1]
    when "d"
      return [prev[0],prev[1]+1]
    when "l"
      return [prev[0]-1,prev[1]]
    when "r"
      return [prev[0]+1,prev[1]]
    else
      raise "Incorrect character in direction sequence"
    end
  end

  # performance metric
  def unique
    require 'set'
    a = Set.new
    @pop.each do |c|
      if ! a.include?(c)
        a << c
      end
    end
    return a.size
  end

  # performance metric
  def reconformpercent
    return (@r.to_f/(@r+@n))
  end

end

class SteadyStateGA < GA
  def initialize(hp,pop,maxgen,mutation,crossover,inversion,ctype,sschange)
    super(hp,pop,maxgen,mutation,crossover,inversion,ctype)
    @sschange = sschange
  end

  def run
    currgen = 1
    fitnesslist = []
    bestfitness = 0
    bestcanidate = ""

    for i in (0...@pop.size)
      fitness = fitness(@pop[i])
      fitnesslist[i] = fitness
      if fitness > bestfitness
        bestfitness = fitness
        bestcanidate = @pop[i]
      end
    end

    while currgen <= @maxgen# && bestfitness < (@term+1)
      #puts "Generation: #{currgen}"

      # generate new pop
      newpop = []
      i=0
      while newpop.size < (@pop.size*@sschange)
        chrom = selection(fitnesslist)
        if ! valid?(chrom)
          puts "something wrong in while in #{i}"
        end
        newpop << chrom
        i+=1
      end

      # replace worst fitness of currrent pop with the new pop
      @pop.sort_by { |c| fitness(c) }
      for j in (0...@pop.size*@sschange)
        @pop[j] = newpop[j]
      end

      ft=0
      for j in (0...@pop.size)  #calculate new fitnesslist, best canidate and fitness of the canidate
        fitness = fitness(@pop[j])
        ft+=fitness
        fitnesslist[j] = fitness
        if fitness > bestfitness
          bestfitness = fitness
          bestcanidate = @pop[j]
        end
      end

      #puts "best canidate: #{bestcanidate}\tbest fitness: #{bestfitness}"
      #puts "percent able to reconform: #{reconformpercent}%"
      #puts "number of unique population: #{unique}"
      #puts "average fitness: #{ft.to_f/@pop.size}"
      #puts "total fitness evals so far: #{@f}"
      currgen+=1
    end
    return bestcanidate,bestfitness
  end

end

class StandardGA < GA
  def initialize(hp, pop, maxgen, mutation, crossover, inversion, ctype)
    super
  end

  def run
    generation_count = 1
    fitness_list = []

    begin
      fitness_list = @pop.map do |candidate|
        fitness(candidate)
      end

      @pop = @pop.map do
        selection(fitness_list)
      end

      generation_count += 1
    end while generation_count <= @maxgen && best_fitness(fitness_list) < @term

    return best_candidate(@pop), best_fitness(fitness_list)
  end

  private

  def best_fitness(fitness_list)
    fitness_list.max || 0
  end

  def best_candidate(population)
    population.max { |candidate| fitness(candidate) }
  end
end
