# frozen_string_literal: true

RSpec.describe RTesseract do
  let(:path) { Pathname.new(__dir__) }
  let(:image_path) { path.join('resources', 'test.tif').to_s }
  let(:pdf_path) { path.join('resources', 'test.tif').to_s }
  let(:words_image) { path.join('resources', 'test_words.png').to_s }

  it 'returns the tesseract version' do
    expect(described_class.tesseract_version).to be > 3.05
  end

  it 'be instantiable without path' do
    expect(described_class.new.class).to eql(described_class)
  end

  it 'be instantiable with blank string' do
    expect(described_class.new('').class).to eql(described_class)
  end

  it 'be instantiable with a path' do
    expect(described_class.new(image_path).class).to eql(described_class)
  end

  context 'when tesseract not installed' do
    before do
      described_class.configure { |config| config.command = 'tesseract_not_installed' }
    end

    it 'returns zero on #tesseract_version' do
      expect(described_class.tesseract_version).to be(0)
    end

    it 'raise a error if tesseract version < 3.05' do
      expect { described_class.check_version! }.to raise_error(RTesseract::Error)
    end
  end

  context 'when tesseract installed version is less then 3' do
    before do
      allow(RTesseract).to receive(:tesseract_version).and_return(2)
    end

    it 'raise a error if tesseract version < 3.05' do
      expect { described_class.check_version! }.to raise_error(RTesseract::Error)
    end
  end

  context 'when tesseract installed version is greather then 3' do
    before do
      allow(RTesseract).to receive(:tesseract_version).and_return(4)
    end

    it 'raise a error if tesseract version < 3.05' do
      expect(described_class.check_version!).to eq(nil)
    end
  end

  context 'without source' do
    let(:instance) { described_class.new }

    it 'raise an exception' do
      aggregate_failures 'raise an exception' do
        expect { instance.to_s }.to raise_error(RTesseract::Error)
        expect(instance.errors.first).to include('Error during processing')
      end
    end
  end

  context 'with errors on image' do
    let(:error_intance) do
      described_class.new(path.join('resources', 'image_with_error.png').to_s)
    end

    it 'stores the error on a variable to debug' do
      aggregate_failures 'stores the error on a variable to debug' do
        expect(error_intance.to_s_without_spaces).to eql('RTX-0003-03-02-01PRE')
        expect(error_intance.errors).to eql(["Error in boxClipToRectangle: box outside rectangle\nError in pixScanForForeground: invalid box\n"])
      end
    end
  end

  it 'runs multiple types' do
    tesseract = RTesseract.new(words_image)
    # Check that none of the other options affects the config, making text error out.
    box = tesseract.to_box
    pdf = tesseract.to_pdf
    tsv = tesseract.to_tsv

    result = tesseract.to_s
    expect(result).to eql("If you are a friend,\nyou speak the password,\nand the doors will open.\n")
    expect(box).to be_a(Array)

    expect(pdf).to be_a(File)
    expect(File.extname(pdf.path)).to eq('.pdf')

    expect(tsv).to be_a(File)
    expect(File.extname(tsv.path)).to eq('.tsv')

    pdf.close
    tsv.close
  end
end
