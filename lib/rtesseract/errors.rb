# RTesseract
class RTesseract
  # Class of error with storage of normal errors
  class ErrorWithMemory < StandardError
    attr_accessor :old_error

    def initialize(stored_error = nil)
      @old_error = stored_error
    end
  end

  class ConversionError < ErrorWithMemory; end
  class ImageNotSelectedError < ErrorWithMemory; end
  class TempFilesNotRemovedError < ErrorWithMemory; end
end
