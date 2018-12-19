
class RTesseract
  class << self
    def tesseract_version
      Open3.capture2e('tesseract', "--version").first.to_s.match(/\d.\d{2}/)[0].to_f
    end

    def check!
      check_version!
    end

    def check_version!
      raise 'Tesseract OCR 3.5 or later not installed' if RTesseract.tesseract_version < 3.05
    end
  end
end