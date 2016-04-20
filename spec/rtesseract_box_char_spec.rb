# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Rtesseract::BoxChar' do
  before do
    @path = Pathname.new(__FILE__.gsub('rtesseract_box_char_spec.rb', '')).expand_path
    @image_tiff = @path.join('images', 'test.tif').to_s
    @words_image = @path.join('images', 'test_words.png').to_s
    @values = [
      { char: 'I', x_start: 52, y_start: 91, x_end: 54, y_end: 104 },
      { char: 'f', x_start: 56, y_start: 91, x_end: 63, y_end: 105 },
      { char: 'y', x_start: 69, y_start: 87, x_end: 79, y_end: 101 },
      { char: 'o', x_start: 80, y_start: 91, x_end: 90, y_end: 101 },
      { char: 'u', x_start: 92, y_start: 91, x_end: 100, y_end: 101 },
      { char: 'a', x_start: 108, y_start: 91, x_end: 116, y_end: 101 },
      { char: 'r', x_start: 119, y_start: 91, x_end: 125, y_end: 101 },
      { char: 'e', x_start: 126, y_start: 91, x_end: 136, y_end: 101 },
      { char: 'a', x_start: 143, y_start: 91, x_end: 151, y_end: 101 },
      { char: 'f', x_start: 158, y_start: 91, x_end: 165, y_end: 105 },
      { char: 'r', x_start: 166, y_start: 91, x_end: 172, y_end: 101 },
      { char: 'i', x_start: 174, y_start: 91, x_end: 176, y_end: 105 },
      { char: 'e', x_start: 178, y_start: 91, x_end: 188, y_end: 101 },
      { char: 'n', x_start: 190, y_start: 91, x_end: 198, y_end: 101 },
      { char: 'd', x_start: 200, y_start: 91, x_end: 209, y_end: 105 },
      { char: ',', x_start: 211, y_start: 89, x_end: 214, y_end: 93 },
      { char: 'y', x_start: 51, y_start: 65, x_end: 61, y_end: 79 },
      { char: 'o', x_start: 62, y_start: 69, x_end: 72, y_end: 79 },
      { char: 'u', x_start: 74, y_start: 69, x_end: 82, y_end: 79 },
      { char: 's', x_start: 90, y_start: 69, x_end: 97, y_end: 79 },
      { char: 'p', x_start: 99, y_start: 65, x_end: 108, y_end: 79 },
      { char: 'e', x_start: 109, y_start: 69, x_end: 119, y_end: 79 },
      { char: 'a', x_start: 120, y_start: 69, x_end: 128, y_end: 79 },
      { char: 'k', x_start: 131, y_start: 69, x_end: 140, y_end: 83 },
      { char: 't', x_start: 146, y_start: 69, x_end: 152, y_end: 82 },
      { char: 'h', x_start: 154, y_start: 69, x_end: 162, y_end: 83 },
      { char: 'e', x_start: 164, y_start: 69, x_end: 174, y_end: 79 },
      { char: 'p', x_start: 182, y_start: 65, x_end: 191, y_end: 79 },
      { char: 'a', x_start: 192, y_start: 69, x_end: 200, y_end: 79 },
      { char: 's', x_start: 202, y_start: 69, x_end: 209, y_end: 79 },
      { char: 's', x_start: 210, y_start: 69, x_end: 217, y_end: 79 },
      { char: 'w', x_start: 219, y_start: 69, x_end: 232, y_end: 79 },
      { char: 'o', x_start: 234, y_start: 69, x_end: 244, y_end: 79 },
      { char: 'r', x_start: 246, y_start: 69, x_end: 252, y_end: 79 },
      { char: 'd', x_start: 253, y_start: 69, x_end: 262, y_end: 83 },
      { char: ',', x_start: 264, y_start: 67, x_end: 267, y_end: 71 },
      { char: 'a', x_start: 51, y_start: 47, x_end: 59, y_end: 57 },
      { char: 'n', x_start: 62, y_start: 47, x_end: 70, y_end: 57 },
      { char: 'd', x_start: 72, y_start: 47, x_end: 81, y_end: 61 },
      { char: 't', x_start: 89, y_start: 47, x_end: 95, y_end: 60 },
      { char: 'h', x_start: 97, y_start: 47, x_end: 105, y_end: 61 },
      { char: 'e', x_start: 107, y_start: 47, x_end: 117, y_end: 57 },
      { char: 'd', x_start: 124, y_start: 47, x_end: 133, y_end: 61 },
      { char: 'o', x_start: 135, y_start: 47, x_end: 145, y_end: 57 },
      { char: 'o', x_start: 146, y_start: 47, x_end: 156, y_end: 57 },
      { char: 'r', x_start: 158, y_start: 47, x_end: 164, y_end: 57 },
      { char: 's', x_start: 165, y_start: 47, x_end: 172, y_end: 57 },
      { char: 'w', x_start: 180, y_start: 47, x_end: 193, y_end: 57 },
      { char: 'i', x_start: 196, y_start: 47, x_end: 198, y_end: 61 },
      { char: 'l', x_start: 201, y_start: 47, x_end: 203, y_end: 61 },
      { char: 'l', x_start: 206, y_start: 47, x_end: 208, y_end: 61 },
      { char: 'o', x_start: 216, y_start: 47, x_end: 226, y_end: 57 },
      { char: 'p', x_start: 228, y_start: 43, x_end: 237, y_end: 57 },
      { char: 'e', x_start: 238, y_start: 47, x_end: 248, y_end: 57 },
      { char: 'n', x_start: 250, y_start: 47, x_end: 258, y_end: 57 },
      { char: '.', x_start: 261, y_start: 47, x_end: 263, y_end: 49 }]
  end

  it 'bounding box by char' do
    expect(RTesseract::BoxChar.new(@image_tiff).characters.is_a?(Array)).to eql(true)
    expect(RTesseract::BoxChar.new(@image_tiff).characters).to eql([
      { char: '4', x_start: 145, y_start: 14, x_end: 159, y_end: 33 },
      { char: '3', x_start: 184, y_start: 14, x_end: 196, y_end: 33 },
      { char: 'X', x_start: 222, y_start: 14, x_end: 238, y_end: 32 },
      { char: 'F', x_start: 260, y_start: 14, x_end: 273, y_end: 32 }])

    expect(RTesseract::BoxChar.new(@words_image).characters).to eql(@values)

    expect { RTesseract::BoxChar.new(@image_tiff, command: 'tesseract_error').to_s }.to raise_error(RTesseract::ConversionError)
    expect { RTesseract::BoxChar.new(@image_tiff + '_not_exist').to_s }.to raise_error(RTesseract::ImageNotSelectedError)
    # expect(RTesseract::BoxChar.new(@path.join('images', 'blank.tif').to_s, options: :digits).characters).to eql([])
  end
end
