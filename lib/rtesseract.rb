# frozen_string_literal: true

require 'tmpdir'
require 'securerandom'
require 'pathname'
require 'rtesseract/check'
require 'rtesseract/configuration'
require 'rtesseract/command'
require 'rtesseract/base'
require 'rtesseract/text'
require 'rtesseract/pdf'
require 'rtesseract/box'
require 'rtesseract/tsv'

class RTesseract
  class Error < StandardError; end

  attr_reader :config, :source

  def initialize(src = '', options = {})
    @source = src
    @config = RTesseract.config.merge(options)
    @errors = []
  end

  def to_box
    temp_file_path = new_temp_file_path
    Box.run(@source, temp_file_path, @errors, config)
  end

  def words
    to_box.map { |word| word[:word] }
  end

  def to_pdf
    temp_file_path = new_temp_file_path
    Pdf.run(@source, temp_file_path, @errors, config)
  end

  def to_tsv
    temp_file_path = new_temp_file_path
    Tsv.run(@source, temp_file_path, @errors, config)
  end

  # Output value
  def to_s
    Text.run(@source, @errors, config)
  end

  # Remove spaces and break-lines
  def to_s_without_spaces
    to_s.gsub(/\s/, '')
  end

  def new_temp_file_path
    rand_file ||= "rtesseract_#{SecureRandom.uuid}"
    Pathname.new(Dir.tmpdir).join("#{rand_file}").to_s
  end

  attr_reader :errors
end
