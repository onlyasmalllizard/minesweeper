class Tile

    attr_accessor :value

    def initialize(is_bomb)
        @bomb = is_bomb
        @value = determine_value
    end

    def determine_value
        return "!" if @bomb

        " "
    end

end