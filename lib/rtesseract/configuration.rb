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

    def parent
      @parent ||= RTesseract.configuration || RTesseract::Configuration.new
    end

    def option(options, name, default = nil)
      self.instance_variable_set("@#{name}", options.option(name, parent.send(name)) || default)
    end

    def load_options(options, names = [])
      names.each{ |name| option(options, name, nil) }
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
    RTesseract::Configuration.new.tap do |config|
      config.command = config.option(options, :command, RTesseract.default_command)
      config.processor = config.option(options, :processor, 'rmagick')
      config.load_options(options, [ :lang, :psm, :tessdata_dir, :user_words, :user_patterns ])
      config.debug = config.option(options, :debug, false)
      config.options_cmd = [options.option(:options, nil)].flatten.compact
    end
  end
end