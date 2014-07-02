# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Rtesseract::Box" do
  before do
    @path = Pathname.new(__FILE__.gsub("rtesseract_box_spec.rb","")).expand_path
    @image_tiff = @path.join("images","test.tif").to_s
  end


  it "bounding box" do
    RTesseract::Box.new(@image_tiff).characters.is_a?(Array).should be_true
    RTesseract::Box.new(@image_tiff).characters.should eql([
      {:char=>"4", :x_start=>145, :y_start=>14, :x_end=>159, :y_end=>33},
      {:char=>"3", :x_start=>184, :y_start=>14, :x_end=>196, :y_end=>33},
      {:char=>"Z", :x_start=>219, :y_start=>14, :x_end=>236, :y_end=>33},
      {:char=>"Z", :x_start=>255, :y_start=>14, :x_end=>269, :y_end=>33}
    ])


  end
end
