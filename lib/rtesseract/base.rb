# frozen_string_literal: true

require 'tmpdir'
require 'securerandom'
require 'pathname'

class RTesseract
  module Base
    def temp_file_path
      Pathname.new(Dir.tmpdir).join("rtesseract_#{SecureRandom.uuid}").to_s
    end
  end
end
