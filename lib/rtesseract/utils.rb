# module
class RTesseract
  module Utils
    # Remove files
    def self.remove_file(files = [])
      files.each do |file|
        if file.is_a?(Tempfile)
          file.close
          file.unlink
        else
          File.unlink(file)
        end
      end
      true
    rescue => error
      raise RTesseract::TempFilesNotRemovedError.new(error: error, files: files)
    end
  end
end