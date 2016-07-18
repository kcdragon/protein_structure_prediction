# author mike dalton
# date created august 14, 2009
# last modified august 24, 2009

require 'ga'
require 'convert'
require 'pop'
require 'display'
require 'getoptlong'

def help!
  $stderr.puts 'Invalid arguments.'
  $stderr.puts "Usage: #{$0} [options...] sequence"
  $stderr.puts
  $stderr.puts 'where options include:'
  $stderr.puts '  --gatype, -G              the type of ga to use(0:standard, 1:steady-state)'
  $stderr.puts '  --steadystatechange, -r   if steady chosen, this is the percent of population that will be changed each generation'
  $stderr.puts '  --maxgen, -g              the maximum number of generations to run for'
  $stderr.puts '  --mutationrate, -m        the mutation rate'
  $stderr.puts '  --crossoverrate, -c       the crossover rate'
  $stderr.puts '  --inversionrate, -i       the inversion rate'
  $stderr.puts '  --populationsize, -p      the population size'
  $stderr.puts '  --crossovertype, -t       the type of crossover (1:one point crossover, 2:two point crossover)'
  $stderr.puts '  --help, -h                print this message'
  exit(1)
end

if ARGV.length == 0
  help!
end

opts = GetoptLong.new(
  [ '--gatype','-G', GetoptLong::REQUIRED_ARGUMENT],
  [ '--steadystatechange','-r', GetoptLong::REQUIRED_ARGUMENT],
  [ '--maxgen','-g', GetoptLong::REQUIRED_ARGUMENT],
  [ '--mutationrate','-m', GetoptLong::REQUIRED_ARGUMENT],
  [ '--crossoverrate','-c', GetoptLong::REQUIRED_ARGUMENT],
  [ '--inversionrate','-i', GetoptLong::REQUIRED_ARGUMENT],
  [ '--populationsize','-p', GetoptLong::REQUIRED_ARGUMENT],
  [ '--crossovertype','-t', GetoptLong::REQUIRED_ARGUMENT],
  [ '--help','-h', GetoptLong::NO_ARGUMENT]
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
    raise "Invalid number of Maximum Generations: #{arg} is not a valid input" if arg.to_f <= 0
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
    raise "Invalid size of population: #{arg} is not a valid input" if arg.to_i <= 0
    population = arg.to_i
  when '--crossovertype'
    raise "Invalid type of crossover: #{arg} is not a valid input" if arg.to_i != 1 && arg.to_i != 2
    ctype = arg.to_i
  when '--help'
    help!
  end
end

hp_seq = ARGV[0].downcase

pop = Pop.new(hp_seq,population).generate

start = Time.now
if gatype==0
  standard = StandardGA.new(hp_seq,pop,maxgen,mutation,crossover,inversion,ctype)
  bestcanidate,bestfitness = standard.run
else
  steadystate = SteadyStateGA.new(hp_seq,pop,maxgen,mutation,crossover,inversion,ctype,sschange)
  bestcanidate,bestfitness = steadystate.run
end
endt = Time.now

puts "Solution: #{bestcanidate} #{bestfitness}"
puts "Time: #{endt-start}"

display = Display.new(hp_seq,bestcanidate)
display.display
