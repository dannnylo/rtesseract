RSpec.describe RTesseract do
  let(:path) { Pathname.new(__dir__) }
  let(:image_path) { path.join('resources', 'test.tif').to_s }
  let(:pdf_path) { path.join('resources', 'test.tif').to_s }

  it 'has a version number' do
    expect(RTesseract::VERSION).not_to be nil

    expect(RTesseract.tesseract_version).to be > 3.05
  end

  it 'be instantiable' do
    expect(RTesseract.new.class).to eql(RTesseract)
    expect(RTesseract.new('').class).to eql(RTesseract)
    expect(RTesseract.new(image_path).class).to eql(RTesseract)
  end

  it 'translate image to text' do
    expect(RTesseract.new(image_path).to_s_without_spaces).to eql('43XF')
    {
      'test1.tif' => 'V2V4',
      'test with spaces.tif' => 'V2V4',
      'test.png' => 'HW9W',
      'test.jpg' => '3R8F'
    }.each do |file, value|
      expect(RTesseract.new(path.join('resources', file).to_s).to_s_without_spaces).to eql(value)
    end
  end

  it 'translate image to text with options' do
    expect(RTesseract.new(image_path, psm: 7, oem: 1).to_s_without_spaces).to eql('43XF')
  end

  it 'get tesseract version' do
    expect(RTesseract.tesseract_version).to be > 0

    RTesseract.configure { |config| config.command = 'tesseract_not_installed' }

    expect(RTesseract.tesseract_version).to eql(0)
  end

  it 'raise a error if tesseract version < 3.05' do
    RTesseract.configure { |config| config.command = 'tesseract_not_installed' }

    expect { RTesseract.check_version! }.to raise_error(RTesseract::Error)
  end

  it 'raise a error when tesseract raise a error' do
    expect { RTesseract.new.to_s }.to raise_error(RTesseract::Error)
  end

  it 'store the error on a variable to debug' do
    instance = RTesseract.new
    expect { instance.to_s }.to raise_error(RTesseract::Error)
    expect(instance.errors.first).to include("Error during processing")

    error_intance = RTesseract.new(path.join('resources', 'image_with_error.png').to_s)

    expect(error_intance.to_s_without_spaces).to eql('RTX-0003-03-02-01PRE')
    expect(error_intance.errors).to eql(["Error in boxClipToRectangle: box outside rectangle\nError in pixScanForForeground: invalid box\n"])
  end
end
