require 'yaml'
require_relative 'board.rb'

class Game

    def initialize
        # Create an array containing all filenames of saved games
        @saved_games = self.all_saves

        # Ask user whether to start a new game or to load one. If loading a saved file fails, quit the program
        if self.new_game?
            self.start_new_game
        else
            self.quit if !self.load_game
        end
    end

    # Ask user whether to start a new game or load a saved game
    def new_game?
        valid_actions = ['n', 'l']
        input = ''

        while !valid_action(input, valid_actions)
            puts "Enter 'N' to start a new game, or 'L' to load a saved game:"
            input = gets.chomp.downcase
        end

        if input == 'l'
            false
        elsif input == 'n'
            true
        end
    end

    def start_new_game
        # Create an empty board of a player specified size
        @size = get_size
        @board = Board.new(@size)

        # Generate the placement of bombs and other tiles
        @board.plant_bombs(self.get_num_bombs)
        @board.gen_tiles
    end

        # Attempt to load a save file with a name given by the user. If successful, initialise @board and @size
    # from the file. Inform user and return false if not.
    def load_game
        puts "Enter the name of your save file:"
        name = gets.chomp.downcase

        if @saved_games.include?(name)
            file = YAML.load_file("./saves/#{name}.yaml")
            @board = file[:board]
            @size = @board.grid_size
            true
        else
            puts "Save file not found."
            false
        end
    end

    # Save game into a YAML file with a name given by the user
    def save_game
        puts "Enter the name you want to save your game under:"
        name = gets.chomp.downcase

        file_name = name + ".yaml"
        file_path = File.join("./saves", file_name)
        data = { :board => @board }

        File.open(file_path, 'w') { |file| file.write(data.to_yaml) }
    end

    # Load the names of all current save files into an array
    def all_saves
        files = Dir.glob('**/*.yaml')
        filenames = files.map { |file| /[saves\/](\w+)[.yaml]/.match(file) }
    
        filenames.map { |name| name.to_a[1] }
    end

    def quit
        exit
    end

    # Allow the player to choose the size of the board
    def get_size
        size = 0

        while size < 2 || size > 20
            puts "How big would you like the board to be? For example, put '9' for a 9x9 grid. Pick a number between 2 and 20."
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
        self.end_game
    end

    def play_turn
        messages = ["", "What would you like to do?", "", "R: Reveal tile", "F: Flag tile as a bomb",
            "U: Remove flag from tile", "S: Save game", "Q: Quit"]
        valid_actions = ['r', 'f', 'u', 's', 'q']
        location = []
        action = ''

        while !valid_action(action, valid_actions)
            messages.each { |message| puts message }

            action = (gets.chomp.downcase)
        end

        # Allow player to save and quit without choosing a location
        if action == "s"
            self.save_game
            return
        elsif action == "q"
            self.quit
        end

        while !valid_location?(location)
            puts "Enter the position you want to select in the format 'x,y':"
            location = gets.chomp

            # Allow player to quit in the middle of a turn
            if location.downcase == "q"
                self.quit
            end

            location = process_location_input(location)
        end

        if action == "r"
            @board.flip_tiles(location)
        elsif action == "f"
            @board.flag_tile(location)
        elsif action == "u"
            @board.unflag_tile(location)
        elsif action == "s"
            self.save_game
        elsif action == "q"
            self.quit
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
    def valid_action(action, valid_actions)
        return true if valid_actions.include?(action)
        false
    end

    def won?
        @board.all_tiles_revealed?
    end

    def lost?
        @board.bomb_revealed?
    end

    def end_game
        if self.won?
            puts ""
            puts "You win!"
        else
            puts ""
            puts "You lose!"
        end
    end

end

game = Game.new

game.run