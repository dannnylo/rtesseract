# encoding: UTF-8
require 'nokogiri'
require 'fileutils'

# RTesseract
class RTesseract
  # Class to read char positions from an image
  class Box < RTesseract
    # Setting value as blank array
    def initialize_hook
      @value = []
    end

    # Aditional options to config file
    def config_hook
      @options['tessedit_create_hocr'] = 1 # Split Words configuration
    end

    # Words converted
    def words
      convert if @value == []
      @value
    end

    # Extension of file
    def file_ext
      '.hocr'
    end

    # Read the result file
    def parse_file
      html = Nokogiri::HTML(File.read(file_with_ext))
      html.css('span.ocrx_word, span.ocr_word')
    end

    # Return words to value
    def convert_text
      text_objects =  []
      parse_file.each { |word| text_objects << BoxParser.new(word).to_h }
      @value = text_objects
    end

    # Move file html to hocr
    def after_convert_hook
      FileUtils.mv(file_with_ext('.html'), file_with_ext) rescue nil
    end

    # Output value
    def to_s
      return @value.map { |word| word[:word] } if @value != []
      if @processor.image?(@source) || @source.file?
        convert
        @value.map { |word| word[:word] }.join(' ')
      else
        fail RTesseract::ImageNotSelectedError.new(@source)
      end
    end

    # Parse word data from html.
    class BoxParser
      def initialize(word_html)
        @word = word_html
        title = @word.attributes['title'].value.to_s
        @attributes = title.gsub(';', '').split(' ')
      end

      # Hash of word and position
      def to_h
        {
          word: @word.text,
          x_start: @attributes[1].to_i,
          y_start: @attributes[2].to_i,
          x_end: @attributes[3].to_i,
          y_end: @attributes[4].to_i
        }
      end
    end
  end
end
