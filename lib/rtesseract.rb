require "RMagick"
require "pathname"
require "tempfile"

class RTesseract
  VERSION = '0.0.5'
  attr_accessor :options
  attr_writer   :lang

  def initialize(src="", options={})
    @uid = options.delete(:uid) || nil
    @source  = Pathname.new src
    @command = options.delete(:command) || "tesseract"
    @lang    = options.delete(:lang) || options.delete("lang") || ""
    @options = options
    @value   = ""
    @x,@y,@w,@h = []
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
    generate_uid
    tmp_file = Pathname.new(Dir::tmpdir).join("#{@uid}_#{@source.basename}.tif").to_s
    cat = Magick::Image.read(@source.to_s).first
    cat.crop!(@x, @y, @w, @h) unless [@x,@y,@w,@h].compact == []
    cat.write tmp_file.to_s
    return tmp_file
  end

  #Crop image to convert
  def crop!(x,y,width,height)
    @x, @y, @w, @h = x, y, width, height
    self
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

  def generate_uid
    @uid = rand.to_s[2,10] if @uid.nil?
    @uid
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
    {"eng" => ["eng","en","en-us","english"], "qru" => ["qru"], "deu" => ["deu"], "deu-f" => ["deu-f"] , "fra" => ["fra"], "ita" => ["ita","it"] , "nld" => ["nld"] , "por" => ["por","pt","pt-br","portuguese"] , "spa" => ["spa"] , "vie" => ["vie"]}.each do |value,names|
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
    return "" if @options == {}
    conf = Tempfile.new("config")
    conf.write(config)
    conf.path
  end

  #Convert image to string
  def convert
    generate_uid
    tmp_file  = Pathname.new(Dir::tmpdir).join("#{@uid}_#{@source.basename}")
    tmp_image = image_to_tiff
    `#{@command} #{tmp_image} #{tmp_file.to_s} #{lang} #{config_file}`
    @value = File.read("#{tmp_file.to_s}.txt").to_s
    @uid = nil
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

