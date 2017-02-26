# encoding: UTF-8
# RTesseract
class RTesseract
  # Alternative approach to Mixed when you want to read from specific areas.
  # Requires `-psm 4` which means the text must be "a single column of text of variable sizes".
  class Uzn < RTesseract
    attr_reader :areas
    DEFAULT_ALPHABET = 'Text/Latin'

    def initialize(src = '', options = {})
      @areas = options.delete(:areas) || []
      @alphabet = options.delete(:alphabet) || DEFAULT_ALPHABET
      super(src, options.merge(psm: 4))
      yield self if block_given?
    end

    # Add areas
    def area(points)
      areas << points
    end

    def convert_command
      @image = image
      write_uzn_file
      `#{configuration.command} "#{@image}" "#{file_dest}" #{lang} #{psm} #{tessdata_dir} #{user_words} #{user_patterns} #{config_file} #{clear_console_output} #{options_cmd.join(' ')}`
    end

    def after_convert_hook
      RTesseract::Utils.remove_files([@uzn_file])
    end

    private

    def write_uzn_file
      folder = File.dirname(@image)
      basename = File.basename(@image, '.tif')
      @uzn_file = File.new("#{folder}/#{basename}.uzn", File::CREAT|File::TRUNC|File::RDWR)

      areas.each do |points|
        s = "#{points[:x]} #{points[:y]} #{points[:w]} #{points[:h]} #{@alphabet}\n"
        @uzn_file.write(s)
        @uzn_file.flush
      end
    end

  end
end
