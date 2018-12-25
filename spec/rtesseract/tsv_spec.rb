RSpec.describe RTesseract::Tsv do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }

  let(:image_tsv_path) { path.join('resources', 'test-pdf.png').to_s }

  it ' support tsv output mode' do
    tsv_ocr = RTesseract.new(image_tsv_path).to_tsv

    expect(File.extname(tsv_ocr.path)).to eql('.tsv')
    # expect(tsv_ocr.read).to eql(path.join('resources', 'sample.tsv').read)

    tsv_ocr.close
    File.unlink(tsv_ocr)
  end
end
