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

  def self.local_or_global(options, option)
    parent_config = RTesseract.configuration || RTesseract::Configuration.new
    options.option(option, parent_config.send(option))
  end

  # Local config to instance
  def self.local_config(options = {})
    RTesseract::Configuration.new.tap do |config|
      config.command = local_or_global(options, :command) || RTesseract.default_command
      config.processor = local_or_global(options, :processor) || 'rmagick'

      config.lang = local_or_global(options, :lang)
      config.psm = local_or_global(options, :psm)

      config.tessdata_dir = local_or_global(options, :tessdata_dir)
      config.user_words = local_or_global(options, :user_words)
      config.user_patterns = local_or_global(options, :user_patterns)

      config.debug = local_or_global(options, :debug) || false
      config.options_cmd = [options.option(:options, nil)].flatten.compact
    end
  end
end