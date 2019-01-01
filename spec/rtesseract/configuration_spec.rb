RSpec.describe RTesseract do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }

  it ' support default config' do
    RTesseract.configure { |config| config.psm = 7 }

    expect(RTesseract.config.psm).to eql(7)
    expect(RTesseract.new(path, psm: 2).config.psm).to eql(2)

    expect(RTesseract.config.command).to eql('tesseract')
    expect(RTesseract.new(path, command: '/usr/bin/tesseract4').config.command).to eql('/usr/bin/tesseract4')

    expect(RTesseract.new(path, psm: 2).config.psm).to eql(2)
    expect(RTesseract.new(path, oem: 1).config.oem).to eql(1)
    expect(RTesseract.new(path, lang: 'eng').config.lang).to eql('eng')
    expect(RTesseract.new(path, lang: 'eng+por').config.lang).to eql('eng+por')
  end
end
