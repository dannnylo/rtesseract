class RTesseract
  class Configuration
    attr_accessor :command, :lang, :psm, :oem, :tessdata_dir, :user_words, :user_patterns, :debug, :config_file, :options_cmd

    def initialize
      @command = 'tesseract'
    end
  end

  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield(config) if block_given?
    end

    def reset_config!
      @config = nil
    end
  end
end
