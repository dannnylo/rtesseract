RSpec.describe RTesseract::Pdf do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }

  let(:image_pdf_path) { path.join('resources', 'test-pdf.png').to_s }

  it ' support pdf output mode' do
    pdf_ocr = RTesseract.new(image_pdf_path).to_pdf

    expect(File.extname(pdf_ocr.path)).to eql('.pdf')
    expect(pdf_ocr.size).to eql(826854)

    pdf_ocr.close

    File.unlink(pdf_ocr)
  end
end
