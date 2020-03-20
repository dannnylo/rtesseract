# frozen_string_literal: true

require 'csv'

RSpec.describe RTesseract::Tsv do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }
  let(:words_image) { path.join('resources', 'test_words.png').to_s }

  it ' support tsv output mode' do
    tsv_ocr = RTesseract.new(words_image).to_tsv

    expect(File.extname(tsv_ocr.path)).to eql('.tsv')
    expect(tsv_ocr.read).to include('level	page_num	block_num	par_num	line_num	word_num	left	top	width	height	conf	text')

    tsv_ocr.close
    File.unlink(tsv_ocr)
  end
end
