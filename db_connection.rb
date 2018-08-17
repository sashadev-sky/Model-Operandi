require 'sqlite3'
require 'singleton'

# set below = true for SQL queries to be printed to console
PRINT_QUERIES = false

class DBConnection < SQLite3::Database
  include Singleton

  SQL_FILE = File.join(File.dirname(__FILE__), 'import_db.sql')
  DB_FILE = File.join(File.dirname(__FILE__), 'paintings.db')
 
  # creates a connection to our database
  def self.open
    @db = SQLite3::Database.new(DB_FILE)
    # inherited from the SQLite3 gem
    @db.results_as_hash = true
    @db.type_translation = true
  end

  def self.instance
    reset! if @db.nil?
    @db
  end
  
  def self.reset!
    `#{"cat '#{SQL_FILE}' | sqlite3 '#{DB_FILE}'"}`
    DBConnection.open
  end

  def self.execute(*args)
    print_query(*args)
    instance.execute(*args)
  end

  # unlike #execute, always returns the names of the columns first
  def self.execute2(*args)
    print_query(*args)
    instance.execute2(*args)
  end

  def self.get_first_row(*args)
    print_query(*args)
    instance.get_first_row(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

   private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end

end