# frozen_string_literal: true

RSpec.describe RTesseract::Tsv do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }
  let(:words_image) { path.join('resources', 'test_words.png').to_s }
  let(:file) { RTesseract.new(words_image).to_tsv }

  after do
    file.close
    File.unlink(file)
  end

  it 'returns a file with extension .tsv' do
    expect(File.extname(file.path)).to eql('.tsv')
  end

  it ' support tsv output mode' do
    expect(file.read).to include('level	page_num	block_num	par_num	line_num	word_num	left	top	width	height	conf	text')
  end
end
