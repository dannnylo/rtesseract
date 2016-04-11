# Configuration
class RTesseract
  class Configuration
    attr_accessor :processor, :lang, :psm, :tessdata_dir, :user_words, :user_patterns

    def initialize
      @processor = 'rmagick'
    end

    def to_hash
      {processor: @processor, lang: lang, psm: psm, tessdata_dir: tessdata_dir, user_words: user_words, user_patterns: user_patterns}
    end
  end
end