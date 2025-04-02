# frozen_string_literal: true

require 'tmpdir'
require 'securerandom'
require 'pathname'

class RTesseract
  module Base
    def temp_file_path
      Pathname.new(Dir.tmpdir).join("rtesseract_#{SecureRandom.uuid}").to_s
    end

    def remove_tmp_file(absolute_file_path)
      File.delete(absolute_file_path) if File.file?(absolute_file_path)
    end
  end
end
