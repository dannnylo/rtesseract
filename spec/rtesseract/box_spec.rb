RSpec.describe RTesseract::Box do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }
  let(:image_tiff) { path.join('resources', 'test.tif').to_s }
  let(:words_image) { path.join('resources', 'test_words.png').to_s }

  it 'bounding box' do
    expect(RTesseract.new(words_image).to_s).to eql("If you are a friend,\nyou speak the password,\nand the doors will open.\n\f")
    expect(RTesseract.new(words_image).to_box).to include({ word: 'you', x_start: 69, y_start: 17, x_end: 100, y_end: 31 })

    expect(RTesseract.new(words_image).words).to eql(%w[If you are a friend, you speak the password, and the doors will open.])
  end
end
