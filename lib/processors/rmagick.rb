# encoding: UTF-8
# Add to rtesseract a image manipulation with RMagick
module RMagickProcessor
  def self.setup
    require 'RMagick'
  end

  def self.a_name?(name)
    %w(rmagick MiniMagickProcessor).include?(name.to_s)
  end

  def self.image_to_tif(source, x = nil, y = nil, w = nil, h = nil)
    tmp_file = Tempfile.new(['', '.tif'])
    cat = source.is_a?(Pathname) ? read_with_processor(source.to_s) : source
    cat.crop!(x, y, w, h) unless [x, y, w, h].compact == []
    cat.write(tmp_file.path.to_s) { self.compression = Magick::NoCompression }
    tmp_file
  end

  def self.read_with_processor(path)
    Magick::Image.read(path.to_s).first
  end

  def self.image?(object)
    object.class == Magick::Image
  end
end
