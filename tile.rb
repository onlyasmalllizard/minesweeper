class Tile

    attr_accessor :value

    attr_reader :bomb

    def initialize(is_bomb, value)
        @bomb = is_bomb
        @value = value
        @faceup = false
    end

    def reveal
        @faceup = true
    end

    def is_bomb?
        @bomb
    end

end