require_relative "tile.rb"
require 'byebug'

class Board

    attr_reader :grid

    def initialize(size)
        @grid = Array.new(size) { Array.new(size) }
        @grid_size = size
    end

    def render
        @grid.each do |row|
            display = []
            row.each do |tile|
                if tile.faceup
                    display << tile.value
                else
                    display << tile.back
                end
            end
            puts display.join(" ")
        end
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
            count += check_row([x, y])
            x += 1
        end
        count
    end

    def check_row(location)
        x, y = location[0], location[1]
        squares_to_count = 3
        count = 0

        return count if x < 0 || x >= @grid_size

        while y < 0
            y += 1
            squares_to_count -= 1
        end

        while y >= @grid_size
            y -= 1
            squares_to_count -= 1
        end

        squares_to_count.times do
            if @grid[x][y]
                count += 1 if @grid[x][y].is_bomb?
            end

            y += 1
        end
        
        count
    end
end

board = Board.new(9)

board.plant_bombs(10)
board.gen_tiles

board.render