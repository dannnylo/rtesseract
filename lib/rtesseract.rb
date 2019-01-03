require "rtesseract/check"
require "rtesseract/configuration"
require "rtesseract/command"
require "rtesseract/base"
require "rtesseract/text"
require "rtesseract/pdf"
require "rtesseract/box"
require "rtesseract/tsv"

class RTesseract
  class Error < StandardError; end

  attr_reader :config, :source

  def initialize(src = '', options = {})
    @source = src
    @config = RTesseract.config.merge(options)
  end

  def to_box
    Box.run(@source, config)
  end

  def words
    to_box.map { |word| word[:word] }
  end

  def to_pdf
    Pdf.run(@source, config)
  end

  def to_tsv
    Tsv.run(@source, config)
  end

  # Output value
  def to_s
    Text.run(@source, config)
  end

  # Remove spaces and break-lines
  def to_s_without_spaces
    to_s.gsub(/\s/, '')
  end
end
