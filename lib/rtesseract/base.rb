# frozen_string_literal: true

require 'tmpdir'
require 'securerandom'
require 'pathname'

class RTesseract
  module Base
    def temp_file_path
      Pathname.new(Dir.tmpdir).join("rtesseract_#{SecureRandom.uuid}").to_s
    end

    def remove_tmp_file(output_path)
      Dir["#{Dir.tmpdir}/*"].each do |filename|
        if filename.include?(output_path)
          File.delete(filename)
          break
        end
      end
    end
  end
end
