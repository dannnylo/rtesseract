class RTesseract
  module Pdf
    extend Base

    def self.run(source, options)
      options.tessedit_create_pdf = 1

      RTesseract::Command.new(source, temp_file, options).run

      File.open(temp_file('.pdf'), 'r')
    end
  end
end