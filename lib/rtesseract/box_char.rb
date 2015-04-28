# encoding: UTF-8
class RTesseract
  # Class to read char positions from an image
  class BoxChar < Box
    def file_ext
      '.box'
    end

    def characters
      convert if @value == []
      @value
    end

    def convert_text(text)
      text_objects = []
      text.each_line do |line|
        char, x_start, y_start, x_end, y_end, word = line.split(" ")
        text_objects << {:char => char, :x_start => x_start.to_i, :y_start => y_start.to_i , :x_end => x_end.to_i, :y_end => y_end.to_i}
      end
      @value = text_objects
    end

    # Convert image to string
    def convert
      @options ||= {}
      @options['tessedit_create_boxfile'] = 1 #Split chars

      `#{@command} "#{image}" "#{text_file}" #{lang} #{psm} #{config_file} #{clear_console_output}`
      convert_text(File.read(text_file_with_ext).to_s)
      remove_file([@image, text_file_with_ext])
    rescue => error
      raise RTesseract::ConversionError.new(error)
    end
  end
end
