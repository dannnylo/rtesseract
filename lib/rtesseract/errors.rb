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
  
  class TesseractVersionError < StandardError 
    def initialize 
      super "Tesseract version is unknown or below 3.03 which is required for pdf output."
    end
  end
end
