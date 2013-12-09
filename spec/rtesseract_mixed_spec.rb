# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Rtesseract::Mixed" do
  before do
    @path = Pathname.new(__FILE__.gsub("rtesseract_mixed_spec.rb","")).expand_path
    @image_tiff = @path.join("images","mixed.tif").to_s
    @image2_tiff = @path.join("images","mixed2.tif").to_s
  end

  it "should be instantiable" do
    RTesseract::Mixed.new.class.should eql(RTesseract::Mixed)
    RTesseract::Mixed.new(@image_tiff).class.should eql(RTesseract::Mixed)
  end

  it "should translate parts of the image to text" do
    mix_block = RTesseract::Mixed.new(@image_tiff,{:psm=>7}) do |image|
      image.area(28,  19, 25, 25) #position of 4
      image.area(180, 22, 20, 28) # position of 3
      image.area(218, 22, 24, 28) # position of z
      image.area(248, 24, 22, 22) # position of z
    end
    mix_block.to_s_without_spaces.should eql("43ZZ")

    mix_block = RTesseract::Mixed.new(@image_tiff,{:areas => [
      {:x => 28,  :y=>19, :width=>25, :height=>25 }, #position of 4
      {:x => 180,  :y=>22, :width=>20, :height=>28}, # position of 3
      {:x => 218,  :y=>22, :width=>24, :height=>28}, # position of z
      {:x => 248,  :y=>24, :width=>22, :height=>22}  # position of z
    ],:psm=>7})
    mix_block.to_s_without_spaces.should eql("43ZZ")
  end
end
