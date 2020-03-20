# frozen_string_literal: true

require 'open3'

class RTesseract
  module Text
    def self.run(source, errors, options)
      RTesseract::Command.new(source, 'stdout', errors, options).run
    end
  end
end
