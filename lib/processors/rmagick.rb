require 'rmagick'
module RMagickProcessor
  def image_to_tiff
    puts "processing with rmagick"
    generate_uid
    tmp_file = Pathname.new(Dir::tmpdir).join("#{@uid}_#{@source.basename}.tif").to_s
    cat = Magick::Image.read(@source.to_s).first
    cat.crop!(@x, @y, @w, @h) unless [@x, @y, @w, @h].compact == []
    cat.write tmp_file.to_s
    return tmp_file
  end
end