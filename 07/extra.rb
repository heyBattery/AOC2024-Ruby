total = 0

def permutations(factors)
  if factors.length == 2
    return [factors[0] + factors[1], factors[0] * factors[1], "#{factors[0]}#{factors[1]}".to_i]
  else
    tail = factors.pop
    possible_values = permutations(factors)
    return possible_values.map {|val| [val+tail, val*tail, "#{val}#{tail}".to_i]}.flatten
  end
end


File.foreach('input.txt').with_index do |line, linenum|
  values = line.split(':')
  target = values[0].to_i
  factors = values[1].chomp.split.map {|str| str.to_i}
  # puts "targeting #{target} using #{factors}"
  perms = permutations(factors)
  # puts "perms #{perms}"
  if perms.index(target) != nil
    total += target
  end
end

puts "total: #{total}"