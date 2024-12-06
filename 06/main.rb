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
$guard_position = [0,0]
$spaces_touched = 0
File.foreach('input.txt').with_index do |line, linenum|
  guard_x = line.index(/[\^v<>]/)
  if guard_x != nil
    $guard_position = [guard_x, linenum]
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

while true
  move = $direction_cycle[$guard_direction]
  next_position = peek($guard_position, move)
  case next_position
  when nil
    break
  when '.'
    $guard_position = [$guard_position[0]+move[0], $guard_position[1]+move[1]]
    $map_area[$guard_position[1]][$guard_position[0]] = 'X'
    $spaces_touched += 1
  when 'X'
    $guard_position = [$guard_position[0]+move[0], $guard_position[1]+move[1]]
  when '#'
    new_dir = ($guard_direction+1) % $direction_cycle.length
    $guard_direction = new_dir
  end
end

puts "touched: #{$spaces_touched}"