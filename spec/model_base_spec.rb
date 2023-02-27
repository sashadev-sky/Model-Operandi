require 'rspec'
require_relative '../lib/model_base'

describe ModelBase do
  before(:each) { DBConnection.reset! }
  after(:each) { DBConnection.reset! }

  describe '::all' do
    it 'returns an array of object items for a class' do
      all_painters = Painter.all
      expect(all_painters).to all(be_a(Painter))
    end

    it 'returns all object items for a class in the database' do
      all_paintings = Painting.all
      expect(all_paintings.count).to eq(4)
    end
  end

  describe '::where' do
    it 'searches for table column based on method name' do
      search = Painter.where("name" => "Edvard Munch")
      expect(search.first).to be_a(Painter)
      expect(search.first.name).to eq("Edvard Munch")
    end

    it 'filters paintings based on parameters' do
      search = Painting.where("title" => "The Scream")
      expect(search).to all(be_a(Painting))
    end
  end

  describe '::first' do
    it 'only hits the database once' do
      expect(DBConnection).to(
        receive(:get_first_row).exactly(1).times.and_call_original)
      Painter.first
    end
  end

  describe '::columns' do
    it 'returns a list of all column names as symbols' do
      expect(Painter.columns).to eq([:id, :name, :birth_year])
    end
  end

end


