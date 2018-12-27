require 'tmpdir'

class RTesseract
  class Command
    FIXED = [:command, :psm, :oem, :lang, :tessdata_dir, :user_words, :user_patterns]

    attr_reader :options

    def initialize(source, output, options)
      @source = source
      @output = output
      @options = options
    end

    def configs
      @options.to_h.map { |key, value| ['-c', "#{key}=#{value}"] unless FIXED.include?(key) }.compact
    end

    def full_command
      command = [options.command, @source, @output]

      command << ['--psm', options.psm.to_s] if options.psm
      command << ['--oem', options.oem.to_s] if options.oem
      command << ['-l', options.lang] if options.lang

      command << ['--tessdata_dir', options.tessdata_dir] if options.tessdata_dir
      command << ['--user_words', options.user_words] if options.user_words
      command << ['--user_patterns', options.user_patterns] if options.user_patterns

      command << configs

      command.flatten
    end

    def run
      Open3.capture2e(*full_command)
    end
  end
end