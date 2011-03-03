require 'helper'
require 'pathname'

class TestMixed < Test::Unit::TestCase
  context "Path" do
    setup do
      @path = Pathname.new(__FILE__.gsub("test_mixed.rb","")).expand_path
      @image_tiff = @path.join("images","mixed.tif").to_s
      @image2_tiff = @path.join("images","mixed2.tif").to_s
    end

    should "be instantiable" do
      assert_equal RTesseract::Mixed.new.class , RTesseract::Mixed
      assert_equal RTesseract::Mixed.new(@image_tiff).class , RTesseract::Mixed
    end

    should "translate parts of the image to text" do
      mix_block = RTesseract::Mixed.new(@image_tiff) do |image|
       image.area(28,  19, 25, 25) #position of 4
       image.area(180, 22, 20, 28) # position of 3
       image.area(218, 22, 24, 28) # position of z
       image.area(248, 24, 22, 22) # position of z
      end
      assert_equal mix_block.to_s_without_spaces , "43ZZ"
    end
  end
end

