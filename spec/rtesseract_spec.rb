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
    #expect(RTesseract.new(@path.join('images', 'README.pdf').to_s, debug: true).to_s_without_spaces).to eql('')
  end

  it ' support  different processors' do
    # Rmagick
    expect(RTesseract.new(@image_tif).to_s_without_spaces).to eql('43XF')
    expect(RTesseract.new(@image_tif, processor: 'rmagick').to_s_without_spaces).to eql('43XF')
    expect(RTesseract.new(@path.join('images', 'test.png').to_s, processor: 'rmagick').to_s_without_spaces).to eql('HW9W')

    # MiniMagick
    expect(RTesseract.new(@image_tif, processor: 'mini_magick').to_s_without_spaces).to eql('43XF')
    expect(RTesseract.new(@path.join('images', 'test.png').to_s, processor: 'mini_magick').to_s_without_spaces).to eql('HW9W')

    # QuickMagick
    expect(RTesseract.new(@image_tif, processor: 'quick_magick').to_s_without_spaces).to eql('43XF')
    expect(RTesseract.new(@path.join('images', 'test.png').to_s, processor: 'quick_magick').to_s_without_spaces).to eql('HW9W')

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

    # Invalid lang object
    expect(RTesseract.new(@image_tif, lang: MakeStringError.new).lang).to eql('')
  end

  it ' select options' do
    expect(RTesseract.new(@image_tif).options_cmd).to eql([])
    expect(RTesseract.new(@image_tif, options: 'digits').options_cmd).to eql(['digits'])
    expect(RTesseract.new(@image_tif, options: :digits).options_cmd).to eql([:digits])
    expect(RTesseract.new(@image_tif, options: [:digits, :quiet]).options_cmd).to eql([:digits, :quiet])
  end

  it ' be configurable' do
    expect(RTesseract.new(@image_tif, chop_enable: 0, enable_assoc: 0, display_text: 0).config).to eql("chop_enable 0\nenable_assoc 0\ndisplay_text 0")
    expect(RTesseract.new(@image_tif, chop_enable: 0).config).to eql('chop_enable 0')
    expect(RTesseract.new(@image_tif, chop_enable: 0, enable_assoc: 0).config).to eql("chop_enable 0\nenable_assoc 0")
    expect(RTesseract.new(@image_tif, chop_enable: 0).to_s_without_spaces).to eql('43XF')
  end

  it ' crop image' do
    expect(RTesseract.new(@image_tif, psm: 7).crop!(140, 10, 36, 40).to_s_without_spaces).to eql('4')
    expect(RTesseract.new(@image_tif, psm: 7).crop!(180, 10, 36, 40).to_s_without_spaces).to eql('3')
    expect(RTesseract.new(@image_tif, psm: 7).crop!(216, 10, 20, 40).to_s_without_spaces).to eql('X')
    expect(RTesseract.new(@image_tif, psm: 7).crop!(240, 10, 30, 40).to_s_without_spaces).to eql('F')
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
    expect(RMagickProcessor.a_name?('teste')).to eql(false)
    expect(RMagickProcessor.a_name?('rmagick')).to eql(true)
    expect(RMagickProcessor.a_name?('RMagickProcessor')).to eql(true)
    expect(MiniMagickProcessor.a_name?('teste')).to eql(false)
    expect(MiniMagickProcessor.a_name?('mini_magick')).to eql(true)
    expect(MiniMagickProcessor.a_name?('MiniMagickProcessor')).to eql(true)
    expect(QuickMagickProcessor.a_name?('teste')).to eql(false)
    expect(QuickMagickProcessor.a_name?('quick_magick')).to eql(true)
    expect(QuickMagickProcessor.a_name?('QuickMagickProcessor')).to eql(true)
    expect(NoneProcessor.a_name?('none')).to eql(true)
    expect(NoneProcessor.a_name?('NoneProcessor')).to eql(true)
  end

  it ' change image in a block' do
    test = RTesseract.read(@path.join('images', 'test.png').to_s) {}
    expect(test.class).to eql(RTesseract)

    test = RTesseract.new(@image_tif)
    test.read do |image|
      image = image.quantize(256, Magick::GRAYColorspace)
    end
    expect(test.to_s_without_spaces).to eql('43XF')

    test = RTesseract.new(@path.join('images', 'blank.tif').to_s)
    test.read do |image|
      image
    end
    expect(test.to_s_without_spaces).to eql('')

    test = RTesseract.read(@path.join('images', 'test.png').to_s) do |image|
      image.rotate(90)
    end
    expect(test.to_s_without_spaces).to eql('HW9W')

    test = RTesseract.read(@path.join('images', 'test.jpg').to_s, lang: 'en') do |image|
      image = image.white_threshold(245).quantize(256, Magick::GRAYColorspace)
    end
    expect(test.to_s_without_spaces).to eql('3R8F')

    test = RTesseract.read(@path.join('images', 'test.jpg').to_s, lang: 'en', processor: 'mini_magick') do |image|
      image.gravity 'south'
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
    rtesseract = RTesseract.new('.')
    rtesseract.remove_file(Tempfile.new('config'))

    expect { rtesseract.remove_file(Pathname.new(Dir.tmpdir).join('test_not_exists')) }.to raise_error(RTesseract::TempFilesNotRemovedError)
  end

  it ' support  default config processors' do
    # Rmagick
    RTesseract.configure {|config| config.processor = 'rmagick' }
    expect(RTesseract.new(@image_tif).processor.a_name?('rmagick')).to eql(true)

    # MiniMagick
    RTesseract.configure {|config| config.processor = 'mini_magick' }
    expect(RTesseract.new(@image_tif).processor.a_name?('mini_magick')).to eql(true)

    # QuickMagick
    RTesseract.configure {|config| config.processor = 'quick_magick' }
    expect(RTesseract.new(@image_tif).processor.a_name?('quick_magick')).to eql(true)

    # NoneMagick
    RTesseract.configure {|config| config.processor = 'none' }
    expect(RTesseract.new(@image_tif).processor.a_name?('none')).to eql(true)

    # overwrite default
    RTesseract.configure {|config| config.processor = 'mini_magick' }
    expect(RTesseract.new(@image_tif, processor: 'quick_magick').processor.a_name?('quick_magick')).to eql(true)

    RTesseract.configure {|config| config.lang = 'portuguese' }
    expect(RTesseract.new(@image_tif).lang).to eql(' -l por ')

    RTesseract.configure {|config| config.psm = 7 }
    expect(RTesseract.new(@image_tif).psm).to eql(' -psm 7 ')


    RTesseract.configure {|config| config.tessdata_dir = '/tmp/test' }
    expect(RTesseract.new(@image_tif).tessdata_dir).to eql(' --tessdata-dir /tmp/test ')

    RTesseract.configure {|config| config.user_words = '/tmp/test' }
    expect(RTesseract.new(@image_tif).user_words).to eql(' --user-words /tmp/test ')

    RTesseract.configure {|config| config.user_patterns = '/tmp/test' }
    expect(RTesseract.new(@image_tif).user_patterns).to eql(' --user-patterns /tmp/test ')
  end

end
