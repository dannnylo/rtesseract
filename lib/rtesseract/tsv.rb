require 'tmpdir'

class RTesseract
  module Tsv
    def self.temp_dir
      @file_path = Pathname.new(Dir.tmpdir)
    end

    def self.run(source, options)
      name = "rtesseract_#{SecureRandom.uuid}"
      options.tessedit_create_tsv = 1

      RTesseract::Command.new(source, temp_dir.join(name).to_s, options).run

      File.open(temp_dir.join("#{name}.tsv").to_s, 'r')
    end
  end
end