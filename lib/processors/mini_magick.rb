# encoding: UTF-8
# Add to rtesseract a image manipulation with MiniMagick
module MiniMagickProcessor
  def self.setup(klass)
    require 'mini_magick'
  end

  def self.a_name?(name)
    %w(mini_magick MiniMagickProcessor).include?(name.to_s)
  end

  def self.image_to_tif(source, x = nil, y = nil, w = nil, h = nil)
    tmp_file = Tempfile.new(['', '.tif'])
    cat = source.is_a?(Pathname) ? read_with_processor(source.to_s) : source
    cat.format('tif') { |c| c.compress 'None' }
    cat.crop("#{w}x#{h}+#{x}+#{y}") unless [x, y, w, h].compact == []
    cat.write tmp_file.path.to_s
    tmp_file
  end

  def self.read_with_processor(path)
    MiniMagick::Image.open(path.to_s)
  end

  def self.image?(object)
    object.class == MiniMagick::Image
  end
end
