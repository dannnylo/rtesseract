require "RMagick"
module RMagickProcessor
  def image_to_tiff
    generate_uid
    tmp_file = Pathname.new(Dir::tmpdir).join("#{@uid}_#{@source.basename}.tif").to_s
    cat = @instance || Magick::Image.read(@source.to_s).first
    cat.crop!(@x, @y, @w, @h) unless [@x, @y, @w, @h].compact == []
    cat.write tmp_file.to_s
    return tmp_file
  end

  def image_from_blob(blob)
    generate_uid
    tmp_file = Pathname.new(Dir::tmpdir).join("#{@uid}_#{@source.basename}.tif").to_s
    cat = @instance || Magick::Image.from_blob(blob).first
    cat.crop!(@x, @y, @w, @h) unless [@x, @y, @w, @h].compact == []
    cat.write tmp_file.to_s
    return tmp_file
  end

  def is_a_instance?(object)
    object.class == Magick::Image
  end
end

