# frozen_string_literal: true

RSpec.describe RTesseract::Pdf do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }
  let(:words_image) { path.join('resources', 'test-pdf.png').to_s }
  let(:file) { RTesseract.new(words_image).to_pdf }

  after do
    file.close
    File.unlink(file)
  end

  it 'returns a file with extension .pdf' do
    expect(File.extname(file.path)).to eql('.pdf')
  end

  it 'checks if file pdf exisits' do
    expect(File).to exist(file.path)
  end
end
