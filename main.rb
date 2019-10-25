

class Node
    attr_reader :position
    attr_accessor :value
    
    def initialize(position,value = " ")
        @position = position
        @value = value
    end
end

class Player
    attr_accessor :winner
    attr_reader :symbol
    def initialize(symbol)
        @symbol = symbol
        @winner = false
    end
end

class Board
    attr_reader :coordinates, :board, :game_over, :draw
    
    def initialize
        @coordinates = create_coordinates
        @board = create_board
        @game_over = false
        @draw = false
    end

    public

    def win?(board, parent, direction)
        result = false
        values = []
        4.times do |index| 
            node = []
            case direction
            when "horizontal"
                node = board.select { |coor| [parent.position[0] + index, parent.position[1] ] == coor.position }
            when "vertical"
                node = board.select { |coor| [parent.position[0], parent.position[1] + index ] == coor.position }
            when "right_diagonal"
                node = board.select { |coor| [parent.position[0] + index, parent.position[1] + index ] == coor.position }
            when "left_diagonal"
                node = board.select { |coor| [parent.position[0] - index, parent.position[1] + index ] == coor.position }
            end
            node = node[0]
            break if node.nil?
            values << node.value if (0..7).include?(node.position[0]) && (0..6).include?(node.position[1])
        end
        result = true if values.length == 4 && values.all?(parent.value) && values.none?(" ")
        result
    end

    def make_turn(player)
        input = gets.chomp.to_i - 1
        valid_input = false
        @board.each do |nde|
            if input == nde.position[0] && nde.value == " "
                nde.value = player.symbol
                valid_input = true
                break
            end
        end
        unless valid_input
            puts "\nInvalid input."
            make_turn(player)
        end
        if valid_input
            display_board()
            check_win(player)
            check_draw()
        end
    end

  

    def check_win(player)
        @board.each do |node|
            wins = [
                win?(@board, node, "horizontal"),
                win?(@board, node, "vertical"),
                win?(@board, node, "right_diagonal"),
                win?(@board, node, "left_diagonal")
            ]

            if wins.any?
                @game_over = true
                player.winner = true
                break
            end
        end
    end

    def check_draw
        if @board.none?{ |nde| nde.value == " " } && @game_over == false
            @draw = true
            @game_over =  true
        end
    end


    def display_board
        puts ' ' 
        print '|'
        @board[35..41].each {|node| print " #{node.value} |"}
        print "\n"
        print '|'
        @board[28..34].each {|node| print " #{node.value} |"}
        print "\n"
        print '|'
        @board[21..27].each {|node| print " #{node.value} |"}    
        print "\n"
        print '|'
        @board[14..20].each {|node| print " #{node.value} |"}    
        print "\n"
        print '|'
        @board[7..13].each {|node| print " #{node.value} |"}    
        print "\n"
        print '|'
        @board[0..6].each {|node| print " #{node.value} |"}        
        print "\n"
        puts ""
        puts "  1   2   3   4   5   6   7"
        puts "_____________________________"
        puts ""
    end


    private

    def create_coordinates
        coordinates = []
        6.times do |column_index|
            7.times do |row_index|
                position = []
                position << column_index
                position.unshift(row_index)
                coordinates << position
            end
        end
        coordinates
    end

    def create_board 
        board = []
        @coordinates.each do |coordinate|
            node = Node.new(coordinate)
            board << node
        end
        board
    end
    
    
end


def play
    player = [Player.new("X"),Player.new("O")]
    game = Board.new
    
    game.display_board
    until game.game_over
        puts "\nPlayer 1's turn(#{player[0].symbol}) \ninsert number"
        game.make_turn(player[0])
        break if game.game_over
        puts "\nPlayer 2's turn(#{player[1].symbol}) \ninsert number"
        game.make_turn(player[1])
    end

    if game.draw
        puts "GAME OVER \n\t DRAW..!!"
    else
        puts "GAME OVER"
        puts player[0].winner ? "Player 1 Wins" : "Player 2 wins"
    end
    puts ""
end

play if __FILE__ == $0

#asdsd
#asdsd