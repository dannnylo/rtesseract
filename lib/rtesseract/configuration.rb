# frozen_string_literal: true

require 'ostruct'

class RTesseract
  class Configuration < OpenStruct
    def merge(options)
      RTesseract::Configuration.new(to_h.merge(options))
    end

    def command
      @table[:command]
    end
  end

  class << self
    def config
      @config ||= RTesseract::Configuration.new(
        command: 'tesseract',
        debug_file: '/dev/null'
      )
    end

    def configure
      yield(config) if block_given?
    end

    def reset_config!
      @config = nil
    end
  end
end
