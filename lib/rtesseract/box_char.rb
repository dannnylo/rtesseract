# encoding: UTF-8
class RTesseract
  # Class to read char positions from an image
  class BoxChar < RTesseract
    def initialize(src = '', options = {})
      super
      @value, @x, @y, @w, @h = [[]]
    end

    def characters
      convert if @value == []
      @value
    end

    def text_file
      @text_file = Pathname.new(Dir.tmpdir).join("#{Time.now.to_f}#{rand(1500)}.box").to_s
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

      `#{@command} "#{image}" "#{text_file.gsub('.box','')}" #{lang} #{psm} #{config_file} #{clear_console_output}`
      convert_text(File.read(@text_file).to_s)
      remove_file([@image, @text_file])
    rescue => error
      puts error.inspect
      puts error.backtrace
      raise RTesseract::ConversionError.new(error)
    end

    # Output value
    def to_s
      return @value if @value != ''
      if @processor.image?(@source) || @source.file?
        convert
        @value.map{|char| char[:char]}.join(' ')
      else
        fail RTesseract::ImageNotSelectedError.new(@source)
      end
    end

  end
end
