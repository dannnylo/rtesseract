RSpec.describe RTesseract::Box do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }
  let(:image_tiff) { path.join('resources', 'test.tif').to_s }
  let(:words_image) { path.join('resources', 'test_words.png').to_s }

  it 'bounding box' do
    expect(RTesseract.new(words_image).to_s).to eql("If you are a friend,\nyou speak the password,\nand the doors will open.\n\f")
    # expect(RTesseract.new(words_image).to_box).to eql([
    #   { word: 'If',  x_start: 52, y_start: 13, x_end: 63, y_end: 27 },
    #   { word: 'you', x_start: 69, y_start: 17, x_end: 100, y_end: 31 },
    #   { word: 'are', x_start: 108, y_start: 17, x_end: 136, y_end: 27 },
    #   { word: 'a', x_start: 143, y_start: 17, x_end: 151, y_end: 27 },
    #   { word: 'friend,', x_start: 158, y_start: 13, x_end: 214, y_end: 29 },
    #   { word: 'you', x_start: 51, y_start: 39, x_end: 82, y_end: 53 },
    #   { word: 'speak', x_start: 90, y_start: 35, x_end: 140, y_end: 53 },
    #   { word: 'the', x_start: 146, y_start: 35, x_end: 174, y_end: 49 },
    #   { word: 'password,', x_start: 182, y_start: 35, x_end: 267, y_end: 53 },
    #   { word: 'and', x_start: 51, y_start: 57, x_end: 81, y_end: 71 },
    #   { word: 'the', x_start: 89, y_start: 57, x_end: 117, y_end: 71 },
    #   { word: 'doors', x_start: 124, y_start: 57, x_end: 164, y_end: 71 },
    #   { word: 'will', x_start: 165, y_start: 57, x_end: 208, y_end: 71 },
    #   { word: 'open.', x_start: 216, y_start: 61, x_end: 263, y_end: 75 }
    # ])

    expect(RTesseract.new(image_tiff).words.is_a?(Array)).to eql(true)
  end
end
