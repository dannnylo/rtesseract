require 'nokogiri'

class RTesseract
  module Box
    extend RTesseract::Base

    def self.run(source, options)
      options.tessedit_create_hocr = 1

      RTesseract::Command.new(source, temp_file, options).run

      parse(File.read(temp_file('.hocr')))
    end

    def self.parse(content)
      html = Nokogiri::HTML(content)
      html.css('span.ocrx_word, span.ocr_word').map do |word|
        @attributes = word.attributes['title'].value.to_s.gsub(';', '').split(' ')

        {
          word: word.text,
          x_start: @attributes[1].to_i,
          y_start: @attributes[2].to_i,
          x_end: @attributes[3].to_i,
          y_end: @attributes[4].to_i
        }
      end
    end
  end
end