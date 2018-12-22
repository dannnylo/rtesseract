require 'tmpdir'

class RTesseract
  class Command
    def initialize(source, output, options = {})
      @source = source
      @output = output

      @psm = options.delete(:psm)
      @oem = options.delete(:oem)
      @lang = options.delete(:lang)

      @tessdata_dir = options.delete(:tessdata_dir)
      @user_words = options.delete(:user_words)
      @user_patterns = options.delete(:user_patterns)

      @options = { debug_file: '/dev/null' }.merge(options)
    end

    def configs
      @options.map { |key, value| ['-c', "#{key}=#{value}"] }
    end

    def full_command
      command = ['tesseract', @source, @output]

      command << ['--psm', @psm] if @psm
      command << ['--oem', @oem] if @oem
      command << ['-l', @lang] if @lang

      command << ['--tessdata_dir', @tessdata_dir] if @tessdata_dir
      command << ['--user_words', @user_words] if @user_words
      command << ['--user_patterns', @user_patterns] if @user_patterns

      command << configs

      command.flatten
    end

    def run
      Open3.capture2e(*full_command)
    end
  end
end