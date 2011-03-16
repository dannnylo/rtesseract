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

      mix_block = RTesseract::Mixed.new(@image_tiff,{:areas => [
        {:x => 28,  :y=>19, :width=>25, :height=>25 }, #position of 4
        {:x => 180,  :y=>22, :width=>20, :height=>28}, # position of 3
        {:x => 218,  :y=>22, :width=>24, :height=>28}, # position of z
        {:x => 248,  :y=>24, :width=>22, :height=>22}  # position of z
      ]})
      assert_equal mix_block.to_s_without_spaces , "43ZZ"
    end
  end
end

