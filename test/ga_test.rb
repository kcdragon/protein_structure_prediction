require 'test_helper'

class GaTest < Minitest::Test

  def test_standard_genetic_algorithm_with_crossover_type_1
    hp_seq = 'hphpphhphpphphhpphph'
    population = Pop.new(hp_seq, 200).generate

    fitness = 4.times.map do
      candidate, fitness = StandardGA.new(hp_seq, population).run
      fitness
    end.max
    assert_equal 9, fitness
  end

  def test_standard_genetic_algorithm_with_crossover_type_2
    hp_seq = 'hphpphhphpphphhpphph'
    population = Pop.new(hp_seq, 200).generate

    fitness = 4.times.map do
      candidate, fitness = StandardGA.new(hp_seq, population, ctype: 2).run
      fitness
    end.max
    assert_equal 9, fitness
  end
end
