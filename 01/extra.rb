left = Hash.new
right = Hash.new

def aggregate(hash, val)
  if hash.has_key?(val)
    hash[val] = hash[val] + 1
  else
    hash[val] = 1
  end
end

File.foreach('input.txt').with_index do |line, linenum|
    nums = line.split()
    aggregate(left, Integer(nums[0]))
    aggregate(right, Integer(nums[1]))
end

similarity = 0
left.keys.each do |value|
  if right.has_key?(value)
    similarity += value * left[value] * right[value]
  end
end

puts "total: #{similarity}"