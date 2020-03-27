# frozen_string_literal: true

class RTesseract
  module Tsv
    extend Base

    def self.run(source, errors, options)
      options.tessedit_create_tsv = 1

      RTesseract::Command.new(source, temp_file_path, errors, options).run do |output_path|
        File.open("#{output_path}.tsv", 'r')
      end
    end
  end
end
