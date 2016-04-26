# encoding: UTF-8
# RTesseract class
class RTesseract
  # Processor Module
  module Processor
    # Add to rtesseract a image without manipulation
    module NoneProcessor
      # Setup Processor
      def self.setup
      end

      # Check if is this Processor
      def self.a_name?(name)
        %w(none NoneProcessor).include?(name.to_s)
      end

      # Convert Image to Tiff
      def self.image_to_tif(source, _points = {})
        tmp_file = Tempfile.new(['', '.tif'])
        tmp_file.write(read_with_processor(source))
        tmp_file
      end

      # Cast instance of image
      def self.read_with_processor(path)
        File.read(path)
      end

      # Check if is a image
      def self.image?(*)
      end
    end
  end
end
