# Configuration
class RTesseract
  # Aliases to languages names
  LANGUAGES = {
    'eng' => %w(en en-us english),
    'ita' => %w(it),
    'por' => %w(pt pt-br portuguese),
    'spa' => %w(sp)
  }

  class Configuration
    attr_accessor :processor, :lang, :psm, :tessdata_dir, :user_words, :user_patterns, :command

    def initialize
      @processor = 'rmagick'
    end

    def to_hash
      {processor: @processor, lang: lang, psm: psm, tessdata_dir: tessdata_dir, user_words: user_words, user_patterns: user_patterns}
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.default_command
    TesseractBin::Executables[:tesseract] || 'tesseract'
  rescue
    'tesseract'
  end

  def self.local_config(options = {})
    parent_config = RTesseract.configuration || RTesseract::Configuration.new

    current_config = RTesseract::Configuration.new
    current_config.command = options.option(:command, parent_config.command) || RTesseract.default_command
    current_config.processor = options.option(:processor, parent_config.processor) || 'rmagick'

    current_config.lang = options.option(:lang, parent_config.lang)
    current_config.psm = options.option(:psm, parent_config.psm)

    current_config.tessdata_dir = options.option(:tessdata_dir, parent_config.tessdata_dir)
    current_config.user_words = options.option(:user_words, parent_config.user_words)
    current_config.user_patterns = options.option(:user_patterns, parent_config.user_patterns)

    current_config
  end

end