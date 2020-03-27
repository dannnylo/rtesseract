# frozen_string_literal: true

class RTesseract
  module Pdf
    extend Base

    def self.run(source, errors, options)
      options.tessedit_create_pdf = 1

      RTesseract::Command.new(source, temp_file_path, errors, options).run do |output_path|
        File.open("#{output_path}.pdf", 'r')
      end
    end
  end
end
