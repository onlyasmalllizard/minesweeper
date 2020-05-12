require_relative "tile.rb"
require 'byebug'

class Board

    attr_reader :grid

    def initialize(size)
        @grid = Array.new(size) { Array.new(size) }
        @grid_size = size
    end

    def render
        system('clear')
        display = []

        # translate game data into on screen representation
        @grid.each do |row|
            line = []
            row.each do |tile|
                if tile.faceup
                    line << tile.value
                else
                    line << tile.back
                end
            end
            display << line
        end

        # add coordinates and formatting
        i = 0
        upper_coordinates = []
        horizontal_line = []

        while i < @grid_size
            upper_coordinates << i
            horizontal_line << "_"
            display[i].unshift(i, "|")
            i += 1
        end

        upper_coordinates.unshift(" ", " ")
        horizontal_line.unshift("_", "_")
        display.unshift(upper_coordinates, horizontal_line)

        # render board on screen
        display.each { |row| puts row.join(" ") }
    end

    def plant_bombs(num_bombs)
        num_bombs.times do
            position = gen_rand_pos
            @grid[position[0]][position[1]] = Tile.new(true, "!")
        end
    end

    def gen_tiles
        @grid.each_with_index do |row, row_id|
            row.each_with_index do |tile, col_id|
                value = count_bombs([row_id, col_id])
                @grid[row_id][col_id] = Tile.new(false, value) if !tile
            end
        end
    end

    def gen_rand_pos
        [rand(@grid_size), rand(@grid_size)]
    end

    def count_bombs(location)
        x, y = location[0] - 1, location[1] - 1
        count = 0
            
        3.times do
            count += count_bombs_in_row([x, y])
            x += 1
        end
        count
    end

    def count_bombs_in_row(location)
        x, y = location[0], location[1]
        squares_to_count = 3
        count = 0

        return count if x < 0 || x >= @grid_size
        adjustments_needed = self.adjust_squares_to_check(squares_to_count, y)

        squares_to_count, y = adjustments_needed[0], adjustments_needed[1]

        squares_to_count.times do
            if @grid[x][y]
                count += 1 if @grid[x][y].is_bomb?
            end

            y += 1
        end
        
        count
    end

    def all_tiles_revealed?
        @grid.each do |row|
            row.each { |tile| return false if !tile.is_bomb? && !tile.faceup }
        end

        true
    end

    def bomb_revealed?
        @grid.each do |row|
            row.each { |tile| return true if tile.is_bomb? && tile.faceup }
        end

        false
    end

    def flip_tiles(location)
        x, y = location[0], location[1]
    
        @grid[x][y].reveal

        if !@grid[x][y].is_bomb? && !self.nearby_bomb?(location)
            # determine how many rows we have to check and which x-coodinate to begin with
            num_rows_details = adjust_squares_to_check(3, x - 1)
            num_rows, working_x = num_rows_details[0], num_rows_details[1]

            # determine how long each row is. the starting y-coordinate stays in row_details for later
            row_details = adjust_squares_to_check(3, y)
            row_length = row_details[0]

            num_rows.times do
                working_y = row_details[1]
                row_length.times do
                    flip_tiles([working_x, working_y])
                    working_y += 1
                end
                working_x += 1
            end
        end
    end

    def nearby_bomb?(location)
        if count_bombs(location) > 0
            true
        else
            false
        end
    end

    def adjust_squares_to_check(num_to_check, coordinate)
        while coordinate < 0
            coordinate += 1
            num_to_check -= 1
        end

        while coordinate >= @grid_size
            coordinate -= 1
            num_to_check -= 1
        end

        [num_to_check, coordinate]
    end
end