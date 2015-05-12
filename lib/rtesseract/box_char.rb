# encoding: UTF-8
class RTesseract
  # Class to read char positions from an image
  class BoxChar < Box
    def config_hook
      @options['tessedit_create_boxfile'] = 1 # Split chars
    end

    alias_method :characters, :words

    def file_ext
      '.box'
    end

    def parse_file
      File.read(text_file_with_ext).to_s
    end

    def convert_text
      text_objects = []
      parse_file.each_line do |line|
        char, x_start, y_start, x_end, y_end, word = line.split(' ')
        text_objects << { :char => char, :x_start => x_start.to_i, :y_start => y_start.to_i , :x_end => x_end.to_i, :y_end => y_end.to_i }
      end
      @value = text_objects
    end
  end
end
