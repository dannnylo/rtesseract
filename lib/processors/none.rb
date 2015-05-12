# encoding: UTF-8
# Add to rtesseract a image without manipulation
module NoneProcessor
  def self.setup
  end

  def self.a_name?(name)
    %w(none NoneProcessor).include?(name.to_s)
  end

  def self.image_to_tif(source, _x = nil, _y = nil, _w = nil, _h = nil)
    tmp_file = Tempfile.new(['', '.tif'])
    tmp_file.write(self.read_with_processor(source))
    tmp_file
  end

  def self.need_crop?(*)
  end

  def self.read_with_processor(path)
    File.read(path)
  end

  def self.image?(object)
  end
end
