require 'mini_magick'
module MiniMagickProcessor
  extend self
  def image_to_tiff
    tmp_file = Tempfile.new(["",".tif"])
    cat = @instance || read_with_processor(@source.to_s)
    cat.format("tif")
    cat.crop("#{@w}x#{@h}+#{@x}+#{@y}") unless [@x, @y, @w, @h].compact == []
    cat.write tmp_file.to_s
    return tmp_file
  end

  def read_with_processor(path)
    MiniMagick::Image.open(path.to_s)
  end

  def is_a_instance?(object)
    object.class == MiniMagick::Image
  end
end

