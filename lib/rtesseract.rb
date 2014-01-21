# encoding: UTF-8
require "pathname"
require "tempfile"

require "rtesseract/errors"
require "rtesseract/mixed"

class RTesseract
  attr_accessor :options
  attr_writer   :lang
  attr_writer   :psm
  attr_reader   :processor

  def initialize(src = "", options = {})
    @command = options.delete(:command) || default_command
    @lang    = options.delete(:lang)    || options.delete("lang") || ""
    @psm     = options.delete(:psm)     || options.delete("psm")  || nil
    @clear_console_output = options.delete(:clear_console_output)
    @clear_console_output = true if @clear_console_output.nil?
    @options = options
    @value   = ""
    @x, @y, @w, @h = []
    @processor = options.delete(:processor) || options.delete("processor")
    choose_processor!
    if is_a_instance?(src)
      @source = Pathname.new '.'
      @instance = src
    else
      @instance = nil
      @source  = Pathname.new src
    end
  end

  def default_command
    TesseractBin::Executables[:tesseract] || 'tesseract'
  rescue
    "tesseract"
  end

  def self.read(src = nil, options = {}, &block)
    raise RTesseract::ImageNotSelectedError if src == nil
    processor = options.delete(:processor) || options.delete("processor")
    if processor == "mini_magick"
      image = MiniMagickProcessor.read_with_processor(src.to_s)
    else
      image = RMagickProcessor.read_with_processor(src.to_s)
    end
    yield image
    object = RTesseract.new("", options)
    object.from_blob(image.to_blob)
    object
  end

  def source= src
    @value = ""
    @source = Pathname.new src
  end

  def image_name
    @source.basename
  end


  #Crop image to convert
  def crop!(x,y,width,height)
    @x, @y, @w, @h = x, y, width, height
    self
  end

  #Remove files
  def remove_file(files=[])
      files.each do |file|
        if file.is_a?(Tempfile)
          file.close
          file.unlink
        else
          File.unlink(file)
        end
      end
    true
  rescue
    raise RTesseract::TempFilesNotRemovedError
  end

  # Select the language
  #===Languages
  ## * eng   - English
  ## * deu   - German
  ## * deu-f - German fraktur
  ## * fra   - French
  ## * ita   - Italian
  ## * nld   - Dutch
  ## * por   - Portuguese
  ## * spa   - Spanish
  ## * vie   - Vietnamese
  ## Note: Make sure you have installed the language to tesseract
  def lang
    language = "#{@lang}".strip.downcase
    { #Aliases to languages names
      "eng" => ["en","en-us","english"],
      "ita" => ["it"],
      "por" => ["pt","pt-br","portuguese"],
      "spa" => ["sp"]
    }.each do |value,names|
      return " -l #{value} " if names.include? language
    end
    return " -l #{language} " if language.size > 0
    ""
  rescue
    ""
  end

  #Page Segment Mode
  def psm
    @psm.nil? ? "" : " -psm #{@psm} "
  rescue
    ""
  end

  def config
    @options ||= {}
    @options.collect{|k,v| "#{k} #{v}" }.join("\n")
  end

  def config_file
    return "" if @options == {}
    conf = Tempfile.new("config")
    conf.write(config)
    conf.flush
    conf.path
  end

  #TODO: Clear console for MacOS or Windows
  def clear_console_output
    return "" unless @clear_console_output
    return "2>/dev/null" if File.exist?("/dev/null") #Linux console clear
  end

  #Convert image to string
  def convert
    path = Pathname.new(Dir::tmpdir).join("#{Time.now.to_f}#{rand(1500)}.txt").to_s
    tmp_image = image_to_tiff
    `#{@command} "#{tmp_image.path}" "#{path.gsub(".txt","")}" #{lang} #{psm} #{config_file} #{clear_console_output}`
    @value = File.read(path).to_s
    remove_file([tmp_image, path])
  rescue
    raise RTesseract::ConversionError
  end

  #Read image from memory blob
  def from_blob(blob)
    blob_file = Tempfile.new("blob")
    blob_file.write(blob)
    blob_file.rewind
    blob_file.flush
    self.source = blob_file.path
    convert
    remove_file([blob_file])
  rescue
    raise RTesseract::ConversionError
  end

  #Output value
  def to_s
    return @value if @value != ""
    if @source.file? || !@instance.nil?
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

  private
  def choose_processor!
    if @processor.to_s == "mini_magick"
      require File.expand_path(File.dirname(__FILE__) + "/processors/mini_magick.rb")
      self.class.send(:include, MiniMagickProcessor)
    else
      require File.expand_path(File.dirname(__FILE__) + "/processors/rmagick.rb")
      self.class.send(:include, RMagickProcessor)
    end
  end
end

