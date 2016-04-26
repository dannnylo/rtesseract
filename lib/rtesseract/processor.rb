# RTesseract
class RTesseract
  # Processor managment
  module Processor
    # Return the processor
    def self.choose_processor!(processor)
      processor =
      if RTesseract::Processor::MiniMagickProcessor.a_name?(processor.to_s)
        MiniMagickProcessor
      elsif RTesseract::Processor::NoneProcessor.a_name?(processor.to_s)
        NoneProcessor
      else
        RMagickProcessor
      end
      processor.setup
      processor
    end
  end
end