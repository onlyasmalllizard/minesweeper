require_relative "tile.rb"
require 'byebug'

class Board

    attr_reader :grid

    def initialize
        @grid = Array.new(9) { Array.new(9) }
    end

    def render
        @grid.each do |row|
            display = []
            row.each { |tile| display << tile.value }
            puts display.join(" ")
        end
    end

    def plant_bombs(num_bombs)
        num_bombs.times do
            position = gen_rand_pos(9)
            @grid[position[0]][position[1]] = Tile.new(true)
        end
    end

    def gen_tiles
        @grid.each_with_index do |row, row_id|
            row.each_with_index do |tile, col_id|
                @grid[row_id][col_id] = Tile.new(false) if !tile
            end
        end
    end

    def gen_rand_pos(board_size)
        [rand(board_size), rand(board_size)]
    end
end

board = Board.new

board.plant_bombs(10)
board.gen_tiles

board.render