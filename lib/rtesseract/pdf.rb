class RTesseract
  module Pdf
    extend Base

    def self.run(source, errors, options)
      options.tessedit_create_pdf = 1

      RTesseract::Command.new(source, temp_file, errors, options).run

      File.open(temp_file('.pdf'), 'r')
    end
  end
end
