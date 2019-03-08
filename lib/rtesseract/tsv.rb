class RTesseract
  module Tsv
    extend Base

    def self.run(source, errors, options)
      options.tessedit_create_tsv = 1

      RTesseract::Command.new(source, temp_file, errors, options).run

      File.open(temp_file('.tsv'), 'r')
    end
  end
end
