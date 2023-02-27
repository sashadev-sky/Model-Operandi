require 'rspec'
require_relative '../lib/painter'
require_relative '../db_connection'

describe Painter do

  # reset the database after specs are run to ensure that test data doesn't persist to the database.
  before(:each) { DBConnection.reset! }
  after(:each) { DBConnection.reset! }

  describe '::find' do
    it 'returns an instance of the painter class' do
      painter = described_class.find(1)
      expect(painter).to be_kind_of(described_class)
    end

    it 'returns a painter with the correct id' do
      painter = described_class.find(1)
      expect(painter.id).to eq(1)
    end

    it 'returns nil if no object has the given id' do
      expect(Painting.find(50)).to be_nil
    end

    it 'only looks for the first row in the painter table' do
      expect(DBConnection).to receive(:get_first_row).exactly(1).times.and_call_original
      described_class.find(1)
    end
  end

  describe '::find_by name' do
    it 'returns an instance of the painter class' do
      painter = described_class.find_by(name: "Claude Monet")
      expect(painter).to be_kind_of(described_class)
    end

    it 'returns the correct name' do
      painter = described_class.find_by(name: "Claude Monet")
      expect(painter.name).to eq("Claude Monet")
    end
  end

  describe '#save' do
    let(:painter) {described_class.new( {'name' => "test_name"}) }

    it 'persists a new painter to the database' do
      painter.save
      expect(described_class.find(3)).to be_truthy
    end

    it "persists an updated painter to the database" do
      painter.save
      painter.name = "updated_name"
      painter.save
      expect(described_class.find(3).name).to eq("updated_name")
    end

  end

  describe '#painted_works' do
    subject(:painter) { described_class.find(1) }
    let(:painting) { class_double("Painting").as_stubbed_const }

    it 'calls Painting::where' do
      expect(painting).to receive(:where).with(painter_id: 1)
      painter.painted_works
    end

     it 'returns an array of painting objects' do
      paintings = painter.painted_works
      expect(paintings).to all( be_an(Painting) )
    end

    it "returns only paintings with the correct painter id" do
      paintings = painter.painted_works
      painter_ids = paintings.map { |painting| painting.painter_id }
      expect(painter_ids).to all( eq(1) )
    end
  end

end