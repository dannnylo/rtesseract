RSpec.describe RTesseract do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }

  it ' support default config' do
    RTesseract.configure { |config| config.psm = 7 }

    expect(RTesseract.config.psm).to eql(7)
    expect(RTesseract.new(path, psm: 2).config.psm).to eql(2)

    expect(RTesseract.config.command).to eql('tesseract')
  end
end
