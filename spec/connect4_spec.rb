require './main'

describe Node do
    describe "#initialize" do
        empty_node = Node.new([0, 0] ) 
        #or
        let(:player_node) { Node.new([0, 0], "X" ) }

        it "has a default value of \" \" " do
            expect(empty_node.value).to eql(" ")
        end

        it "has value when argument given" do
            expect(player_node.value).to eql("X")
        end
    end
end

describe Player do
    subject {Player.new "X"}
    describe "#initialize" do
        it {is_expected.not_to be_nil}
        it "has a symbol when argument given" do
            expect(subject.symbol).to eql("X")
        end
    end
end


describe Board do
    let(:game) {Board.new}
    describe "#initialize" do
        it{is_expected.not_to be_nil}
    end
    describe "#display board" do
        let(:player) { Player.new("X") }
        it 'display game board after each player turn' do
            expect(game).to receive(:display_board)
            allow(game).to receive(:gets).and_return('1')
            game.make_turn(player)
        end
        it 'display game board after each player turn' do
            expect(game).to receive(:display_board)
            allow(game).to receive(:gets).and_return('4')
            game.make_turn(player)
        end
        it 'display game board after each player turn' do
            expect(game).to receive(:display_board)
            allow(game).to receive(:gets).and_return('7')
            game.make_turn(player)
        end
    end
    describe "#create_coordinates" do
        it "returns array of 42 arrays each of 2 items ranging from 0-6, 0-5 respectively" do
            size = 0
            values = []
            game.coordinates.each{|coord| values << coord[0]
                values << coord[1]
               size += 1}
            expect(size).to eql(42)
            expect(values.all?{|x| x <= 6 && x >= 0}).to eql(true)
        end
    end
    describe "#create_board" do
        it 'returns array of 42 nodes with positions as the coordinates' do
            expect(game.board.length).to eql(42)
            expect(game.board.all?{|nde| nde.class == Node}).to eql(true)
        end
    end
    describe "#make_turn" do
        let(:spieler) {Player.new('%')}
        it "places the player's symbol in the right position" do
            allow(game).to receive(:gets).and_return('5')
            expect(game).to receive(:display_board)
            game.make_turn(spieler)
            expect(game.board[4].value).to eql('%')
        end
        context "--If a row is occupied" do
            it "places the player's symbol in the row above" do
                game.board[4].value = 'x'
                allow(game).to receive(:gets).and_return('5')
                expect(game).to receive(:display_board)
                game.make_turn(spieler)
                expect(game.board[11].value).to eql('%')
            end
        end
    end

    describe "#check_win" do
        let(:players){ [Player.new('X'),Player.new('O')] }
        context "--Horizontal Win" do 
            before(:each) do
                for i in (16..19)
                    game.board[i].value = players[0].symbol
                end
                allow(game).to receive(:gets).and_return('6')
                expect(game).to receive(:display_board)
                game.make_turn(players[0])
            end
            it 'game over' do
                expect(game.game_over).to eql(true)
            end     
            it 'player 1 wins' do
                expect(players[0].winner).to eql(true)
            end
        end

        context "--Vertical Win" do
            before(:each) do
                i = 2
                game.board[i].value = players[0].symbol
                3.times do 
                    7.times do 
                        i+=1
                    end
                    game.board[i].value = players[0].symbol
                end
                allow(game).to receive(:gets).and_return('5')
                expect(game).to receive(:display_board)
                game.make_turn(players[0])
            end
            it 'game_over' do
                expect(game.game_over).to eql(true)
            end
            it 'player 1 win' do
                expect(players[0].winner).to eql(true)
            end
        end

        context "--Right Diagonal Win" do
            before(:each) do
                game.board[8].value = players[1].symbol
                game.board[16].value = players[1].symbol
                game.board[24].value = players[1].symbol
                game.board[32].value = players[1].symbol
                expect(game).to receive(:display_board)
                allow(game).to receive(:gets).and_return('5')
                game.make_turn(players[1])
            end
            it 'game_over' do
                expect(game.game_over).to eql(true)
            end
            it 'player 2 wins' do
                expect(players[1].winner).to eql(true)
            end
        end

        context "--Left Diagonal Win" do
            before(:each) do
                game.board[11].value = players[1].symbol
                game.board[17].value = players[1].symbol
                game.board[23].value = players[1].symbol
                game.board[29].value = players[1].symbol
                expect(game).to receive(:display_board)
                allow(game).to receive(:gets).and_return('5')
                game.make_turn(players[1])
            end
            it 'game_over' do
                expect(game.game_over).to eql(true)
            end
            it 'player 2 wins' do
                expect(players[1].winner).to eql(true)
            end
        end

        context "--Draw" do
            before(:each) do
                i = 0
                loop do  #board.none?{|nde| nde.value == " "}
                    break if i == 42
                    3.times do
                        break if i == 42 
                        game.board[i].value = players[0].symbol
                        i+=1
                    end
                    break if i == 42
                    3.times do 
                        break if i == 42
                        game.board[i].value = players[1].symbol
                        i+=1
                    end
                    break if i == 42
                    game.board[i].value = players[0].symbol
                    i +=1
                    3.times do 
                        break if i == 42
                        game.board[i].value = players[1].symbol
                        i+=1
                    end
                    break if i == 42
                    3.times do 
                        break if i == 42
                        game.board[i].value = players[0].symbol
                        i+=1
                    end
                    break if i == 42
                    game.board[i].value = players[1].symbol
                    i +=1
                end
                allow(game).to receive(:gets).and_return('5')
                #game.check_win(players)
            end
            it 'draw' do
                game.check_draw
                expect(game.draw).to eql(true)
            end
            it 'player 1 does not win' do
                expect(players[0].winner).to eql(false)
            end
            it 'player 2 does not win' do
                expect(players[1].winner).to eql(false)
            end
        end

    end

end