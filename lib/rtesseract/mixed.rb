# encoding: UTF-8
class RTesseract
  # Class to read an image from specified areas
  class Mixed
    attr_reader :areas

    def initialize(src = '', options = {})
      @source  = Pathname.new src
      @options = options
      @value   = ''
      @areas = options.delete(:areas) || []
      yield self if block_given?
    end

    def area(_points)
      @value = ''
      @areas << _points
    end

    def clear_areas
      @areas = []
    end

    # Convert parts of image to string
    def convert
      @value = []
      @areas.each_with_object(RTesseract.new(@source.to_s, @options.dup)) do |area, image|
        image.crop!(area)
        @value << image.to_s
      end
    rescue => error
      raise RTesseract::ConversionError.new(error), error, caller
    end

    # Output value
    def to_s
      return @value if @value != ''
      if @source.file?
        convert
        @value.join
      else
        fail RTesseract::ImageNotSelectedError.new(@source)
      end
    end

    # Remove spaces and break-lines
    def to_s_without_spaces
      to_s.gsub(' ', '').gsub("\n", '').gsub("\r", '')
    end
  end
end
