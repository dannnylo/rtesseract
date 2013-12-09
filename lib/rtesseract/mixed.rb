# encoding: UTF-8
class RTesseract
  class Mixed
    def initialize(src="", options={})
      @source  = Pathname.new src
      @options = options
      @value   = ""
      @areas = options.delete(:areas) || []
      yield self if block_given?
    end

    def area(x, y, width, height)
      @value = ""
      @areas << {:x => x,  :y => y, :width => width, :height => height}
    end

    def areas
      @areas
    end

    def clear_areas
      @areas = []
    end

    #Convert parts of image to string
    def convert
      @value = ""
      @areas.each do |area|
        image = RTesseract.new(@source.to_s,@options.dup)
        image.crop!(area[:x].to_i, area[:y].to_i,  area[:width].to_i,  area[:height].to_i)
        @value << image.to_s
      end
    rescue
      raise RTesseract::ConversionError
    end

    #Output value
    def to_s
      return @value if @value != ""
      if @source.file?
        convert
        @value
      else
        raise RTesseract::ImageNotSelectedError
      end
    end

    #Remove spaces and break-lines
    def to_s_without_spaces
      to_s.gsub(" ","").gsub("\n","").gsub("\r","")
    end
  end
end

