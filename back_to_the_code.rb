STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.

@opponent_count = gets.to_i # Opponent count

module Mode
    ROUND = 0
    FIND = 1
end

module Direction
    UP = 0
    DOWN = 1
    LEFT = 2
    RIGHT = 3
    NONE = 4
end

def up_state(ary, x, y)
    if y == 0
        return nil
    end
    ary[y-1][x]
end

def down_state(ary, x, y)
    if y == 19
        return nil
    end
    ary[y+1][x]
end

def left_state(ary, x, y)
    if x == 0
        return nil
    end
    ary[y][x-1]
end

def right_state(ary, x, y)
    if x == 34
        return nil
    end
    ary[y][x+1]
end

def get_4_direction(field_ary, x, y)
    [up_state(field_ary, x, y), down_state(field_ary, x, y), left_state(field_ary, x, y), right_state(field_ary, x, y)]
end

def change_direction(field_ary, x, y, direction)
    up, down, left, right = get_4_direction(field_ary, x, y)
    if up != '.' and down != '.' and left != '.' and right != '.'
        return Direction::NONE
    end
    
    d = Direction::NONE
    if direction === Direction::UP or direction === Direction::DOWN
        free_left = 0
        free_right = 0
        for i in 0...field_ary.length do
           for j in 0...field_ary[i].length do
               if field_ary[i][j] == '.'
                   if j < x
                       free_left += 1
                   elsif x < j
                       free_right += 1
                   end
               end
           end
        end
        if free_left > free_right
            d = Direction::LEFT
        else
            d = Direction::RIGHT
        end
    else
        free_up = 0
        free_down = 0
        for i in 0...field_ary.length do
            for j in 0...field_ary[i].length do
                if field_ary[i][j] == '.'
                    if i < y
                        free_up += 1
                    elsif y < i
                        free_down += 1
                    end
                end
            end
        end
        STDERR.puts free_up
        STDERR.puts free_down
        if free_up > free_down
            d = Direction::UP
        else
            d = Direction::DOWN
        end
    end
    
    d    
    # if up_state(field_ary, x, y) == '.'
    #     direction = Direction::UP
    # elsif down_state(field_ary, x, y) == '.'
    #     direction = Direction::DOWN
    # elsif right_state(field_ary, x, y) == '.'
    #     direction = Direction::RIGHT
    # elsif left_state(field_ary, x, y) == '.'
    #     direction = Direction::LEFT
    # else
    #     direction = Direction::NONE
    # end
end

def is_collision(field_ary, x, y, direction)
    case direction
    when Direction::UP
        if up_state(field_ary, x, y) != '.'
            true
        else
            false
        end
    when Direction::DOWN
        if down_state(field_ary, x, y) != '.'
            true
        else
            false
        end
    when Direction::LEFT
        if left_state(field_ary, x, y) != '.'
            true
        else
            false
        end
    when Direction::RIGHT
        if right_state(field_ary, x, y) != '.'
            true
        else
            false
        end
    when Direction::NONE
        true
    end
end

def decide_direction(field_ary, x, y, direction)

end

def move(direction, x, y)
    case direction
    when Direction::UP
        move_x = x
        move_y = y - 1
    when Direction::DOWN
        move_x = x
        move_y = y + 1
    when Direction::LEFT
        move_x = x - 1
        move_y = y
    when Direction::RIGHT
        move_x = x + 1
        move_y = y
    when Direction::NONE
        move_x = rand(35)
        move_y = rand(20)
    end
    [move_x, move_y]
end

def find_free(field_ary, x, y, opponent_ary)
    distance = nil
    move_x, move_y = 0
    free_field_point_ary = Array.new
    for i in 0...field_ary.length do
       for j in 0...field_ary[i].length do
           if field_ary[i][j] == '.'
               free_field_hash = Hash.new
               free_field_hash[:x] = j
               free_field_hash[:y] = i
               free_field_point_ary << free_field_hash
               dx = j - x
               dy = i - y
               d = Math.sqrt(dx * dx + dy * dy)
               if distance == nil
                   distance = d
                   move_x = j
                   move_y = i
                   next
               end
               if distance > d
                   distance = d
                   move_x = j
                   move_y = i
               end
           else
               next
           end
       end
    end
    
    distination = nil
    opponent_ary.each do |o_x, o_y|
       if o_x == x && o_y == y
           distination = rand(free_field_point_ary.length)
           break
       end
    end
    if distination != nil
        move_x = free_field_point_ary[distination].x
        move_y = free_field_point_ary[distination].y
    end
    
    return move_x, move_y
end

move_x = 0
move_y = 0
direction = Direction::UP
mode = Mode::ROUND
# game loop
loop do
    game_round = gets.to_i
    # x: Your x position
    # y: Your y position
    # back_in_time_left: Remaining back in time
    x, y, back_in_time_left = gets.split(" ").collect {|x| x.to_i}
    opponent_ary = Array.new
    @opponent_count.times do
        # opponent_x: X position of the opponent
        # opponent_y: Y position of the opponent
        # opponent_back_in_time_left: Remaining back in time of the opponent
        opponent_x, opponent_y, opponent_back_in_time_left = gets.split(" ").collect {|x| x.to_i}
        opponent = {}
        opponent[:x] = opponent_x
        opponent[:y] = opponent_y
        opponent[:back] = opponent_back_in_time_left
        opponent_ary << opponent
    end
    field_ary = Array.new
    20.times do
        line = gets.chomp # One line of the map ('.' = free, '0' = you, otherwise the id of the opponent)
        field_ary << line
    end
    
    # Write an action using puts
    # To debug: STDERR.puts "Debug messages..."
    STDERR.puts x,y 
    STDERR.print "up: "
    STDERR.puts up_state(field_ary, x, y)
    STDERR.print "down: "
    STDERR.puts down_state(field_ary, x, y)
    
    # action: "x y" to move or "BACK rounds" to go back in time
    
    if mode == Mode::FIND
        if move_x == x and move_y == y
            mode = Mode::ROUND
        else
            #move_x, move_y = find_free(field_ary, x, y, opponent_ary)
        end
    end
    
    if mode == Mode::ROUND
        collision = is_collision(field_ary, x, y, direction)
        if collision
            direction = change_direction(field_ary, x, y, direction)
        end
        STDERR.print 'direction'
        STDERR.puts direction
        
        if direction == Direction::NONE
            mode = Mode::FIND
            move_x, move_y = find_free(field_ary, x, y, opponent_ary)
        else
            move_x, move_y = move(direction, x, y)
        end
    end
    
    puts "#{move_x} #{move_y}"
end