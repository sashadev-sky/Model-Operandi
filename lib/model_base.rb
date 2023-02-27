require 'active_support/inflector'
require_relative '../config/inflections'
require_relative '../db_connection'

 # note: the ActiveSupport inflector library handles pluralization for some english grammar 
 # 'edge cases' incorrectly. I have added a file (config/inflections.rb) for easily overriding these cases
 # in case it becomes necessary.

class ModelBase

  def self.table
    self.to_s.tableize
  end

  def self.columns
    return @columns if @columns

    cols = DBConnection.execute2(<<-SQL).first
      SELECT
        *
      FROM
        #{table}
      LIMIT
        0
    SQL

    cols.map!(&:to_sym)
    @columns = cols
  end

  def self.parse_all(data)
    data.map { |datum| self.new(datum) }
  end

  def self.ternary_parse(data)
    data.nil? ? nil : self.new(data)
  end

  def self.all
    data = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table}
    SQL

    parse_all(data)
  end

  # get_first_row allows us to leave off LIMIT 1.
  def self.first
    data = DBConnection.get_first_row(<<-SQL)
      SELECT
        *
      FROM
        #{table}
    SQL

    self.new(data)
  end

  def self.find(id)
    data = DBConnection.get_first_row(<<-SQL, id)
      SELECT
        *
      FROM
        #{table}
      WHERE
        id = ?
    SQL

    ternary_parse(data)
    
  end

  def self.where(params)
    if params.is_a?(Hash)
      where_line = params.keys.map { |key| "#{key} = ?" }.join(" AND ")
      vals = params.values
    else
      where_line = params
      vals = []
    end

    data = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{table}
      WHERE
        #{where_line}
    SQL

    parse_all(data)
  end

  def self.find_by(params)
    results = self.where(params)
    results.first
  end

end