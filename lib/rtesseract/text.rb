# frozen_string_literal: true

require 'open3'

class RTesseract
  module Text
    def self.run(source, errors, options)
      text = RTesseract::Command.new(source, 'stdout', errors, options).run
      text = text.gsub("\f", '') if text.is_a?(String)
      text
    end
  end
end
