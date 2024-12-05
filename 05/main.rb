fail_conditions = Hash.new

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

parsing_rules = true;
correct_aggregate = 0;
File.foreach('input.txt').with_index do |line, linenum|
  if line.chomp() == '' then
    parsing_rules = false
    next
  end

  if parsing_rules
    # read rules
    values = line.chomp().split('|')
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
    end
  end

end
# puts "fail conditions #{fail_conditions}"
puts "total: #{correct_aggregate}"