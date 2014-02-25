# encoding: UTF-8
# Add to rtesseract a image manipulation with QuickMagick
module QuickMagickProcessor
  def self.setup
    require 'quick_magick'
  end

  def self.a_name?(name)
    %w(quick_magick QuickMagickProcessor).include?(name.to_s)
  end

  def self.image_to_tif(source, x = nil, y = nil, w = nil, h = nil)
    tmp_file = Tempfile.new(['', '.tif'])
    cat = source.is_a?(Pathname) ? read_with_processor(source.to_s) : source
    cat.compress = 'None'
    cat.format = 'tif'
    cat.crop("#{w}x#{h}+#{x}+#{y}") if need_crop?( x, y, w, h)
    cat.write tmp_file.path.to_s
    tmp_file
  end

  def self.need_crop?(x = nil, y = nil, w = nil, h = nil)
    x.to_f + y.to_f + w.to_f + h.to_f > 0
  end

  def self.read_with_processor(path)
    QuickMagick::Image.read(path.to_s).first
  end

  def self.image?(object)
    object.class == QuickMagick::Image
  end
end
