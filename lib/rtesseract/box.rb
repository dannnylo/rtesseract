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
        next unless line.match?(/oc(rx|r)_word/)

        word = line.match(/(?<=>)(.*?)(?=<)/).to_s

        next if word.strip == ''

        word_info(word, parse_position(line))
      end.compact
    end

    def self.word_info(word, positions)
      {
        word: word,
        x_start: positions[1].to_i,
        y_start: positions[2].to_i,
        x_end: positions[3].to_i,
        y_end: positions[4].to_i
      }
    end

    def self.parse_position(line)
      line.match(/(?<=title)(.*?)(?=;)/).to_s.split(' ')
    end
  end
end
