# frozen_string_literal: true

class RTesseract
  module Tsv
    extend Base

    def self.run(source, temp_file_path, errors, options)
      options.tessedit_create_tsv = 1

      RTesseract::Command.new(source, temp_file_path, errors, options).run

      File.open("#{temp_file_path}.tsv", 'r')
    end
  end
end
