# frozen_string_literal: true

RSpec.describe RTesseract::Box do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }
  let(:words_image) { path.join('resources', 'test_words.png').to_s }
  let(:words) { ['If', 'you', 'are', 'a', 'friend,', 'you', 'speak', 'the', 'password,', 'and', 'the', 'doors', 'will', 'open.'] }
  let(:instance) { RTesseract.new(words_image) }

  it 'returns the list of words' do
    expect(instance.words).to eql(words)
  end

  it 'bounding box' do
    expect(instance.to_box).to include(word: 'you', x_start: 69, y_start: 17, x_end: 100, y_end: 31)
  end
end
