# encoding: UTF-8
# Add to rtesseract a image manipulation with RMagick
module RMagickProcessor
  def self.setup
    require 'rmagick'
  rescue LoadError
    # :nocov:
    require 'RMagick'
    # :nocov:
  end

  def self.a_name?(name)
    %w(rmagick RMagickProcessor).include?(name.to_s)
  end

  def self.image_to_tif(source, _points = {})
    tmp_file = Tempfile.new(['', '.tif'])
    cat = source.is_a?(Pathname) ? read_with_processor(source.to_s) : source
    cat.crop!(_points[:x], _points[:y], _points[:w], _points[:h]) if _points.is_a?(Hash) && _points.values.compact != []
    cat.alpha Magick::DeactivateAlphaChannel
    cat.write(tmp_file.path.to_s) do
      # self.depth = 16
      self.compression = Magick::NoCompression
    end
    tmp_file
  end

  def self.read_with_processor(path)
    Magick::Image.read(path.to_s).first
  end

  def self.image?(object)
    object.class == Magick::Image
  end
end
