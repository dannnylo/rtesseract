require 'csv'

RSpec.describe RTesseract::Tsv do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }
  let(:words_image) { path.join('resources', 'test_words.png').to_s }

  it ' support tsv output mode' do
    tsv_ocr = RTesseract.new(words_image).to_tsv

    expect(File.extname(tsv_ocr.path)).to eql('.tsv')
    # File.write(path.join('resources', 'sample.tsv').to_s, tsv_ocr.read)
    expect(tsv_ocr.read).to eql(path.join('resources', 'sample.tsv').read)

    tsv_ocr.close
    File.unlink(tsv_ocr)
  end
end
