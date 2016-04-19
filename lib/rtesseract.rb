# encoding: UTF-8
require 'pathname'
require 'tempfile'
require 'utils'

require 'rtesseract/configuration'
require 'rtesseract/errors'
require 'rtesseract/mixed'
require 'rtesseract/box'
require 'rtesseract/box_char'

# Processors
require 'processors/rmagick.rb'
require 'processors/mini_magick.rb'
require 'processors/none.rb'

# Ruby wrapper for Tesseract OCR
class RTesseract
  attr_accessor :configuration
  attr_reader :processor
  attr_reader :source

  def initialize(src = '', options = {})
    self.configuration = RTesseract.local_config(options)
    @options = options || {}
    @value, @points = [nil, {}]
    @processor = RTesseract.choose_processor!(self.configuration.processor)
    @source = @processor.image?(src) ? src : Pathname.new(src)
    initialize_hook
  end

  def initialize_hook
  end

  def self.read(src = nil, options = {})
    fail RTesseract::ImageNotSelectedError if src.nil?
    processor = RTesseract.choose_processor!(options.option(:processor, nil))
    image = processor.read_with_processor(src.to_s)
    yield(image)
    object = RTesseract.new('', options).from_blob(image.to_blob)
    object
  end

  def read
    image = @processor.read_with_processor(@source.to_s)
    new_image = yield(image)
    from_blob(new_image.to_blob, File.extname(@source.to_s))
    self
  end

  def source=(src)
    @value = nil
    @source = @processor.image?(src) ? src : Pathname.new(src)
  end

  # Crop image to convert
  def crop!(_points = {})
    @value = nil
    @points = _points
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
    raise RTesseract::TempFilesNotRemovedError.new(error: error, files: files)
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
    language = "#{self.configuration.lang}".strip.downcase
    LANGUAGES.each do |value, names|
      return " -l #{value} " if names.include? language
    end
    return " -l #{language} " if language.size > 0
    ''
  rescue
    ''
  end

  def option_to_string(prefix, value = nil)
    (value.nil? ? '' : " #{prefix} #{value} ")
  rescue
    ''
  end

  # Page Segment Mode
  def psm
    option_to_string('-psm', self.configuration.psm)
  end

  # Tessdata Dir
  def tessdata_dir
    option_to_string('--tessdata-dir', self.configuration.tessdata_dir)
  end

  # User Words
  def user_words
    option_to_string('--user-words', self.configuration.user_words)
  end

  # User Patterns
  def user_patterns
    option_to_string('--user-patterns', self.configuration.user_patterns)
  end

  # Options on line
  def options_cmd
    self.configuration.options_cmd
  end

  def config_hook
  end

  def config
    @options ||= {}
    config_hook
    @options.map { |k, v| "#{k} #{v}" }.join("\n")
  end

  def config_file
    config_hook
    return '' if @options == {}
    conf = Tempfile.new('config')
    conf.write(config)
    conf.flush
    conf.path
  end

  # TODO: Clear console for MacOS or Windows
  def clear_console_output
    return '' if self.configuration.debug
    return '2>/dev/null' if File.exist?('/dev/null') # Linux console clear
  end

  def image
    (@image = @processor.image_to_tif(@source, @points)).path
  end

  def file_ext
    '.txt'
  end

  def text_file
    @text_file = Pathname.new(Dir.tmpdir).join("#{Time.now.to_f}#{rand(1500)}").to_s
  end

  def text_file_with_ext(ext = nil)
    [@text_file, ext || file_ext].join('')
  end

  def convert_command
    `#{self.configuration.command} "#{image}" "#{text_file}" #{lang} #{psm} #{tessdata_dir} #{user_words} #{user_patterns} #{config_file} #{clear_console_output} #{self.configuration.options_cmd.join(' ')}`
  end

  def convert_text
    @value = File.read(text_file_with_ext).to_s
  end

  def after_convert_hook
  end

  # Convert image to string
  def convert
    convert_command
    after_convert_hook
    convert_text
    remove_file([@image, text_file_with_ext])
  rescue => error
    raise RTesseract::ConversionError.new(error), error, caller
  end

  # Read image from memory blob
  def from_blob(blob, ext = '')
    blob_file = Tempfile.new(['blob', ext], encoding: 'ascii-8bit')
    blob_file.binmode.write(blob)
    blob_file.rewind
    blob_file.flush
    self.source = blob_file.path
    convert
    remove_file([blob_file])
    self
  rescue => error
    raise RTesseract::ConversionError.new(error), error, caller
  end

  # Output value
  def to_s
    return @value if @value != nil

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
    processor =
    if MiniMagickProcessor.a_name?(processor.to_s)
      MiniMagickProcessor
    elsif NoneProcessor.a_name?(processor.to_s)
      NoneProcessor
    else
      RMagickProcessor
    end
    processor.setup
    processor
  end
end
