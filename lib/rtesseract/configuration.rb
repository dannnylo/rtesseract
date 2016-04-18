# Configuration
class RTesseract
  # Aliases to languages names
  LANGUAGES = {
    'eng' => %w(en en-us english),
    'ita' => %w(it),
    'por' => %w(pt pt-br portuguese),
    'spa' => %w(sp)
  }

  # Configuration class
  class Configuration
    attr_accessor :processor, :lang, :psm, :tessdata_dir, :user_words, :user_patterns, :command, :debug, :options_cmd

    def initialize
      @processor = 'rmagick'
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

  # Local config to instance
  def self.local_config(options = {})
    parent_config = RTesseract.configuration || RTesseract::Configuration.new
    RTesseract::Configuration.new.tap do |config|
      config.command = options.option(:command, parent_config.command) || RTesseract.default_command
      config.processor = options.option(:processor, parent_config.processor) || 'rmagick'

      config.lang = options.option(:lang, parent_config.lang)
      config.psm = options.option(:psm, parent_config.psm)

      config.tessdata_dir = options.option(:tessdata_dir, parent_config.tessdata_dir)
      config.user_words = options.option(:user_words, parent_config.user_words)
      config.user_patterns = options.option(:user_patterns, parent_config.user_patterns)

      config.debug = options.option(:debug, parent_config.debug) || false
      config.options_cmd = [options.option(:options, parent_config.options_cmd)].flatten.compact
    end
  end
end