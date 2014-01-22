require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
# encoding: UTF-8
require 'pathname'

describe "Rtesseract" do
  before do
    @path = Pathname.new(__FILE__.gsub("rtesseract_spec.rb","")).expand_path
    @image_tiff = @path.join("images","test.tif").to_s
  end

  it " be instantiable" do
    RTesseract.new.class.should eql(RTesseract)
    RTesseract.new("").class.should eql(RTesseract)
    RTesseract.new(@image_tiff).class.should eql(RTesseract)
  end

  it " translate image to text" do
    RTesseract.new(@image_tiff).to_s_without_spaces.should eql("43ZZ")
    RTesseract.new(@path.join("images","test1.tif").to_s).to_s_without_spaces.should eql("V2V4")
    RTesseract.new(@path.join("images","test with spaces.tif").to_s).to_s_without_spaces.should eql("V2V4")
  end

  it " translate images .png, .jpg, .bmp" do
    RTesseract.new(@path.join("images","test.png").to_s).to_s_without_spaces.should eql("HW9W")
    RTesseract.new(@path.join("images","test.jpg").to_s).to_s_without_spaces.should eql("3R8Z")
    RTesseract.new(@path.join("images","test.bmp").to_s).to_s_without_spaces.should eql("ZLA6")
  end

  it " change the image" do
    image = RTesseract.new(@image_tiff)
    image.to_s_without_spaces.should eql("43ZZ")
    image.source = @path.join("images","test1.tif").to_s
    image.to_s_without_spaces.should eql("V2V4")
  end

  it " select the language" do
    #English
     RTesseract.new(@image_tiff,{:lang=>"eng"}).lang.should eql(" -l eng ")
     RTesseract.new(@image_tiff,{:lang=>"en"}).lang.should eql(" -l eng ")
     RTesseract.new(@image_tiff,{:lang=>"en-US"}).lang.should eql(" -l eng ")
     RTesseract.new(@image_tiff,{:lang=>"english"}).lang.should eql(" -l eng ")

    #Portuguese
    RTesseract.new(@image_tiff,{:lang=>"por"}).lang.should eql(" -l por ")
    RTesseract.new(@image_tiff,{:lang=>"pt-BR"}).lang.should eql(" -l por ")
    RTesseract.new(@image_tiff,{:lang=>"pt-br"}).lang.should eql(" -l por ")
    RTesseract.new(@image_tiff,{:lang=>"pt"}).lang.should eql(" -l por ")
    RTesseract.new(@image_tiff,{:lang=>"portuguese"}).lang.should eql(" -l por ")

    RTesseract.new(@image_tiff,{:lang=>"eng"}).to_s_without_spaces.should eql("43ZZ")
    RTesseract.new(@image_tiff,{:lang=>"por"}).to_s_without_spaces.should eql("43ZZ")

    RTesseract.new(@image_tiff,{:lang=>"eng"}).lang.should eql(" -l eng ")
  end

  it " be configurable" do
     RTesseract.new(@image_tiff,{:chop_enable=>0,:enable_assoc=>0,:display_text=>0}).config.should eql("chop_enable 0\nenable_assoc 0\ndisplay_text 0")
     RTesseract.new(@image_tiff,{:chop_enable=>0}).config.should eql("chop_enable 0")
     RTesseract.new(@image_tiff,{:chop_enable=>0,:enable_assoc=>0}).config.should eql("chop_enable 0\nenable_assoc 0")
     RTesseract.new(@image_tiff,{:chop_enable=>0}).to_s_without_spaces.should eql("43ZZ")
  end

  it " crop image" do
     RTesseract.new(@image_tiff,{:psm=>7}).crop!(140,10,36,40).to_s_without_spaces.should eql("4")
     RTesseract.new(@image_tiff,{:psm=>7}).crop!(180,10,36,40).to_s_without_spaces.should eql("3")
     RTesseract.new(@image_tiff,{:psm=>7}).crop!(200,10,36,40).to_s_without_spaces.should eql("Z")
     RTesseract.new(@image_tiff,{:psm=>7}).crop!(220,10,30,40).to_s_without_spaces.should eql("Z")
  end


  it " read image from blob" do
    image = Magick::Image.read(@path.join("images","test.png").to_s).first
    blob = image.quantize(256,Magick::GRAYColorspace).to_blob

    test = RTesseract.new("", {:psm => 7})
    test.from_blob(blob)
    test.to_s_without_spaces.should eql("HW9W")
  end

  it " use a instance" do
    RTesseract.new(Magick::Image.read(@image_tiff.to_s).first).to_s_without_spaces.should eql("43ZZ")
  end

  it " change image in a block" do
    test = RTesseract.read(@path.join("images","test.png").to_s) do |image|
      image = image.white_threshold(245)
      image = image.quantize(256,Magick::GRAYColorspace)
    end
    test.to_s_without_spaces.should eql("HW9W")

    test = RTesseract.read(@path.join("images","test.jpg").to_s,{:lang=>'en'}) do |image|
      image = image.white_threshold(245).quantize(256,Magick::GRAYColorspace)
    end
     test.to_s_without_spaces.should eql("3R8Z")
  end

  it " get a error" do
    expect{ RTesseract.new(@path.join("images","test.jpg").to_s, {:command => "tesseract_error"}).to_s }.to raise_error(RTesseract::ConversionError)
    expect{ RTesseract.new(@path.join("images","test_not_exists.png").to_s).to_s }.to raise_error(RTesseract::ImageNotSelectedError)
  end
end
