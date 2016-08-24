# encoding: UTF-8
require 'pathname'
require 'tempfile'

require 'rtesseract/utils'
require 'rtesseract/configuration'
require 'rtesseract/errors'

# Ruby wrapper for Tesseract OCR
class RTesseract
  attr_accessor :configuration
  attr_reader :processor
  attr_reader :source

  def initialize(src = '', options = {})
    self.configuration = RTesseract.local_config(options)
    @options = options || {}
    @points = {}
    @processor = RTesseract::Processor.choose_processor!(configuration.processor)
    self.source = src
    initialize_hook
  end

  # Hook to end of initialize method
  def initialize_hook
  end

  # Define the source
  def source=(src)
    @value = nil
    @source = @processor.image?(src) ? src : Pathname.new(src)
  end

  # Crop image to convert
  def crop!(points = {})
    @value = nil
    @points = points
    self
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
    language = (configuration.lang || 'eng').to_s.strip.downcase
    " -l #{LANGUAGES[language] || language} "
  rescue
    ''
  end

  # Convert option to command
  def option_to_string(prefix, value = nil)
    (value.nil? ? '' : " #{prefix} #{value} ")
  rescue
    ''
  end

  # Page Segment Mode
  def psm
    option_to_string('-psm', configuration.psm)
  end

  # Tessdata Dir
  def tessdata_dir
    option_to_string('--tessdata-dir', configuration.tessdata_dir)
  end

  # User Words
  def user_words
    option_to_string('--user-words', configuration.user_words)
  end

  # User Patterns
  def user_patterns
    option_to_string('--user-patterns', configuration.user_patterns)
  end

  # Options on line
  def options_cmd
    configuration.options_cmd
  end

  # Hook to before config
  def config_hook
  end

  # Convert configurations
  def config
    @options ||= {}
    config_hook
    @options.map { |k, v| "#{k} #{v}" }.join("\n")
  end

  # Write config to file
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
    return '' if configuration.debug
    return '2>/dev/null' if File.exist?('/dev/null') # Linux console clear
  end

  # Get image
  def image
    (@image = @processor.image_to_tif(@source, @points)).path
  end

  # Extension of file
  def file_ext
    '.txt'
  end

  # Rand file path
  def file_dest
    @file_dest = Pathname.new(Dir.tmpdir).join("#{Time.now.to_f}#{rand(1500)}").to_s
  end

  # Full path of file with txt extension
  def file_with_ext(ext = nil)
    [@file_dest, ext || file_ext].join('')
  end

  # Is pdf output?
  def pdf?
    options_cmd.map(&:to_sym).include? :pdf
  end

  # Run command
  def convert_command
    `#{configuration.command} "#{image}" "#{file_dest}" #{lang} #{psm} #{tessdata_dir} #{user_words} #{user_patterns} #{config_file} #{clear_console_output} #{configuration.options_cmd.join(' ')}`
  end

  # Read result file
  def convert_text
    @value = File.read(file_with_ext).to_s
  end

  # Store pdf result path
  def obtain_pdf
    @pdf_path = file_with_ext('.pdf')
  end

  # Hook to convert
  def after_convert_hook
  end

  # Convert image to string
  def convert
    convert_command
    after_convert_hook
    if pdf?
      obtain_pdf
    else
      convert_text
      RTesseract::Utils.remove_files([@image, file_with_ext])
    end
  rescue => error
    raise RTesseract::ConversionError.new(error), error, caller
  end

  # Output value
  def to_s
    return @value if @value != nil || pdf?

    if @processor.image?(@source) || @source.file?
      convert
      @value
    else
      fail RTesseract::ImageNotSelectedError.new(@source)
    end
  end

  # Remove spaces and break-lines
  def to_s_without_spaces
    to_s.gsub(/\s/, '')
  end

  # Output pdf path
  def to_pdf
    return @pdf_path if @pdf_path != nil && pdf?

    if @processor.image?(@source) || @source.file?
      convert
    else
      fail RTesseract::ImageNotSelectedError.new(@source)
    end
  end

  # Destroy pdf file
  def clean
    RTesseract::Utils.remove_files([@pdf_path])
  end

end

require 'rtesseract/mixed'
require 'rtesseract/box'
require 'rtesseract/box_char'
require 'rtesseract/blob'
require 'rtesseract/processor'

# Processors
require 'processors/rmagick.rb'
require 'processors/mini_magick.rb'
require 'processors/none.rb'
