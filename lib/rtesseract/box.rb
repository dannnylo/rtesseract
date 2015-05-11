# encoding: UTF-8
require "nokogiri"

class RTesseract
  # Class to read char positions from an image
  class Box < RTesseract
    def initialize(src = '', options = {})
      super
      @value, @x, @y, @w, @h = [[]]
    end

    def words
      convert if @value == []
      @value
    end

    def file_ext
      '.hocr'
    end

    def convert_text(text)
      html = Nokogiri::HTML(text)
      text_objects = []
      html.css('span.ocrx_word, span.ocr_word').each do |word|
        attributes = word.attributes['title'].value.to_s.gsub(';', '').split(' ')
        text_objects << {:word => word.text, :x_start => attributes[1].to_i, :y_start => attributes[2].to_i , :x_end => attributes[3].to_i, :y_end => attributes[4].to_i}
      end
      @value = text_objects
    end

    # Convert image to string
    def convert
      @options ||= {}
      @options['tessedit_create_hocr'] = 1   #Split Words configuration

      `#{@command} "#{image}" "#{text_file}" #{psm} #{lang} #{config_file} #{clear_console_output}`
      ext = File.exist?(text_file_with_ext) ? file_ext : '.html'
      convert_text(File.read(text_file_with_ext(ext)))
      remove_file([@image, text_file_with_ext(ext)])
    rescue => error
      raise RTesseract::ConversionError.new(error)
    end

    # Output value
    def to_s
      return @value.map{|word| word[:word]} if @value != []
      if @processor.image?(@source) || @source.file?
        convert
        @value.map{|word| word[:word]}.join(' ')
      else
        fail RTesseract::ImageNotSelectedError.new(@source)
      end
    end
  end
end
