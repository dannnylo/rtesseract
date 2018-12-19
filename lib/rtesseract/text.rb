require 'open3'

class RTesseract
  module Text
    def self.run(source, options)
      puts source.inspect
      Open3.capture2e('tesseract', source, 'stdout').first
    end
  end
end