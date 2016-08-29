require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
# encoding: UTF-8
require 'pathname'

# Class to rise error
class MakeStringError
  def to_s
    fail 'error'
  end
end

describe 'Rtesseract' do
  before do
    @path = Pathname.new(__FILE__.gsub('rtesseract_spec.rb', '')).expand_path
    @image_tif = @path.join('images', 'test.tif').to_s
    @image_for_pdf = @path.join('images', 'test-pdf.png').to_s
  end

  it ' be instantiable' do
    expect(RTesseract.new.class).to eql(RTesseract)
    expect(RTesseract.new('').class).to eql(RTesseract)
    expect(RTesseract.new(@image_tif).class).to eql(RTesseract)
  end

  it ' translate image to text' do
    expect(RTesseract.new(@image_tif).to_s_without_spaces).to eql('43XF')
    expect(RTesseract.new(@image_tif, processor: 'mini_magick').to_s_without_spaces).to eql('43XF')
    expect(RTesseract.new(@path.join('images', 'test1.tif').to_s).to_s_without_spaces).to eql('V2V4')
    expect(RTesseract.new(@path.join('images', 'test with spaces.tif').to_s).to_s_without_spaces).to eql('V2V4')
  end

  it ' translate images .png, .jpg, .bmp' do
    expect(RTesseract.new(@path.join('images', 'test.png').to_s).to_s_without_spaces).to eql('HW9W')
    expect(RTesseract.new(@path.join('images', 'test.jpg').to_s).to_s_without_spaces).to eql('3R8F')
    expect(RTesseract.new(@path.join('images', 'test.bmp').to_s).to_s_without_spaces).to eql('FLA6')
  end

  it ' should not error with depth > 32' do
    # expect(RTesseract.new(@path.join('images', 'README.pdf').to_s, debug: true).to_s_without_spaces).to eql('')
  end

  it ' support  different processors' do
    # Rmagick
    expect(RTesseract.new(@image_tif).to_s_without_spaces).to eql('43XF')
    expect(RTesseract.new(@image_tif, processor: 'rmagick').to_s_without_spaces).to eql('43XF')
    expect(RTesseract.new(@path.join('images', 'test.png').to_s, processor: 'rmagick').to_s_without_spaces).to eql('HW9W')

    # MiniMagick
    expect(RTesseract.new(@image_tif, processor: 'mini_magick').to_s_without_spaces).to eql('43XF')
    expect(RTesseract.new(@path.join('images', 'test.png').to_s, processor: 'mini_magick').to_s_without_spaces).to eql('HW9W')

    # NoneMagick
    expect(RTesseract.new(@image_tif, processor: 'none').to_s_without_spaces).to eql('43XF')
  end

  it ' change the image' do
    image = RTesseract.new(@image_tif)
    expect(image.to_s_without_spaces).to eql('43XF')
    image.source = @path.join('images', 'test1.tif').to_s
    expect(image.to_s_without_spaces).to eql('V2V4')
  end

  it ' returns the source' do
    image = RTesseract.new(@image_tif)
    expect(image.source).to eql(Pathname.new(@image_tif))
  end

  it ' select the language' do
    # English
    expect(RTesseract.new(@image_tif, lang: 'eng').lang).to eql(' -l eng ')
    expect(RTesseract.new(@image_tif, lang: 'en').lang).to eql(' -l eng ')
    expect(RTesseract.new(@image_tif, lang: 'en-US').lang).to eql(' -l eng ')
    expect(RTesseract.new(@image_tif, lang: 'english').lang).to eql(' -l eng ')

    # Portuguese
    expect(RTesseract.new(@image_tif, lang: 'por').lang).to eql(' -l por ')
    expect(RTesseract.new(@image_tif, lang: 'pt-BR').lang).to eql(' -l por ')
    expect(RTesseract.new(@image_tif, lang: 'pt-br').lang).to eql(' -l por ')
    expect(RTesseract.new(@image_tif, lang: 'pt').lang).to eql(' -l por ')
    expect(RTesseract.new(@image_tif, lang: 'portuguese').lang).to eql(' -l por ')

    expect(RTesseract.new(@image_tif, lang: 'eng').to_s_without_spaces).to eql('43XF')

    expect(RTesseract.new(@image_tif, lang: 'eng').lang).to eql(' -l eng ')
    expect(RTesseract.new(@image_tif, lang: 'it').lang).to eql(' -l ita ')

    # Invalid lang object
    expect(RTesseract.new(@image_tif, lang: MakeStringError.new).lang).to eql('')
  end

  it ' select options' do
    expect(RTesseract.new(@image_tif).options_cmd).to eql([])
    expect(RTesseract.new(@image_tif, options: 'digits').options_cmd).to eql(['digits'])
    expect(RTesseract.new(@image_tif, options: :digits).options_cmd).to eql([:digits])
    expect(RTesseract.new(@image_tif, options: [:digits, :quiet]).options_cmd).to eql([:digits, :quiet])
  end

  it ' support pdf output mode' do
    expect(RTesseract.new(@image_tif, options: 'pdf').options_cmd).to eql(['pdf'])
    expect(RTesseract.new(@image_for_pdf, options: :pdf).options_cmd).to eql([:pdf])
    expect(RTesseract.new(@image_tif, options: :pdf).pdf?).to eql(true)
    expect(RTesseract.new(@image_for_pdf, options: 'pdf').pdf?).to eql(true)

    pdf_ocr = RTesseract.new(@image_for_pdf, options: :pdf)
    expect(File.exists?(pdf_ocr.to_pdf)).to eql(true)
    expect(File.extname(pdf_ocr.to_pdf)).to eql('.pdf')
    # comment next #clean call and go to tmp dir to see the generated pdf.
    # puts pdf_ocr.to_pdf
    pdf_ocr.clean
    expect(File.exists?(pdf_ocr.to_pdf)).to eql(false)
  end

  it ' be configurable' do
    expect(RTesseract.new(@image_tif, chop_enable: 0, enable_assoc: 0, display_text: 0).config).to eql("chop_enable 0\nenable_assoc 0\ndisplay_text 0")
    expect(RTesseract.new(@image_tif, chop_enable: 0).config).to eql('chop_enable 0')
    expect(RTesseract.new(@image_tif, chop_enable: 0, enable_assoc: 0).config).to eql("chop_enable 0\nenable_assoc 0")
    expect(RTesseract.new(@image_tif, chop_enable: 0).to_s_without_spaces).to eql('43XF')
    expect(RTesseract.new(@image_tif, tessedit_char_whitelist: 'ABCDEF12345').to_s_without_spaces).to eql('43F')
  end

  it ' crop image' do
    expect(RTesseract.new(@image_tif, psm: 7).crop!(w: 36, h: 40, x: 140, y: 10).to_s_without_spaces).to eql('4')
    expect(RTesseract.new(@image_tif, psm: 7).crop!(w: 36, h: 40, x: 180, y: 10).to_s_without_spaces).to eql('3')
    expect(RTesseract.new(@image_tif, psm: 7).crop!(w: 20, h: 40, x: 216, y: 10).to_s_without_spaces).to eql('X')
    expect(RTesseract.new(@image_tif, psm: 7).crop!(w: 30, h: 40, x: 240, y: 10).to_s_without_spaces).to eql('F')
  end

  it ' read image from blob' do
    image = Magick::Image.read(@path.join('images', 'test.png').to_s).first
    blob = image.quantize(256, Magick::GRAYColorspace).to_blob

    test = RTesseract.new('', psm: 7)
    test.from_blob(blob)
    expect(test.to_s_without_spaces).to eql('HW9W')

    test = RTesseract.new('', psm: 7)
    expect { test.from_blob('') }.to raise_error(RTesseract::ConversionError)
  end

  it ' use a instance' do
    expect(RTesseract.new(Magick::Image.read(@image_tif.to_s).first).to_s_without_spaces).to eql('43XF')
    expect(RTesseract::Processor::RMagickProcessor.a_name?('teste')).to eql(false)
    expect(RTesseract::Processor::RMagickProcessor.a_name?('rmagick')).to eql(true)
    expect(RTesseract::Processor::RMagickProcessor.a_name?('RMagickProcessor')).to eql(true)
    expect(RTesseract::Processor::MiniMagickProcessor.a_name?('teste')).to eql(false)
    expect(RTesseract::Processor::MiniMagickProcessor.a_name?('mini_magick')).to eql(true)
    expect(RTesseract::Processor::MiniMagickProcessor.a_name?('MiniMagickProcessor')).to eql(true)
    expect(RTesseract::Processor::NoneProcessor.a_name?('none')).to eql(true)
    expect(RTesseract::Processor::NoneProcessor.a_name?('NoneProcessor')).to eql(true)
  end

  it ' change image in a block' do
    test = RTesseract.read(@path.join('images', 'test.png').to_s) {}
    expect(test.class).to eql(RTesseract)

    test = RTesseract.new(@image_tif)
    test.read do |_image|
      _image = _image.quantize(256, Magick::GRAYColorspace)
    end
    expect(test.to_s_without_spaces).to eql('43XF')

    test = RTesseract.new(@path.join('images', 'blank.tif').to_s)
    test.read do |_image|
      _image
    end
    expect(test.to_s_without_spaces).to eql('')

    test = RTesseract.read(@path.join('images', 'test.png').to_s) do |_image|
      _image.rotate(90)
    end
    expect(test.to_s_without_spaces).to eql('HW9W')

    test = RTesseract.read(@path.join('images', 'test.jpg').to_s, lang: 'en') do |_image|
      _image = _image.white_threshold(245).quantize(256, Magick::GRAYColorspace)
    end
    expect(test.to_s_without_spaces).to eql('3R8F')

    test = RTesseract.read(@path.join('images', 'test.jpg').to_s, lang: 'en', processor: 'mini_magick') do |_image|
      _image.gravity 'south'
    end
    expect(test.to_s_without_spaces).to eql('3R8F')
  end

  it ' get a error' do
    expect { RTesseract.new(@path.join('images', 'test.jpg').to_s, command: 'tesseract_error').to_s }.to raise_error(RTesseract::ConversionError)
    expect { RTesseract.new(@path.join('images', 'test_not_exists.png').to_s).to_s }.to raise_error(RTesseract::ImageNotSelectedError)

    # Invalid psm object
    expect(RTesseract.new(@image_tif, psm:  MakeStringError.new).psm).to eql('')
  end

  it 'remove a file' do
    RTesseract::Utils.remove_files(Tempfile.new('config'))

    expect { RTesseract::Utils.remove_files(Pathname.new(Dir.tmpdir).join('test_not_exists')) }.to raise_error(RTesseract::TempFilesNotRemovedError)
  end

  it ' support  default config processors' do
    # Rmagick
    RTesseract.configure { |config| config.processor = 'rmagick' }
    expect(RTesseract.new(@image_tif).processor.a_name?('rmagick')).to eql(true)

    # MiniMagick
    RTesseract.configure { |config| config.processor = 'mini_magick' }
    expect(RTesseract.new(@image_tif).processor.a_name?('mini_magick')).to eql(true)

    # NoneMagick
    RTesseract.configure { |config| config.processor = 'none' }
    expect(RTesseract.new(@image_tif).processor.a_name?('none')).to eql(true)

    # overwrite default
    RTesseract.configure { |config| config.processor = 'rmagick' }
    expect(RTesseract.new(@image_tif, processor: 'mini_magick').processor.a_name?('mini_magick')).to eql(true)

    RTesseract.configure { |config| config.lang = 'portuguese' }
    expect(RTesseract.new(@image_tif).lang).to eql(' -l por ')

    RTesseract.configure { |config| config.psm = 7 }
    expect(RTesseract.new(@image_tif).psm).to eql(' -psm 7 ')

    RTesseract.configure { |config| config.tessdata_dir = '/tmp/test' }
    expect(RTesseract.new(@image_tif).tessdata_dir).to eql(' --tessdata-dir /tmp/test ')

    RTesseract.configure { |config| config.user_words = '/tmp/test' }
    expect(RTesseract.new(@image_tif).user_words).to eql(' --user-words /tmp/test ')

    RTesseract.configure { |config| config.user_patterns = '/tmp/test' }
    expect(RTesseract.new(@image_tif).user_patterns).to eql(' --user-patterns /tmp/test ')
  end

  it ' support new configs' do
    expect(RTesseract.new(@image_tif, tessdata_dir: '/tmp/test').tessdata_dir).to eql(' --tessdata-dir /tmp/test ')
    expect(RTesseract.new(@image_tif, user_words: '/tmp/test').user_words).to eql(' --user-words /tmp/test ')
    expect(RTesseract.new(@image_tif, user_patterns: '/tmp/test').user_patterns).to eql(' --user-patterns /tmp/test ')

    expect(RTesseract.new(@image_tif, tessdata_dir: MakeStringError.new).tessdata_dir).to eql('')
    expect(RTesseract.new(@image_tif, user_words: MakeStringError.new).user_words).to eql('')
    expect(RTesseract.new(@image_tif, user_patterns: MakeStringError.new).user_patterns).to eql('')

    # expect(RTesseract.new(@path.join('images', 'test_words.png').to_s, psm: 3, user_words: @path.join('configs', 'eng.user-words.txt').to_s).to_s).to eql("If you are a friend,\nyou speak the password,\nand the doors will open.\n\n")
  end
end
