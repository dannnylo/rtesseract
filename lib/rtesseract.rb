require "RMagick"
require "pathname"
require "tempfile"

class RTesseract
  VERSION = '0.0.2'
  attr_accessor :options
  attr_writer   :lang

  def initialize(src="", options={})
    @source  = Pathname.new src
    @command = options.delete(:command) || "tesseract"
    @lang    = options.delete(:lang) || options.delete("lang") || ""
    @options = options
    @value   = ""
  end

  def source= src
    @value = ""
    @source = Pathname.new src
  end

  def image_name
    @source.basename
  end

  #Convert image to tiff
  def image_to_tiff
    tmp_file = Pathname.new(Dir::tmpdir).join("#{@source.basename}.tif").to_s
    cat = Magick::ImageList.new @source.to_s
    cat.write tmp_file.to_s
    return tmp_file
  end

  #Remove files
  def remove_file(files=[])
    files.each do |file|
      begin
        File.unlink(file) if File.exist?(file)
      rescue
        system "rm -f #{file}"
      end
    end
    true
    rescue
      raise "Error on remove file."
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
    language = "#{@lang}".strip
    {"eng" => ["eng","en","en-us","english"], "deu" => ["deu"], "deu-f" => ["deu-f"] , "fra" => ["fra"], "ita" => ["ita","it"] , "nld" => ["nld"] , "por" => ["por","pt","pt-br","portuguese"] , "spa" => ["spa"] , "vie" => ["vie"]}.each do |value,names|
      return " -l #{value} " if names.include? language.downcase
    end
    ""
  rescue
    ""
  end

  def config
    @options ||= {}
    @options.collect{|k,v| "#{k} #{v}" }.join("\n")
  end

  def config_file
    #TODO: create the config
  end

  #Convert image to string
  def convert
    tmp_file  = Pathname.new(Dir::tmpdir).join("#{@source.basename}")
    tmp_image = image_to_tiff
    `#{@command} #{tmp_image} #{tmp_file.to_s} #{lang}`
    @value = File.read("#{tmp_file.to_s}.txt").to_s
    remove_file([tmp_image,"#{tmp_file.to_s}.txt"])
  rescue
    raise "Error on conversion."
  end

  #Output value
  def to_s
    return @value if @value != ""
    if @source.file?
      convert
      @value
    else
      raise "Select a image file."
    end
  end

  #Remove spaces and break-lines
  def to_s_without_spaces
    to_s.gsub(" ","").gsub("\n","").gsub("\r","")
  end
end

