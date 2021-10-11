# frozen_string_literal: true

RSpec.describe RTesseract do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }

  context 'with global spm' do
    before { described_class.configure { |config| config.psm = 7 } }

    it 'gets the global psm value' do
      expect(described_class.config.psm).to be(7)
    end

    it 'gets instance psm value' do
      expect(described_class.new(path, psm: 2).config.psm).to be(2)
    end
  end

  context 'with default command' do
    it 'gets the global psm value' do
      expect(described_class.config.command).to eql('tesseract')
    end

    it 'gets instance command value' do
      expect(described_class.new(path, command: '/usr/bin/tesseract4').config.command).to eql('/usr/bin/tesseract4')
    end
  end

  context 'with other options' do
    it 'allows to setup oem' do
      expect(described_class.new(path, oem: 1).config.oem).to be(1)
    end

    it 'allows to setup lang' do
      expect(described_class.new(path, lang: 'eng').config.lang).to eql('eng')
    end

    it 'allows to setup multiple langs' do
      expect(described_class.new(path, lang: 'eng+por').config.lang).to eql('eng+por')
    end
  end

  context 'when block not given' do
    it { expect(described_class.configure).to eq(nil) }
  end
end
