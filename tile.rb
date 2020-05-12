require 'colorize'

class Tile

    attr_accessor :value

    attr_reader :bomb

    def initialize(is_bomb, value)
        @bomb = is_bomb
        @value = colour_value(value)
        @faceup = false
        @tile_back = " ".colorize(:background => :light_black)
    end

    def reveal
        @faceup = true
    end

    def is_bomb?
        @bomb
    end

    def colour_value(value)
        colours = { 1 => :blue, 2 => :light_magenta, 3 => :magenta, 4 => :green, 5 => :cyan,
                    6 => :yellow, 7 => :yellow, 8 => :light_red }

        return value.colorize(:red).on_white if self.is_bomb?
        return " ".colorize(:background => :white) if value == 0

        value.to_s.colorize(colours[value]).on_white
    end

end