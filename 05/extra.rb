fail_conditions = Hash.new
comes_after = Hash.new

def is_valid(pages, fails)
  if pages.length > 2
    valid = true
    (1..pages.length).each do |page_index|
      valid &= is_valid([pages[0],pages[page_index]], fails)
    end
    subset = pages.reject.with_index{|v, i| i == 0 }
    valid &= is_valid(subset, fails)
    return valid
  else
    key = "#{pages[0]}|#{pages[1]}"
    hit = fails.has_key?(key)
    # puts "checking #{key} - #{hit ? 'HIT' : 'MISS'}"
    return !hit
  end
end

def repair(pages, following_rules)
  repaired = []
  pages.each do |page|
    if !following_rules.has_key?(page) || repaired.length == 0
      #send to beginning if it doesn't have to follow any page
      repaired.unshift(page)
    else
      puts "inserting #{page}"
      puts "#{page} must come after #{following_rules[page]}"
      insert_index = following_rules[page].map {|p| repaired.find_index(p) || -1}.max + 1
      puts "insert #{page} at index #{insert_index}"
      repaired.insert(insert_index, page)
    end
  end
  return repaired
end

parsing_rules = true;
correct_aggregate = 0;
fixed_aggregate = 0;
File.foreach('input.txt').with_index do |line, linenum|
  if line.chomp() == '' then
    parsing_rules = false
    next
  end

  if parsing_rules
    # read rules
    values = line.chomp().split('|')
    unless comes_after.has_key?(values[1])
      comes_after[values[1]] = []
    end
    comes_after[values[1]].push(values[0])
    bad_key = "#{values[1]}|#{values[0]}"
    fail_conditions[bad_key] = false #value doesn't matter, just doing key lookups
  else
    puts "evaluating #{line}"
    pages = line.chomp().split(',')
    middle_page = pages[pages.length/2]

    valid = is_valid(pages, fail_conditions)
    puts "is valid? #{valid}"

    if valid
      correct_aggregate += middle_page.to_i
    else
      # correct the order
      fixed_pages = repair(pages, comes_after)
      puts "reordered: #{fixed_pages}"

      fixed_aggregate += fixed_pages[fixed_pages.length/2].to_i
    end
  end

end
# puts "fail conditions #{fail_conditions}"
puts "rules #{comes_after}"
puts "total: #{correct_aggregate}"
puts "total: #{fixed_aggregate}"