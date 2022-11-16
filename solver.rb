class Solver
  attr_reader :size

  def initialize(size:)
    @size = size
    @letters = 1.upto(size).map{|n| [n, []]}.to_h
    @all_words = read_wordlist_file
    @words = []
  end

  def add_letters(position, letters)
    @letters[position] += letters.map(&:downcase)
  end

  def find_next_word(solution)
    candidate_words = @words.clone
    0.upto(size - 1).each do |index|
      next_candidate_words = candidate_words.clone
      solution.each do |solution_word|
        next_candidate_words.delete_if do |candidate_word|
          candidate_word[index] == solution_word[index]
        end 
      end
      if next_candidate_words.empty?
        break
      else candidate_words = next_candidate_words
      end
    end
    candidate_words.sample
  end

  def least_words_covering_letters
    solutions = @words.map{|word| Array(word) }
    solution = nil
    while (solution = solutions.find(&method(:covers_all_letters?))).nil?
      next_round_solutions = []
      solutions.each do |solution|
        next_round_solution = solution + [find_next_word(solution)]
        next_round_solutions << next_round_solution
      end
      solutions = next_round_solutions
    end
    solution
  end

  def read_wordlist_file
    File.readlines('wordlist-20210729.txt').map do |entry|
      entry.strip.gsub '"', ''
    end.select do |word|
      word.length == @size
    end
  end

  def solve!
    check_size!
    @words = @all_words.select do |word|
      word.each_char.with_index.all? do |char, index|
        @letters[index + 1].include? char
      end
    end
  end

  def words
    @words.clone
  end

  private

  def check_size!
    1.upto(@size) do |n|
      if @letters[n].empty?
        fail "No letters entered for position #{n}!"
      end
    end
  end

  def covers_all_letters?(solution)
    @letters.each_pair.all? do |position, letters|
      index = position - 1
      letters.all? do |letter|
        solution.any? do |word|
          word[index] == letter
        end
      end
    end
  end
end