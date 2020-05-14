require_relative 'board.rb'

class Game

    def initialize
        # Creates an empty board of a player specified size
        @size = get_size
        @board = Board.new(@size)

        # Generates the placement of bombs and other tiles
        @board.plant_bombs(self.get_num_bombs)
        @board.gen_tiles
    end

    # Allow the player to choose the size of the board
    def get_size
        size = 0

        while size < 2
            puts "How big would you like the board to be? For example, put '9' for a 9x9 grid. The grid must be at least 2x2."
            size = gets.chomp.to_i
        end

        size
    end

    # Allow the player to choose the number of bombs
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
        @board.render
    end

    def play_turn
        location = []
        action = ''

        while !valid_location?(location)
            puts "Enter the position you want to select in the format 'x,y':"
            location = process_location_input(gets.chomp)
        end

        while !valid_action(action)
            puts "What would you like to do? Enter 'r' to reveal the tile or 'f' to flag the tile as a bomb."
            puts "If you would like to remove a flag from the tile, enter 'u'."

            action = (gets.chomp.downcase)
        end

        if action == "r"
            @board.flip_tiles(location)
        elsif action == "f"
            @board.flag_tile(location)
        else
            @board.unflag_tile(location)
        end
    end

    # Converts string to an array of integers. Integers must be swapped in order to work as "x,y" instead of "y,x"
    def process_location_input(string)
        location = string.split(',')
        location.map!(&:to_i)

        if valid_location?(location)
            location[0], location[1] = location[1], location[0]
        end

        location
    end

    # Make sure the location given matches a space on the board
    def valid_location?(location)
        if location.length == 2
            begin
                location.each { |coordinate| return false if coordinate < 0 || coordinate > @size }
                true
            rescue
                false
            end
        else
            false
        end
    end

    # Make sure the user has specified an existing action
    def valid_action(action)
        return true if action == "r" || action == "f" || action == "u"
        false
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