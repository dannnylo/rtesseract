# frozen_string_literal: true

require 'tmpdir'
require 'securerandom'
require 'pathname'

class RTesseract
  module Base
    def temp_file(ext = '')
      @rand_file ||= "rtesseract_#{SecureRandom.uuid}"

      Pathname.new(Dir.tmpdir).join("#{@rand_file}#{ext}").to_s
    end
  end
end
