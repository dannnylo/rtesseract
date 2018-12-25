require "rtesseract/check"
require "rtesseract/command"
require "rtesseract/text"
require "rtesseract/pdf"
require "rtesseract/box"
require "rtesseract/tsv"

class RTesseract
  class Error < StandardError; end

  check_version!

  def initialize(src = '', options = {})
    @source = src
    @options = options
  end

  def to_box
    Box.run(@source, @options)
  end

  def words
    to_box.map { |word| word[:word] }
  end

  def to_pdf
    Pdf.run(@source, @options)
  end

  def to_tsv
    Tsv.run(@source, @options)
  end

  # Output value
  def to_s
    Text.run(@source, @options)
  end

  # Remove spaces and break-lines
  def to_s_without_spaces
    to_s.gsub(/\s/, '')
  end
end
