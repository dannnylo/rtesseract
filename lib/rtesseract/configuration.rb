# Configuration
class RTesseract
  class Configuration
    attr_accessor :processor, :lang, :psm

    def initialize
      @processor = 'rmagick'
    end

    def to_hash
      {processor: @processor, lang: lang, psm: psm}
    end
  end
end