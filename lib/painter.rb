require_relative '../db_connection'
require_relative './painting'
require_relative './model_base'

class Painter < ModelBase
  attr_accessor :name, :birth_year
  attr_reader :id

  def initialize(options)
    @id = options['id']
    @name = options['name']
    @birth_year = options['birth_year']
  end

  def update
    raise 'must create before updating' unless id
    DBConnection.execute(<<-SQL, name, birth_year, id)
      UPDATE
        painters
      SET
        name = ?, birth_year = ?
      WHERE
        id = ?
    SQL
  end

  def save
    if id
      update
    else
      DBConnection.execute(<<-SQL, name, birth_year)
        INSERT INTO
          painters (name, birth_year)
        VALUES
          (?, ?)
      SQL

      @id = DBConnection.last_insert_row_id
    end

    self
  end

  def painted_works
    Painting.where(painter_id: id)
  end

end

# testing -

# In your terminal, make sure you are inside of the lib directory and load 'painter.rb'
 
# run the following commands in Pry:

# Painter.all  #no Pablo Picasso
# painter = Painter.new("name" => "Pablo Picasso", "birth_year" => 1881)
# painter.save
# Painter.all #now there is Pablo Picasso
# new_work = Painting.new("title" => "Guernica", "year" => 1937, "painter_id" => 3)
# new_work.save
# Painting.all #Guernica by Pablo Picasso added

# Painting.first.painter #returns Claude Monet
# Painter.first.painted_works  #returns the paintings by Claude Monet in the DB

# Painting.where(painter_id: 2) #returns all the paintings by Edvard Munch
# Painting.find_by(painter_id: 2) #returns the 1st painting by Edvard Munch in the DB
# Painting.where("title LIKE 'The%'") #returns all paintings in the DB whose title begins with 'The'
