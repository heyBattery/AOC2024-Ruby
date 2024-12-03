input = File.read("input.txt")
mul_regex = /(mul\((\d+),(\d+)\)|do\(\)|don't\(\))/

matches = input.scan(mul_regex)

total = 0
add = true
matches.each do |m|
  if m[0] == "do()"
    add = true
  elsif m[0] == "don't()"
    add = false
  elsif add
    total += m[1].to_i * m[2].to_i
  end
end

puts "total #{total}"
