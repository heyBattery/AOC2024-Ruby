## todo need to record direction of travel
## collision detection is not about explicit hit then obstacle when looking ahead
##   actually need hit *or* next direction then obstacle

## need to walk through regular path but each step walk it out and check for a cycle


def on_map(point)
  return point[0] >= 0 && point[0] < $max_boundary[0] && point[1] >= 0 && point[1] < $max_boundary[1]
end

$map_area = []
$direction_cycle = [
  [0,-1], #up
  [1,0], #right
  [0,1], #down
  [-1,0], #left
]

$guard_direction = -1
$original_position = [0,0]
$guard_position = [0,0]
$spaces_touched = 0
$obstruction_points = []
File.foreach('input.txt').with_index do |line, linenum|
  guard_x = line.index(/[\^v<>]/)
  if guard_x != nil
    $guard_position = [guard_x, linenum]
    $original_position = [guard_x, linenum]
    case line[guard_x]
    when '^'
      $guard_direction = 0
    when '>'
      $guard_direction = 1
    when 'v'
      $guard_direction = 2
    when '<'
      $guard_direction = 3
    end
    line[guard_x] = 'X'
    $spaces_touched += 1
  end

  $map_area.push(line.chomp().chars)
end

$max_boundary = [$map_area[0].length, $map_area.length]

def peek(pos, dir)
  target = [pos[0]+dir[0], pos[1]+dir[1]]
  unless on_map(target)
    return nil
  end
  peeked = $map_area[target[1]][target[0]]
  return peeked
end

def find_collision(origin, dir)
  move = $direction_cycle[dir]
  cycle_direction = (dir+1) % $direction_cycle.length
  current_pos_val = $map_area[origin[1]][origin[0]]
  next_pos = [origin[0] + move[0], origin[1]+move[1]]
  while on_map(next_pos)
    next_pos_val = $map_area[next_pos[1]][next_pos[0]]
    if next_pos_val == '#' && current_pos_val.index("#{cycle_direction}") != nil
      # puts "found point from #{origin} looking #{move}"
      return true
    end
    current_pos_val = next_pos_val
    next_pos = [next_pos[0]+move[0],next_pos[1]+move[1]]
  end
  return false
end

while true
  move = $direction_cycle[$guard_direction]
  next_position = peek($guard_position, move)
  case next_position
  when nil
    break
  when '.'
    $guard_position = [$guard_position[0]+move[0], $guard_position[1]+move[1]]
    $map_area[$guard_position[1]][$guard_position[0]] = "#{$guard_direction}"
    $spaces_touched += 1
    if find_collision($guard_position, ($guard_direction+1) % $direction_cycle.length)
      $obstruction_points.push("#{$guard_position[0]+move[0]},#{$guard_position[1]+move[1]}")
    end
  when '#'
    new_dir = ($guard_direction+1) % $direction_cycle.length
    # $map_area[$guard_position[1]][$guard_position[0]] = '!'
    $guard_direction = new_dir
    $map_area[$guard_position[1]][$guard_position[0]] = $map_area[$guard_position[1]][$guard_position[0]]+ "#{$guard_direction}"
  else
    $guard_position = [$guard_position[0]+move[0], $guard_position[1]+move[1]]
    $map_area[$guard_position[1]][$guard_position[0]] = $map_area[$guard_position[1]][$guard_position[0]]+ "#{$guard_direction}"
    if find_collision($guard_position, ($guard_direction+1) % $direction_cycle.length)
      $obstruction_points.push("#{$guard_position[0]+move[0]},#{$guard_position[1]+move[1]}")
    end
  end
end

$map_area.each do |row|
  puts "#{row}"
end
puts "touched: #{$spaces_touched}"
total_positions = $obstruction_points.uniq().length
if $obstruction_points.index("#{$original_position[0]},#{$original_position[1]}") != nil
  puts "PARADOX!"
  total_positions -= 1
end
puts "obstructions: #{total_positions}"
#1603 too high
#1557 wrong
#1567 wrong