# encoding: UTF-8
# RTesseract class
class RTesseract
  # Processor Module
  module Processor
    # Add to rtesseract a image manipulation with MiniMagick
    module MiniMagickProcessor
      # Setup Processor
      def self.setup
        require 'mini_magick'
      end

      # Check if is this Processor
      def self.a_name?(name)
        %w(mini_magick MiniMagickProcessor).include?(name.to_s)
      end

      # Convert Image to Tiff
      def self.image_to_tif(source, points = {})
        tmp_file = Tempfile.new(['', '.tif'])
        cat = source.is_a?(Pathname) ? read_with_processor(source.to_s) : source
        cat.format('tif') do |c|
          c.compress 'None'
          c.alpha 'off' if MiniMagick.cli != :graphicsmagick
        end
        cat.crop("#{points[:w]}x#{points[:h]}+#{points[:x]}+#{points[:y]}") if points.is_a?(Hash) && points.values.compact != []
        cat.alpha 'off' if MiniMagick.cli != :graphicsmagick
        cat.write tmp_file.path.to_s
        tmp_file
      end

      # Cast instance of image
      def self.read_with_processor(path)
        MiniMagick::Image.open(path.to_s)
      end

      # Check if is a MiniMagick image
      def self.image?(object)
        object.class == MiniMagick::Image
      end
    end
  end
end
