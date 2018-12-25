
class RTesseract
  class << self
    def tesseract_version
      Open3.capture2e('tesseract', "--version").first.to_s.match(/\d+.\d+/)[0].to_f
    rescue Errno::ENOENT
      0
    end

    def check_version!
      raise 'Tesseract OCR 3.5 or later not installed' if RTesseract.tesseract_version < 3.05
    end
  end
end