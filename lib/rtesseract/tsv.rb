class RTesseract
  module Tsv
    extend Base

    def self.run(source, options)
      options.tessedit_create_tsv = 1

      RTesseract::Command.new(source, temp_file, options).run

      File.open(temp_file('.tsv'), 'r')
    end
  end
end