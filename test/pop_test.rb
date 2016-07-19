require 'test_helper'

class PopTest < Minitest::Test

  def test_returns_nil_population_for_sequence_of_length_1
    hp_sequence = 'h'
    size = 1

    population = Pop.new(hp_sequence, size).generate
    assert_equal [nil], population
  end

  def test_returns_candidates_with_length_1_less_than_hp_sequence
    hp_sequence = 'hp'
    size = 1

    population = Pop.new(hp_sequence, size).generate
    candidate = population.first
    assert_equal 1, candidate.size
  end

  def test_returns_all_candidates_that_do_not_conflict_for_large_population
    hp_sequence = 'hph'
    size = 100

    population = Pop.new(hp_sequence, size).generate
    expected_population = %w(uu ul ur dd dl dr lu ld ll rr ru rd).sort
    assert_equal expected_population, population.sort.uniq
  end

end
