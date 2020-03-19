class RTesseract
  module Box
    extend RTesseract::Base

    def self.run(source, errors, options)
      options.tessedit_create_hocr = 1

      RTesseract::Command.new(source, temp_file, errors, options).run

      parse(File.read(temp_file('.hocr')))
    end

    def self.parse(content)
      content.lines.map do |line|
        self.word_info(line) if line.match?(/oc(rx|r)_word/)
      end.compact
    end

    def self.word_info(line)
      data = line.match(/(?<=title)(.*?)(?=;)/).to_s.split(" ")
      word = line.match(/(?<=>)(.*?)(?=<)/).to_s

      return if word.strip == ''

      {
        word: word,
        x_start: data[1].to_i,
        y_start: data[2].to_i,
        x_end: data[3].to_i,
        y_end: data[4].to_i
      }
    end
  end
end
