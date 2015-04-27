# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Rtesseract::Box" do
  before do
    @path = Pathname.new(__FILE__.gsub("rtesseract_box_spec.rb","")).expand_path
    @image_tiff = @path.join("images","test.tif").to_s
  end


  it "bounding box" do
    RTesseract::Box.new(@image_tiff).characters.is_a?(Array).should == true
    RTesseract::Box.new(@image_tiff).characters.should eql([
      {:char=>"4", :x_start=>145, :y_start=>14, :x_end=>159, :y_end=>33},
      {:char=>"3", :x_start=>184, :y_start=>14, :x_end=>196, :y_end=>33},
      {:char=>"X", :x_start=>222, :y_start=>14, :x_end=>238, :y_end=>32},
      {:char=>"F", :x_start=>260, :y_start=>14, :x_end=>273, :y_end=>32}]
    )
  end
end
