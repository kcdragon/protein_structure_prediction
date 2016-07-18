# author mike dalton
# date created august 14, 2009
# last modified august 24, 2009

require 'ga'
require 'convert'
require 'pop'
require 'display'
require 'getoptlong'

AMINOACIDS = ["a","r","n","d","c","e","q","g","h","i","l","k","m","f","p","s","t","w","y","v"]
HYDROPHOBIC = ["a","c","g","i","l","m","f","p","w","v"]
HYDROPHOLIC = ["r","n","d","e","q","h","k","s","t","y"]

if ARGV.length == 0
  $stderr.puts 'Invalid arguments.'
  $stderr.puts 'Usage: #{$0} [options...] sequence'
  $stderr.puts
  $stderr.puts 'where options include:'
  $stderr.puts '  --gatype, -G              the type of ga to use(0:standard, 1:steady-state)'
  $stderr.puts '  --steadystatechange, -r   if steady chosen, this is the percent of population that will be changed each generation'
  $stderr.puts '  --maxgen, -g              the maximum number of generations to run for'
  $stderr.puts '  --mutationrate, -m        the mutation rate'
  $stderr.puts '  --crossoverrate, -c       the crossover rate'
  $stderr.puts '  --inversionrate, -i       the inversion rate'
  $stderr.puts '  --population, -p          the population size'
  $stderr.puts '  --crossovertype, -t       the type of crossover (1:one point crossover, 2:two point crossover)'
  $stderr.puts '  --output, -o file         send all results to output file'
  exit(1)
end

opts = GetoptLong.new(
  [ '--gatype','-G', GetoptLong::REQUIRED_ARGUMENT],
  [ '--steadystatechange','-r', GetoptLong::REQUIRED_ARGUMENT],
  [ '--maxgen','-g', GetoptLong::REQUIRED_ARGUMENT],
  [ '--mutationrate','-m', GetoptLong::REQUIRED_ARGUMENT],
  [ '--crossoverrate','-c', GetoptLong::REQUIRED_ARGUMENT],
  [ '--inversionrate','-i', GetoptLong::REQUIRED_ARGUMENT],
  [ '--populationsize','-p', GetoptLong::REQUIRED_ARGUMENT],
  [ '--crossovertype','-t', GetoptLong::REQUIRED_ARGUMENT]
)

gatype = 0
sschange = 0.4
maxgen = 1000
mutation = 0.05
crossover = 0.9
inversion = 0.5
ctype = 1
population = 200

opts.each do |opt, arg|
  case opt
  when '--gatype'
    raise "Invalid GA type: #{arg} is not a valid input" if arg.to_i != 0 && arg.to_i != 1
    gatype = arg.to_i
  when 'steadystatechange'
    sschange = arg.to_f
	when '--maxgen'
    raise "Invalid number of Maximum Generations: #{arg} is not a valid input" if arg.to_f < 0# || arg.is_a?(Fixnum)
    maxgen = arg.to_i
  when '--mutationrate'
    raise "Invalid Mutation Rate: #{arg} is not a valid input" if arg.to_f < 0 || arg.to_f > 1
    mutation = arg.to_f
  when '--crossoverrate'
    raise "Invalid Crossover Rate: #{arg} is not a valid input" if arg.to_f < 0 || arg.to_f > 1
    crossover = arg.to_f
  when '--inversionrate'
    raise "Invalid Inversion Rate: #{arg} is not a valid input" if arg.to_f < 0 || arg.to_f > 1
    inversion = arg.to_f
  when '--populationsize'
    raise "Invalid size of population: #{arg} is not a valid input" if arg.to_i < 0# || arg.is_a?(Fixnum)
    population = arg.to_i
  when '--crossovertype'
    raise "Invalid type of crossover: #{arg} is not a valid input" if arg.to_i != 1 && arg.to_i != 2
    ctype = arg.to_i
  end
end

#hp_seq = ARGV[0].downcase
#aa_seq.each_char { |c| raise "Error: #{c} is not a valid amino acid." if AMINOACIDS.index(c.downcase)==nil }
#hp_seq = Convert.aatohp(aa_seq)

hp_seq = "hphhpph"
#hp_seq = "hphpphhphpphphhpphph" # 9/9, 48 gens,standard, 1 point cross, .6 cross, .1 mut
#hp_seq = "hhpphpphpphpphpphpphpphh" # 9/9, 467 gens,standard, 1 point cross, .6 cross, .1 mut
#hp_seq = "pphpphhpppphhpppphhpppphh" # 7/8, 1000 gens,steady state(.4 change), 1 point cross, .75 cross, .1 mut
                                     # 7/8, 1000 gens,standard, 1 point cross, .6 cross, .1 mut
#hp_seq = "ppphhpphhppppphhhhhhhpphhpppphhpphpp" # 13/14, 1000 gens, steady state(.4 change), 1 point cross, .75 cross, .1 mut
                                                # 13/14, 1000 gens,standard, 1 point cross, .6 cross, .1 mut, 200 pop
#hp_seq = "pphpphhpphhppppphhhhhhhhhhpppppphhpphhpphpphhhhh" # 22

#puts "Amino Acid Sequence: #{aa_seq.upcase}"
#puts "HP Model: #{hp_seq.upcase}"

pop = Pop.new(hp_seq,population).generate
#puts pop

#pop.each do |c|
#  puts "\nDisplay #{fitness(c,hp_seq)}"
#  display = Display.new(hp_seq, c)
#  display.display
#end

start = Time.now
if gatype==0
  standard = StandardGA.new(hp_seq,pop,maxgen,mutation,crossover,inversion,ctype)
  bestcanidate,bestfitness = standard.run
else
  steadystate = SteadyStateGA.new(hp_seq,pop,maxgen,mutation,crossover,inversion,ctype,sschange)
  bestcanidate,bestfitness = steadystate.run
end
endt = Time.now

#puts "Variables: gatype #{gatype}, crossoverrate #{crossover}, mutationrate #{mutation}, crossovertype #{ctype}, pop size #{population}"
#puts "#{gatype},#{crossover},#{mutation},#{ctype},#{population}"
#puts "Solution #{bestcanidate} #{bestfitness}"
puts "#{bestcanidate},#{bestfitness},#{endt-start}"
#puts "Time: #{endt-start}"

display = Display.new(hp_seq,bestcanidate)
#display = Display.new(hp_seq,"ruruluulluuulddddrrddlulddldluurulluulururdddru")
display.display
