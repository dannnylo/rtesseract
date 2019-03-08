require 'nokogiri'

class RTesseract
  module Box
    extend RTesseract::Base

    def self.run(source, errors, options)
      options.tessedit_create_hocr = 1

      RTesseract::Command.new(source, temp_file, errors, options).run

      parse(File.read(temp_file('.hocr')))
    end

    def self.parse(content)
      html = Nokogiri::HTML(content)
      html.css('span.ocrx_word, span.ocr_word').map do |word|
        attributes = word.attributes['title'].value.to_s.delete(';').split(' ')
        word_info(word, attributes)
      end
    end

    def self.word_info(word, data)
      {
        word: word.text,
        x_start: data[1].to_i,
        y_start: data[2].to_i,
        x_end: data[3].to_i,
        y_end: data[4].to_i
      }
    end
  end
end
