require 'colorize'

class Tile

    attr_reader :back, :value

    def initialize(is_bomb, value)
        @bomb = is_bomb
        @value = colour_value(value)
        @faceup = false
        @back = " ".colorize(:background => :light_black)
        @flagged = false
    end

    def reveal
        @faceup = true
    end

    def is_bomb?
        @bomb
    end

    # Sets colour of tile based on value displayed. Tiles with a value of 0 are made blank in order
    # in order to reduce visual clutter
    def colour_value(value)
        colours = { "!" => :red, 1 => :blue, 2 => :light_magenta, 3 => :magenta, 4 => :green, 5 => :cyan,
                    6 => :yellow, 7 => :yellow, 8 => :light_red }

        return " ".colorize(:background => :white) if value == 0

        value.to_s.colorize(colours[value]).on_white
    end

    def flag
        @flagged = true
    end

    def unflag
        @flagged = false
    end

    def flagged?
        @flagged
    end

    def faceup?
        @faceup
    end

end