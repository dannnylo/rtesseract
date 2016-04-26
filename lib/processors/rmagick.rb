# encoding: UTF-8
# RTesseract class
class RTesseract
  # Processor Module
  module Processor
    # Add to rtesseract a image manipulation with RMagick
    module RMagickProcessor
      # Setup Processor
      def self.setup
        require 'rmagick'
      rescue LoadError
        # :nocov:
        require 'RMagick'
        # :nocov:
      end

      # Check if is this Processor
      def self.a_name?(name)
        %w(rmagick RMagickProcessor).include?(name.to_s)
      end

      # Convert Image to Tiff
      def self.image_to_tif(source, points = {})
        tmp_file = Tempfile.new(['', '.tif'])
        cat = source.is_a?(Pathname) ? read_with_processor(source.to_s) : source
        cat.crop!(points[:x], points[:y], points[:w], points[:h]) if points.is_a?(Hash) && points.values.compact != []
        cat.alpha Magick::DeactivateAlphaChannel
        cat.write(tmp_file.path.to_s) do
          # self.depth = 16
          self.compression = Magick::NoCompression
        end
        tmp_file
      end

      # Cast instance of image
      def self.read_with_processor(path)
        Magick::Image.read(path.to_s).first
      end

      # Check if is a RMagick image
      def self.image?(object)
        object.class == Magick::Image
      end
    end
  end
end
