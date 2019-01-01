RSpec.describe RTesseract do
  let(:path) {  Pathname.new(__dir__) }
  let(:image_path) { path.join('resources', 'test.tif').to_s }
  let(:pdf_path) { path.join('resources', 'test.tif').to_s }

  it "has a version number" do
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
    expect(RTesseract.new(path.join('resources', 'test1.tif').to_s).to_s_without_spaces).to eql('V2V4')
    expect(RTesseract.new(path.join('resources', 'test with spaces.tif').to_s).to_s_without_spaces).to eql('V2V4')

    expect(RTesseract.new(path.join('resources', 'test.png').to_s, psm: 4).to_s_without_spaces).to eql('HW9W')
    expect(RTesseract.new(path.join('resources', 'test.jpg').to_s).to_s_without_spaces).to eql('3R8F')
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

    expect{ RTesseract.check_version! }.to raise_error(RTesseract::Error)
  end
end
