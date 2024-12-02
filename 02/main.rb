def is_safe(nums)
  global_ascending = nums[1] - nums[0] > 0 ? true : false

  (1...nums.length).each do |index|
    diff = nums[index] - nums[index-1]
    # puts "check #{nums[index-1]} #{nums[index]} (#{index})"
    local_ascending = diff > 0
    if diff.abs > 3 || diff == 0 || global_ascending ^ local_ascending
      return false
    end
  end
  return true
end


numsafe = 0
File.foreach('input.txt').with_index do |line, linenum|
  nums = line.split().map {|str| str.to_i}

  if is_safe(nums)
    numsafe += 1
  end
end

puts "safe: #{numsafe}"