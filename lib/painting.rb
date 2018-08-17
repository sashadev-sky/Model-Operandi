require_relative '../db_connection'
require_relative './painter'
require_relative './model_base'

class Painting < ModelBase
  attr_accessor :title, :year, :painter_id
  attr_reader :id 

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @year = options['year']
    @painter_id = options['painter_id']
  end

  def painter
    Painter.find(painter_id)
  end

  def update
    DBConnection.execute(<<-SQL, title, year, painter_id, id)
      UPDATE
        paintings
      SET
        title = ?, year = ?, painter_id = ?
      WHERE
        id = ?
    SQL
  end

  def save
    raise "This id does not match a painter in the DB" unless Painter.find(painter_id)
    if id
      update
    else
      # if id doesnt exist, perform an INSERT of the fields into the DB. After the insert,
      # last_insert_row_id gets the newly issued id for the inserted row. Save this in
      # an @id instance variable in the object instance. 
      # Future calls to save on this object should issue an UPDATE
      DBConnection.execute(<<-SQL, title, year, painter_id)
        INSERT INTO
          paintings (title, year, painter_id)
        VALUES
          (?, ?, ?)
      SQL

      @id = DBConnection.last_insert_row_id
    end

    self
  end

end