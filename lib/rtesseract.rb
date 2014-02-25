# encoding: UTF-8
require 'pathname'
require 'tempfile'

require 'rtesseract/errors'
require 'rtesseract/mixed'

# Processors
require 'processors/rmagick.rb'
require 'processors/mini_magick.rb'
require 'processors/quick_magick.rb'

# Ruby wrapper for Tesseract OCR
class RTesseract
  attr_accessor :options
  attr_writer   :lang
  attr_writer   :psm
  attr_reader   :processor

  OPTIONS = %w(command lang psm processor debug clear_console_output)
   # Aliases to languages names
  LANGUAGES = {
    'eng' => %w(en en-us english),
    'ita' => %w(it),
    'por' => %w(pt pt-br portuguese),
    'spa' => %w(sp)
  }

  def initialize(src = '', options = {})
    @options = command_line_options(options)
    @value, @x, @y, @w, @h = ['']
    @processor = RTesseract.choose_processor!(@processor)
    @source = @processor.image?(src) ? src : Pathname.new(src)
  end

  def fetch_option(options, name, default)
    options.fetch(name.to_s, options.fetch(name, default))
  end

  def command_line_options(options)
    @command    = fetch_option(options, :command, default_command)
    @lang       = fetch_option(options, :lang, '')
    @psm        = fetch_option(options, :psm, nil)
    @processor  = fetch_option(options, :processor, 'rmagick')
    @debug      = fetch_option(options, :debug, false)

    # Disable clear console if debug mode
    @clear_console_output = @debug ? false : fetch_option(options, :clear_console_output, true)

    options.delete_if { |k, v| OPTIONS.include?(k.to_s) }
    options
  end

  def default_command
    TesseractBin::Executables[:tesseract] || 'tesseract'
  rescue
    'tesseract'
  end

  def self.read(src = nil, options = {}, &block)
    fail RTesseract::ImageNotSelectedError if src.nil?
    processor = RTesseract.choose_processor!(options.delete(:processor) || options.delete('processor'))
    image = processor.read_with_processor(src.to_s)

    yield image
    object = RTesseract.new('', options)
    object.from_blob(image.to_blob)
    object
  end

  def source=(src)
    @value = ''
    @source = @processor.image?(src) ? src : Pathname.new(src)
  end

  # Crop image to convert
  def crop!(x, y, width, height)
    @value = ''
    @x, @y, @w, @h = x.to_i, y.to_i, width.to_i, height.to_i
    self
  end

  # Remove files
  def remove_file(files = [])
    files.each do |file|
      if file.is_a?(Tempfile)
        file.close
        file.unlink
      else
        File.unlink(file)
      end
    end
    true
  rescue => error
    raise RTesseract::TempFilesNotRemovedError.new(:error => error, :files => files)
  end

  # Select the language
  # ===Languages
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
    LANGUAGES.each do |value, names|
      return " -l #{value} " if names.include? language
    end
    return " -l #{language} " if language.size > 0
    ''
  rescue
    ''
  end

  # Page Segment Mode
  def psm
    (@psm.nil? ? '' : " -psm #{@psm} ")
  rescue
    ''
  end

  def config
    @options ||= {}
    @options.map { |k, v| "#{k} #{v}" }.join("\n")
  end

  def config_file
    return '' if @options == {}
    conf = Tempfile.new('config')
    conf.write(config)
    conf.flush
    conf.path
  end

  #TODO: Clear console for MacOS or Windows
  def clear_console_output
    return '' unless @clear_console_output
    return '2>/dev/null' if File.exist?('/dev/null') # Linux console clear
  end

  def image
    (@image = @processor.image_to_tif(@source, @x, @y, @w, @h)).path
  end

  def text_file
    @text_file = Pathname.new(Dir.tmpdir).join("#{Time.now.to_f}#{rand(1500)}.txt").to_s
  end

  # Convert image to string
  def convert
    `#{@command} "#{image}" "#{text_file.gsub('.txt', '')}" #{lang} #{psm} #{config_file} #{clear_console_output}`
    @value = File.read(@text_file).to_s
    remove_file([@image, @text_file])
  rescue => error
    raise RTesseract::ConversionError.new(error)
  end

  # Read image from memory blob
  def from_blob(blob)
    blob_file = Tempfile.new('blob')
    blob_file.write(blob)
    blob_file.rewind
    blob_file.flush
    self.source = blob_file.path
    convert
    remove_file([blob_file])
  rescue => error
    raise RTesseract::ConversionError.new(error)
  end

  # Output value
  def to_s
    return @value if @value != ''
    if @processor.image?(@source) || @source.file?
      convert
      @value
    else
      fail RTesseract::ImageNotSelectedError.new(@source)
    end
  end

  # Remove spaces and break-lines
  def to_s_without_spaces
    to_s.gsub(' ', '').gsub("\n", '').gsub("\r", '')
  end

  def self.choose_processor!(processor)
    processor =  if MiniMagickProcessor.a_name?(processor.to_s)
                    MiniMagickProcessor
                  elsif QuickMagickProcessor.a_name?(processor.to_s)
                    QuickMagickProcessor
                  else
                    RMagickProcessor
                  end
    processor.setup
    processor
  end
end

