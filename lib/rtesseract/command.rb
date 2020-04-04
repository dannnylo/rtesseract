# frozen_string_literal: true

class RTesseract
  class Command
    FIXED = %i[command psm oem lang tessdata_dir user_words user_patterns config_file].freeze

    attr_reader :options

    def initialize(source, output_path, errors, options)
      @source = source
      @output_path = output_path
      @options = options
      @errors = errors
      @full_command = [options.command, @source, @output_path]
    end

    def full_command
      add_option('--psm', options.psm)
      add_option('--oem', options.oem)
      add_option('-l', options.lang)
      add_option('--tessdata-dir', options.tessdata_dir)
      add_option('--user-words', options.user_words)
      add_option('--user-patterns', options.user_patterns)

      other_configs

      add_option(options.config_file)

      @full_command
    end

    def add_option(*args)
      return unless args.last

      @full_command << args.map(&:to_s)
    end

    def other_configs
      @options.to_h.map do |key, value|
        next if FIXED.include?(key)

        add_option('-c', "#{key}=#{value}")
      end
    end

    def run
      output, error, status = Open3.capture3(*full_command.flatten)

      @errors.push(error)

      if status.success?
        return yield(@output_path) if block_given?

        return output
      end

      raise RTesseract::Error, error
    end
  end
end
