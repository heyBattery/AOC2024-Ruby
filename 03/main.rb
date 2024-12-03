input = File.read("input.txt")
mul_regex = /(mul\((\d+),(\d+)\))/

matches = input.scan(mul_regex)

total = 0
matches.each do |m|
  total += m[1].to_i * m[2].to_i
end

puts "total #{total}"
