require_relative 'board.rb'

class Game

    def initialize
        # creates an empty board of a player specified size
        @size = get_size
        @board = Board.new(@size)

        # generates the placement of bombs and other tiles
        @board.plant_bombs(self.get_num_bombs)
        @board.gen_tiles
    end

    def get_size
        size = 0

        while size < 2
            puts "How big would you like the board to be? For example, put '9' for a 9x9 grid. The grid must be at least 2x2."
            size = gets.chomp.to_i
        end

        size
    end

    def get_num_bombs
        num_bombs = 0

        while num_bombs < 1 || num_bombs > @size ** 2
            puts "How many bombs would you like to plant?"
            num_bombs = gets.chomp.to_i
        end

        num_bombs
    end

    def run
        while !self.won? && !self.lost?
            @board.render
            self.play_turn
        end
    end

    def play_turn
        location = []

        while !valid_location?(location)
            puts "Enter the position you want to select in the format 'x,y':"
            location = process_location_input(gets.chomp)
        end

        @board.flip_tiles(location)
    end

    def process_location_input(string)
        location = string.split(',')
        location[0], location[1] = location[1].to_i, location[0].to_i
    end

    def valid_location?(location)
        if location.length == 2
            location.each { |coordinate| return false if coordinate < 0 || coordinate > @size }
            true
        else
            false
        end
    end

    def won?
        @board.all_tiles_revealed?
    end

    def lost?
        @board.bomb_revealed?
    end

end

game = Game.new

game.run