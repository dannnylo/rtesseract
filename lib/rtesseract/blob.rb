# Blob methods
class RTesseract
  # Read image from memory blob
  def self.read(src = nil, options = {})
    fail RTesseract::ImageNotSelectedError if src.nil?
    processor = RTesseract::Processor.choose_processor!(options[:processor])
    image = processor.read_with_processor(src.to_s)
    yield(image)
    object = RTesseract.new('', options).from_blob(image.to_blob)
    object
  end

  # Read image from memory blob
  def read
    image = @processor.read_with_processor(@source.to_s)
    new_image = yield(image)
    from_blob(new_image.to_blob, File.extname(@source.to_s))
    self
  end

  # Read image from memory blob
  def from_blob(blob, ext = '')
    blob_file = Tempfile.new(['blob', ext], encoding: 'ascii-8bit')
    blob_file.binmode.write(blob)
    blob_file.rewind
    blob_file.flush
    self.source = blob_file.path
    convert
    RTesseract::Utils.remove_files([blob_file])
    self
  rescue => error
    raise RTesseract::ConversionError.new(error), error, caller
  end
end
