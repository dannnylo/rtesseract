require 'csv'

RSpec.describe RTesseract::Configuration do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }

  # it ' be configurable' do
  #   expect(RTesseract.new(path, chop_enable: 0, enable_assoc: 0, display_text: 0).config).to eql("chop_enable 0\nenable_assoc 0\ndisplay_text 0")
  #   expect(RTesseract.new(path, chop_enable: 0).config).to eql('chop_enable 0')
  #   expect(RTesseract.new(path, chop_enable: 0, enable_assoc: 0).config).to eql("chop_enable 0\nenable_assoc 0")
  #   expect(RTesseract.new(path, chop_enable: 0).to_s_without_spaces).to eql('43XF')
  #   expect(RTesseract.new(path, tessedit_char_whitelist: 'ABCDEF12345').to_s_without_spaces).to eql('43F')
  # end

  it ' support default config processors' do
    RTesseract.configure { |config| config.psm = 7 }
    expect(RTesseract.config.psm).to eql(7)

    # RTesseract.configure { |config| config.tessdata_dir = '/tmp/test' }
    # expect(RTesseract.new(path).tessdata_dir).to eql(' --tessdata-dir /tmp/test ')

    # RTesseract.configure { |config| config.user_words = '/tmp/test' }
    # expect(RTesseract.new(path).user_words).to eql(' --user-words /tmp/test ')

    # RTesseract.configure { |config| config.user_patterns = '/tmp/test' }
    # expect(RTesseract.new(path).user_patterns).to eql(' --user-patterns /tmp/test ')
  end

  # it ' support new configs' do
  #   expect(RTesseract.new(path, tessdata_dir: '/tmp/test').tessdata_dir).to eql(' --tessdata-dir /tmp/test ')
  #   expect(RTesseract.new(path, user_words: '/tmp/test').user_words).to eql(' --user-words /tmp/test ')
  #   expect(RTesseract.new(path, user_patterns: '/tmp/test').user_patterns).to eql(' --user-patterns /tmp/test ')

  #   expect(RTesseract.new(path, tessdata_dir: MakeStringError.new).tessdata_dir).to eql('')
  #   expect(RTesseract.new(path, user_words: MakeStringError.new).user_words).to eql('')
  #   expect(RTesseract.new(path, user_patterns: MakeStringError.new).user_patterns).to eql('')

  #   # expect(RTesseract.new(@path.join('images', 'test_words.png').to_s, psm: 3, user_words: @path.join('configs', 'eng.user-words.txt').to_s).to_s).to eql("If you are a friend,\nyou speak the password,\nand the doors will open.\n\n")
  # end
end
