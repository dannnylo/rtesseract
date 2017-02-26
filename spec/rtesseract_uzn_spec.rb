# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Rtesseract::Uzn' do
  before do
    @path = Pathname.new(__FILE__.gsub('rtesseract_uzn_spec.rb', '')).expand_path
    @image_tif = @path.join('images', 'mixed.tif').to_s
  end

  it 'should be instantiable' do
    expect(RTesseract::Uzn.new.class).to eql(RTesseract::Uzn)
    expect(RTesseract::Uzn.new(@image_tif).class).to eql(RTesseract::Uzn)
  end

  it 'should translate parts of the image to text from a block' do
    uzn_block = RTesseract::Uzn.new(@image_tif) do |image|
      image.area(x: 28, y: 19, w: 25, h: 25) # position of 4
      image.area(x: 180, y: 22, w: 20, h: 28) # position of 3
      image.area(x: 218, y: 22, w: 24, h: 28) # position of F
      image.area(x: 248, y: 24, w: 22, h: 22) # position of F
    end

    expect(uzn_block.to_s_without_spaces).to eql('43FF')
  end

  it 'should translate parts of the image to text from initializer options' do
    @areas = []
    @areas << { x: 28, y: 19, w: 25, h: 25 } # position of 4
    @areas << { x: 180, y: 22, w: 20, h: 28 } # position of 3
    @areas << { x: 218, y: 22, w: 24, h: 28 } # position of f
    @areas << { x: 248, y: 24, w: 22, h: 22 }  # position of f

    uzn_block = RTesseract::Uzn.new(@image_tif, areas: @areas)
    expect(uzn_block.to_s_without_spaces).to eql('43FF')
  end

  it 'should handle a blank image' do
    @areas = []
    @areas << { x: 28, y: 19, w: 25, h: 25 } # position of 4
    @areas << { x: 180, y: 22, w: 20, h: 28 } # position of 3
    @areas << { x: 218, y: 22, w: 24, h: 28 } # position of f
    @areas << { x: 248, y: 24, w: 22, h: 22 }  # position of f
    uzn_block = RTesseract::Uzn.new(@path.join('images', 'blank.tif').to_s, areas: @areas)
    expect(uzn_block.to_s_without_spaces).to eql('')
  end

  it ' get a error' do
    @areas = [{ x: 28, y: 19, w: 25, h: 25 }]

    uzn_block = RTesseract::Uzn.new(@path.join('images', 'test_not_exists.png').to_s, areas: @areas, psm: 7)
    expect { uzn_block.to_s_without_spaces }.to raise_error(RTesseract::ImageNotSelectedError)

    uzn_block = RTesseract::Uzn.new(@image_tif, areas: @areas, psm: 7, command: 'tesseract_error')
    expect { uzn_block.to_s }.to raise_error(RTesseract::ConversionError)
  end
end
