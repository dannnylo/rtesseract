require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
# encoding: UTF-8
require 'pathname'
class MakeStringError
  def to_s
    raise "error"
  end
end

describe "Rtesseract" do
  before do
    @path = Pathname.new(__FILE__.gsub("rtesseract_spec.rb","")).expand_path
    @image_tif = @path.join("images","test.tif").to_s
  end

  it " be instantiable" do
    RTesseract.new.class.should eql(RTesseract)
    RTesseract.new("").class.should eql(RTesseract)
    RTesseract.new(@image_tif).class.should eql(RTesseract)
  end

  it " translate image to text" do
    RTesseract.new(@image_tif).to_s_without_spaces.should eql("43XF")
    RTesseract.new(@image_tif, {:processor => 'mini_magick'}).to_s_without_spaces.should eql("43XF")
    RTesseract.new(@path.join("images","test1.tif").to_s).to_s_without_spaces.should eql("V2V4")
    RTesseract.new(@path.join("images","test with spaces.tif").to_s).to_s_without_spaces.should eql("V2V4")

  end

  it " translate images .png, .jpg, .bmp" do
    RTesseract.new(@path.join("images","test.png").to_s).to_s_without_spaces.should eql("HW9W")
    RTesseract.new(@path.join("images","test.jpg").to_s).to_s_without_spaces.should eql("3R8F")
    RTesseract.new(@path.join("images","test.bmp").to_s).to_s_without_spaces.should eql("FLA6")
  end

  it " support  diferent processors" do
    #Rmagick
    RTesseract.new(@image_tif).to_s_without_spaces.should eql("43XF")
    RTesseract.new(@image_tif, :processor => 'rmagick').to_s_without_spaces.should eql("43XF")
    RTesseract.new(@path.join("images","test.png").to_s, :processor => 'rmagick').to_s_without_spaces.should eql("HW9W")

    #MiniMagick
    RTesseract.new(@image_tif, :processor => 'mini_magick').to_s_without_spaces.should eql("43XF")
    RTesseract.new(@path.join("images","test.png").to_s, :processor => 'mini_magick').to_s_without_spaces.should eql("HW9W")

    #QuickMagick
    RTesseract.new(@image_tif, :processor => 'quick_magick').to_s_without_spaces.should eql("43XF")
    RTesseract.new(@path.join("images","test.png").to_s, :processor => 'quick_magick').to_s_without_spaces.should eql("HW9W")

    #NoneMagick
    RTesseract.new(@image_tif, :processor => 'none').to_s_without_spaces.should eql("43XF")
  end

  it " change the image" do
    image = RTesseract.new(@image_tif)
    image.to_s_without_spaces.should eql("43XF")
    image.source = @path.join("images","test1.tif").to_s
    image.to_s_without_spaces.should eql("V2V4")
  end

  it " select the language" do
    #English
     RTesseract.new(@image_tif,{:lang=>"eng"}).lang.should eql(" -l eng ")
     RTesseract.new(@image_tif,{:lang=>"en"}).lang.should eql(" -l eng ")
     RTesseract.new(@image_tif,{:lang=>"en-US"}).lang.should eql(" -l eng ")
     RTesseract.new(@image_tif,{:lang=>"english"}).lang.should eql(" -l eng ")

    #Portuguese
    RTesseract.new(@image_tif,{:lang=>"por"}).lang.should eql(" -l por ")
    RTesseract.new(@image_tif,{:lang=>"pt-BR"}).lang.should eql(" -l por ")
    RTesseract.new(@image_tif,{:lang=>"pt-br"}).lang.should eql(" -l por ")
    RTesseract.new(@image_tif,{:lang=>"pt"}).lang.should eql(" -l por ")
    RTesseract.new(@image_tif,{:lang=>"portuguese"}).lang.should eql(" -l por ")

    RTesseract.new(@image_tif,{:lang=>"eng"}).to_s_without_spaces.should eql("43XF")
    #RTesseract.new(@image_tif,{:lang=>"por"}).to_s_without_spaces.should eql("43XF")
    RTesseract.new(@image_tif,{:lang=>"eng"}).lang.should eql(" -l eng ")

    #Inválid lang object
    RTesseract.new(@image_tif,{:lang=>MakeStringError.new}).lang.should eql("")
  end

  it " select options" do
     expect(RTesseract.new(@image_tif).options_cmd).to eql([])
     expect(RTesseract.new(@image_tif, options: 'digits').options_cmd).to eql(['digits'])
     expect(RTesseract.new(@image_tif, options: :digits).options_cmd).to eql([:digits])
     expect(RTesseract.new(@image_tif, options: [:digits, :quiet]).options_cmd).to eql([:digits, :quiet])
  end

  it " be configurable" do
     RTesseract.new(@image_tif,{:chop_enable=>0,:enable_assoc=>0,:display_text=>0}).config.should eql("chop_enable 0\nenable_assoc 0\ndisplay_text 0")
     RTesseract.new(@image_tif,{:chop_enable=>0}).config.should eql("chop_enable 0")
     RTesseract.new(@image_tif,{:chop_enable=>0,:enable_assoc=>0}).config.should eql("chop_enable 0\nenable_assoc 0")
     RTesseract.new(@image_tif,{:chop_enable=>0}).to_s_without_spaces.should eql("43XF")
  end

  it " crop image" do
     RTesseract.new(@image_tif,{:psm=>7}).crop!(140,10,36,40).to_s_without_spaces.should eql("4")
     RTesseract.new(@image_tif,{:psm=>7}).crop!(180,10,36,40).to_s_without_spaces.should eql("3")
     RTesseract.new(@image_tif,{:psm=>7}).crop!(216,10,20,40).to_s_without_spaces.should eql("X")
     RTesseract.new(@image_tif,{:psm=>7}).crop!(240,10,30,40).to_s_without_spaces.should eql("F")
  end


  it " read image from blob" do
    image = Magick::Image.read(@path.join("images","test.png").to_s).first
    blob = image.quantize(256,Magick::GRAYColorspace).to_blob

    test = RTesseract.new("", {:psm => 7})
    test.from_blob(blob)
    test.to_s_without_spaces.should eql("HW9W")

    test = RTesseract.new("", {:psm => 7})
    expect{test.from_blob('') }.to raise_error(RTesseract::ConversionError)
  end

  it " use a instance" do
    RTesseract.new(Magick::Image.read(@image_tif.to_s).first).to_s_without_spaces.should eql("43XF")
    RMagickProcessor.a_name?('teste').should == false
    RMagickProcessor.a_name?('rmagick').should == true
    RMagickProcessor.a_name?('RMagickProcessor').should == true

    MiniMagickProcessor.a_name?('teste').should == false
    MiniMagickProcessor.a_name?('mini_magick').should == true
    MiniMagickProcessor.a_name?('MiniMagickProcessor').should == true

    QuickMagickProcessor.a_name?('teste').should == false
    QuickMagickProcessor.a_name?('quick_magick').should == true
    QuickMagickProcessor.a_name?('QuickMagickProcessor').should == true

    NoneProcessor.a_name?('none').should == true
    NoneProcessor.a_name?('NoneProcessor').should == true
  end

  it " change image in a block" do
    test = RTesseract.read(@path.join("images","test.png").to_s) do |image|
      image = image.white_threshold(245)
      image = image.quantize(256,Magick::GRAYColorspace)
    end
    test.to_s_without_spaces.should eql("HW9W")

    test = RTesseract.read(@path.join("images","test.jpg").to_s,{:lang=>'en'}) do |image|
      image = image.white_threshold(245).quantize(256, Magick::GRAYColorspace)
    end
    test.to_s_without_spaces.should eql("3R8F")

    test = RTesseract.read(@path.join("images","test.jpg").to_s,{:lang=>'en', :processor => 'mini_magick'}) do |image|
      #image.white_threshold(245)
      image.gravity "south"
    end
    test.to_s_without_spaces.should eql("3R8F")
  end

  it " get a error" do
    expect{ RTesseract.new(@path.join("images","test.jpg").to_s, {:command => "tesseract_error"}).to_s }.to raise_error(RTesseract::ConversionError)
    expect{ RTesseract.new(@path.join("images","test_not_exists.png").to_s).to_s }.to raise_error(RTesseract::ImageNotSelectedError)

    #Inválid psm object
    RTesseract.new(@image_tif,{:psm=>MakeStringError.new}).psm.should eql("")
  end

  it "remove a file" do
    rtesseract = RTesseract.new('.')
    rtesseract.remove_file(Tempfile.new('config'))

    expect{ rtesseract.remove_file(Pathname.new(Dir.tmpdir).join("test_not_exists")) }.to raise_error(RTesseract::TempFilesNotRemovedError)
  end
end
