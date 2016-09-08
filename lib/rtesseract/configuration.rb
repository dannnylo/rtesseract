# RTesseract
class RTesseract
  # Aliases to languages names
  LANGUAGES = {
    'en' => 'eng',
    'en-us' => 'eng',
    'english' => 'eng',
    'pt' => 'por',
    'pt-br' => 'por',
    'portuguese' => 'por',
    'it' => 'ita',
    'sp' => 'spa'
  }.freeze

  # Configuration class
  class Configuration
    attr_accessor :processor, :lang, :psm, :tessdata_dir, :user_words, :user_patterns, :command, :debug, :options_cmd

    def initialize
      @processor = 'rmagick'
    end

    # Global configuration
    def parent
      @parent ||= RTesseract.configuration || RTesseract::Configuration.new
    end

    # Set value of option
    def option(options, name, default = nil)
      self.instance_variable_set("@#{name}", options.option(name, parent.send(name)) || default)
    end

    # Return the values of options
    def load_options(options, names = [])
      names.each { |name| option(options, name, nil) }
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
    self.clear_pdf_option
  end

  # Clear pdf option
  def self.clear_pdf_option
    if self.configuration.options_cmd
      self.configuration.options_cmd.delete('pdf')
      self.configuration.options_cmd.delete(:pdf)
    end
  end

  # Default command
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
      config.load_options(options, [:lang, :psm, :tessdata_dir, :user_words, :user_patterns])
      config.debug = config.option(options, :debug, false)
      pdf_opts = lambda { |o| o == 'pdf' || o == :pdf }
      config.options_cmd = [options.option(:options, nil)].delete_if(&pdf_opts).flatten.compact
    end
  end
end
