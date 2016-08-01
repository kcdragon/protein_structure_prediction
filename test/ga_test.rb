require 'test_helper'

class GaTest < Minitest::Test

  def test_standard_genetic_algorithm_with_crossover_type_1
    hp_seq = 'hphpphhphpphphhpphph'
    population = Pop.new(hp_seq, 200).generate
    maxgen = 100
    mutation = 0.1
    crossover = 0.6
    inversion = 0
    ctype = 1

    candidate, fitness = StandardGA.new(hp_seq, population, maxgen, mutation, crossover, inversion, ctype).run
    assert_equal 9, fitness
  end

  def test_standard_genetic_algorithm_with_crossover_type_2
    hp_seq = 'hphpphhphpphphhpphph'
    population = Pop.new(hp_seq, 200).generate
    maxgen = 100
    mutation = 0.1
    crossover = 0.6
    inversion = 0
    ctype = 2

    candidate, fitness = StandardGA.new(hp_seq, population, maxgen, mutation, crossover, inversion, ctype).run
    assert_equal 9, fitness
  end
end
