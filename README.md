# Model-Operandi
<big>**Object-Relational Mapping (ORM)**</big>

- A lightweight Ruby ORM
- Inspired by the ActiveRecord pattern
- Written with RSpec testing and follows Test Driven Development (TDD) principles

## Overview
- The `painting.rb` and `painter.rb` files map to the database in `import_db.sql` after it is parsed by SQLite3.
- The object classes (`Painting`, `Painter`) are mapped to the data tables (`paintings`, `painters`).
- Object instances are mapped to the rows in the tables: each row is a single entity.
- Attributes for each object instance (instance variables) are mapped to the columns in the tables: each column houses an additional piece of data for that single entity.
  - `paintings` have an `id`, `title`, `year` and `painter_id`
  - `painters` have an `id`, `name` and `birth_year`
- `db_connection.rb` holds the `DBConnection` class, which stores the database instance after it is initialized.

## Terminology

**SQLite3**: One implementation of SQL, meaning it's the software that actually processes our SQL commands. Synonymous to saying it's a `relational database` or `relational database management system` (`RDBMS`).
- It is:
  - Serverless: a library loaded by our program, which then directly interacts with the underlying database data.
  - A common development database, not used for production because of performance limitations.

**Mapping (v)**: The act of determining how objects and their relationships are persisted in permanent data storage.

**Mapping (n)**: The definition of how an object's property or a relationship is persisted in permanent storage.

**Object-Relational Mapping (ORM)** is a technique that lets the developer query and manipulate data from a relational database using an object-oriented paradigm.
  - An ORM is written in an object-oriented language (in this case, Ruby) and wrapped around the relational database.
  - Motivation: one can easily interact with the data and its attributes as objects, without writing SQL statements directly.

## API
- `::all`: return an array of all the records in the DB
- `::find`: return a single record retrieved by primary key
- `::find_by`: return the first record that matches specified attributes
- `::where`: return an array of all records that match specified attributes
- `#save`: `update`s or inserts a record into the DB depending on whether it already exists in the table
- `#update`: updates the DB row corresponding to the record with the given attribute values

## Testing the ORM

You can use Pry to see the ORM in action. 

To set up the environment, make sure you are inside of the project directory in your terminal and run: 

```bash
# install dependencies
bundle install

# start up pry
pry
```

In the pry session:

- Refer to the "testing" section commented out at the bottom of `painter.rb`

- If at any point you feel that your database is corrupted, run `DBConnection.reset!` to reset it back to its originally seeded data.

- To see the SQL queries behind the Ruby methods you test, set `PRINT_QUERIES = true` (currently set to false) at the top of the `db_connection.rb` file. 

RSpec: 

- See the `spec` folder for documentation on the functionality of this ORM's interface. 

- To run the specs, in your terminal run:

```bash
# test all files at once
bundle exec rspec

# test individual spec files
bundle exec rspec ./spec/file_name.rb
```
 
---------------------------------------------------------

### SQL Concepts (personal use)
- `Data Definition Language` (`DDL`): defines the structure of our database (also called schema). 3 operators that SQL provides:
  - `CREATE table`
  - `ALTER table`
  - `DROP table`
- `Data Manipulation Language` (`DML`): add/edit/delete the data in the database. 4 main DML operations that SQL provides:
  - `SELECT`: retrieve values from one or more rows
  - `INSERT`: insert a row into a table
  - `UPDATE`: update values in one or more existing rows
  - `DELETE`: delete one or more rows
- Avoiding the `Bobby Table` (colloquially called `SQL injection`) attack
  - Important to sanitize `WHERE` clause values and other parts of dynamic SQL data that come from user input
- `Singleton` module / pattern
- Heredocs
- `ActiveSupport::Inflector`
- `RSpec` 
  - Model specs are considered **unit tests** since they test each model as an independent unit
  - These will be the most specific, detailed tests in a Rails app but also one of the most essential 
