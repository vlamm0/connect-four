# requirements
require 'rspec'
require_relative '../lib/game'

# test Game
describe Game do
  subject(:test_game) { described_class.new }
  let(:white_piece) { "\u26AA" }
  let(:black_piece) { "\u26AB" }
  describe '#place_piece' do
    context 'when available' do
      it 'updates state' do
        test_game.place_piece(6, white_piece)
        coord1 = test_game.instance_variable_get(:@data)[5][6]
        expect(coord1).to eq(white_piece)
        test_game.place_piece(6, black_piece)
        coord2 = test_game.instance_variable_get(:@data)[4][6]
        expect(coord2).to eq(black_piece)
      end
      it 'only updates 1 spot' do
        test_game.place_piece(6, white_piece)
        test_data = test_game.instance_variable_get(:@data).flatten
        sol = test_data.reject { |slot| slot == '__' }.length
        expect(sol).to eq(1)
      end
      context 'when unavailable' do
        it 'returns UNAVAILABLE' do
          6.times { test_game.place_piece(6, white_piece) }
          sol = test_game.place_piece(6, white_piece)
          expect(sol).to eq('UNAVAILABLE')
        end
      end
    end
  end
end
