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
    end
    context 'when unavailable' do
      before do
        allow(test_game).to receive(:go).and_return(true)
        allow(test_game).to receive(:puts).and_return(nil)
      end
      it 'returns #go' do
        6.times { test_game.place_piece(6, white_piece) }
        sol = test_game.place_piece(6, white_piece)
        expect(sol).to eq(true)
      end
    end
  end
  describe '#update_data' do
    it 'updates data' do
      test_game.update_data(1, 3, black_piece)
      sol = test_game.instance_variable_get(:@data)[4][3]
      expect(sol).to eq(black_piece)
    end
    it 'returns correct coordinate' do
      sol = test_game.update_data(1, 3, black_piece)
      expect(sol).to eq([4, 3])
    end
  end
  describe '#curr_player' do
    context 'when turn even' do
      before do
        allow(test_game).to receive(:turn).and_return(2)
      end
      it 'returns player 1' do
        expect(test_game.curr_player.player).to eq('1')
      end
    end
    context 'when turn odd' do
      before do
        allow(test_game).to receive(:turn).and_return(1)
      end
      it 'returns player 1' do
        expect(test_game.curr_player.player).to eq('2')
      end
    end
  end
  describe '#valid_pos?' do
    let(:valid_positions) { [[0, 6], [1, 5], [2, 4], [3, 3], [4, 2], [5, 1], [4, 0]] }
    let(:invalid_positions) { [[0, 7], [1, 100], [100, 4], [-3, 3], [4, 8], [5, -1], [6, 0]] }
    context 'when valid' do
      it 'returns true' do
        valid_positions.each { |pos| expect(test_game.valid_pos?(pos)).to be true }
      end
    end
    context 'when invalid' do
      it 'returns false' do
        invalid_positions.each { |pos| expect(test_game.valid_pos?(pos)).to be false }
      end
    end
  end
  describe '#crawl' do
    context 'when valid position and curr players piece' do
      before do
        allow(test_game).to receive(:valid_pos?).and_return(true, false)
        allow(test_game).to receive(:data).and_return(white_piece)
      end
      it 'increases sum' do
        expect(test_game.crawl([0, 0]) { [0, 0] }).to eq(1)
      end
    end
    context 'when invalid position or different piece' do
      before do
        allow(test_game).to receive(:valid_pos?).and_return(true, false)
        allow(test_game).to receive(:data).and_return(black_piece, white_piece)
      end
      it 'does not change sum' do
        expect(test_game.crawl([0, 0]) { [0, 0] }).to eq(0)
        expect(test_game.crawl([0, 0]) { [0, 0] }).to eq(0)
      end
    end
  end
end
