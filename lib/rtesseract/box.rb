require 'nokogiri'
require 'tmpdir'

class RTesseract
  module Box
    def self.temp_dir
      @file_path = Pathname.new(Dir.tmpdir)
    end

    def self.default
      { tessedit_create_hocr: 1 }
    end

    def self.run(source, options)
      name = "rtesseract_#{SecureRandom.uuid}"

      RTesseract::Command.new(source, temp_dir.join(name).to_s, default.merge(options)).run

      parse(temp_dir.join("#{name}.hocr").read)
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