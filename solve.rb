require_relative 'solver'

print 'How long is the puzzle (letters)? '
size = gets.chomp.to_i

solver = Solver.new size: size

1.upto(size).each do |n|
  print "Enter the letters at position #{n} (without spaces): "
  letters = gets.chomp.each_char.map(&:downcase)
  solver.add_letters n, letters
end

solver.solve!

puts "Found #{solver.words.count} matching words."
puts solver.words

puts "Solution:"
puts solver.least_words_covering_letters