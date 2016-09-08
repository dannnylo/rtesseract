require 'open3'

# RTesseract
class RTesseract
  # Some utils methods
  module Utils
    # Remove files or Tempfile
    def self.remove_files(files = [])
      files.each do |file|
        self.remove_file(file)
      end
      true
    rescue => error
      raise RTesseract::TempFilesNotRemovedError.new(error: error, files: files)
    end

    # Remove file or Tempfile
    def self.remove_file(file)
      if file.is_a?(Tempfile)
        file.close
        file.unlink
      else
        File.unlink(file)
      end
      true
    end

    # Extract tesseract version number
    def self.version_number
      out, err, st = Open3.capture3(RTesseract.default_command, "--version")
      
      version = err.split("\n")[0].split(" ")[1].split('.')[0, 2].join('.')
      Float(version) rescue nil
    end
  end
end

# Hash
class Hash
  # return the value and remove from hash
  def option(attr_name, default)
    delete(attr_name.to_s) || delete(attr_name) || default
  end
end
