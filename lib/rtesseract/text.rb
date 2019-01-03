require 'open3'

class RTesseract
  module Text
    def self.run(source, options)
      RTesseract::Command.new(source, 'stdout', options).run
    end
  end
end