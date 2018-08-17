require 'rspec'
require_relative '../lib/painting' 
require_relative '../db_connection' 

describe Painting do
  before(:each) { DBConnection.reset! }
  after(:each) { DBConnection.reset! }

  describe '::find' do 
    it 'returns an instance of the painting class' do 
      painting = described_class.find(1)
      expect(painting).to be_kind_of(described_class)
    end 
    
    it 'returns the painting with the correct id' do
      painting = described_class.find(1)
      expect(painting.id).to eq(1)
    end 

    it 'returns nil if no object has the given id' do
      expect(Painting.find(50)).to be_nil
    end
    
    it 'only looks for the first row in the paintings table' do 
      expect(DBConnection).to receive(:get_first_row).exactly(1).times.and_call_original
      described_class.find(1)
    end 
  end

  describe '::find_by title' do
    it 'returns an instance of the painting class' do
      painting = described_class.find_by(title: "The Scream")
      expect(painting).to be_kind_of(described_class)
    end 
    
    it 'returns the correct title' do 
      painting = described_class.find_by(title: "The Scream")
      expect(painting.title).to eq("The Scream")
    end
  end 

  describe '#painter' do 
    subject(:painting) { described_class.find(2) }
    let(:painter) { class_double("Painter").as_stubbed_const }

    it 'calls Painter::find' do 
      expect(painter).to receive(:find).with(2)
      painting.painter
    end 
      
    it 'returns a single painter object' do 
      result = painting.painter
      expect(result).to be_kind_of(Painter)
    end
    
    it "returns only painters with the correct painter id" do 
      result = painting.painter
      painter_id = result.id
      expect(painter_id).to eq(2)
    end 
  end 

  describe '#save' do 
    let(:painting) {described_class.new( {'title' => "test_title", 'painter_id' => 2}) }
    
    it 'persists a new painting to the DB' do 
      painting.save
      expect(described_class.find(5)).to be_truthy 
    end 
    
    it "persists an updated painting to the DB" do 
      painting.save
      painting.title = "updated_title"
      painting.save
      expect(described_class.find(5).title).to eq("updated_title")
    end 

    it "raises an error if try to update to non-existent painter id" do
      painting.save
      painting.painter_id = 5
      expect do
        painting.save
      end.to raise_error("This id does not match a painter in the DB")
    end
  end

end


