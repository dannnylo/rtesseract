# frozen_string_literal: true

RSpec.describe RTesseract::Text do
  let(:path) { Pathname.new(File.dirname(__FILE__)).join('..') }
  let(:image_path) { path.join('resources', 'test.tif').to_s }
  let(:pdf_path) { path.join('resources', 'test.tif').to_s }

  let(:words_image) { path.join('resources', 'test_words.png').to_s }

  it 'translate image to text' do
    expect(RTesseract.new(image_path).to_s_without_spaces).to eql('43XF')
  end

  it 'translate tif image to text' do
    expect(RTesseract.new(path.join('resources', 'test1.tif').to_s).to_s_without_spaces).to eql('V2V4')
  end

  it 'translate tif image with spaces to text' do
    expect(RTesseract.new(path.join('resources', 'test with spaces.tif').to_s).to_s_without_spaces).to eql('V2V4')
  end

  it 'translate png image with spaces to text' do
    expect(RTesseract.new(path.join('resources', 'test.png').to_s).to_s_without_spaces).to eql('HW9W')
  end

  it 'translate jpg image with spaces to text' do
    expect(RTesseract.new(path.join('resources', 'test.jpg').to_s).to_s_without_spaces).to eql('3R8F')
  end

  it 'translate image to text with options' do
    expect(RTesseract.new(image_path, psm: 7, oem: 1).to_s_without_spaces).to eql('43XF')
  end

  it 'tests output text' do
    expect(RTesseract.new(words_image).to_s).to eql("If you are a friend,\nyou speak the password,\nand the doors will open.\n\f")
  end
end
