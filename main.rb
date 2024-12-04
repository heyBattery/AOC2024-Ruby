data = []

File.foreach('input.txt').with_index do |line, linenum|
    data.push(line.chars)
end

def search(word, x_index, y_index, direction, grid)
  if grid[y_index][x_index] != word[0]
    return 0
  end
  if word.length == 1
    return 1
  end
  return search(word[1,word.length], x_index + direction[0], y_index + direction[1], direction, grid)
end

matches = 0
data.each_with_index do |row, row_index|
  row.each_with_index do |rowchar, col_index|
    # search right
    if col_index < row.length-3
      matches += search('XMAS', col_index, row_index, [1,0], data)
      matches += search('SAMX', col_index, row_index, [1,0], data)
    end
    # search down
    if row_index < data.length-3
      matches += search('XMAS', col_index, row_index, [0,1], data)
      matches += search('SAMX', col_index, row_index, [0,1], data)
    end
    # search diagonal-right
    if col_index < row.length-3 && row_index < data.length-3
      matches += search('XMAS', col_index, row_index, [1,1], data)
      matches += search('SAMX', col_index, row_index, [1,1], data)
    end
    # search diagonal-left
    if col_index >= 3 && row_index < data.length-3
      matches += search('XMAS', col_index, row_index, [-1,1], data)
      matches += search('SAMX', col_index, row_index, [-1,1], data)
    end
  end
end


puts "matches: #{matches}"