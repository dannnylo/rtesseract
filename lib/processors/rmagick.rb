require "RMagick"
module RMagickProcessor
  extend self
  def image_to_tiff
    tmp_file = Tempfile.new(["",".tif"])
    cat = @instance || Magick::Image.read(@source.to_s).first
    cat.crop!(@x, @y, @w, @h) unless [@x, @y, @w, @h].compact == []
    cat.write tmp_file.path.to_s, "-compress none"
    return tmp_file
  end

  def read_with_processor(path)
    Magick::Image.read(path.to_s).first
  end

  def is_a_instance?(object)
    object.class == Magick::Image
  end
end

