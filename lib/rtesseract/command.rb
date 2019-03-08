class RTesseract
  class Command
    FIXED = %i[command psm oem lang tessdata_dir user_words user_patterns config_file].freeze

    attr_reader :options

    def initialize(source, output, errors, options)
      @source = source
      @output = output
      @options = options
      @errors = errors
      @full_command = [options.command, @source, @output]
    end

    def full_command
      add_option('--psm', options.psm)
      add_option('--oem', options.oem)
      add_option('-l', options.lang)
      add_option('--tessdata_dir', options.tessdata_dir)
      add_option('--user_words', options.user_words)
      add_option('--user_patterns', options.user_patterns)

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

      return output if status.success?

      raise RTesseract::Error, error
    end
  end
end
