left = []
right = []

File.foreach('input.txt').with_index do |line, linenum|
    puts "reading?"
    nums = line.split()
    left.push(Integer(nums[0]))
    right.push(Integer(nums[1]))
end
puts "#{left.length} lines"
left.sort!()
right.sort!()

diff = 0
left.each_with_index do |num, index|
    puts "#{left[index]} #{right[index]}"
    diff += (left[index] - right[index]).abs
end

puts "total: #{diff}"