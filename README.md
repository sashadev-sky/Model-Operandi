# Object-Relational Mapping (ORM)

This is an exercise in implementing an ORM with SQLite3 and Ruby.

## Overview
- The `plays.rb` file maps to the database in `import_db.sql` after it is parsed by SQLite3.
- The object classes (`Play`, `Playwright`) are mapped to the data tables (`plays`, `playwrights`).
- The object instances are mapped to rows in those tables: each row is a single entity in the table
- The columns in the table are the attributes (instance variables) for those object instances: each column in the table houses an additional piece of data for that single entity.
  - `plays` have an `id`, `title`, `year` and `playwright_id` (foreign key)
  - `playwrights` have an `id`, `name` and `birth_year`
- In `plays.rb`, the `PlayDBConnection` class accesses the database stored in `plays.db`, which includes both the `plays` and `playwrights` tables

- The object instances are mapped to rows in those tables: every column in the database table should be mapped

## Terminology

**SQLite3**: One implementation of SQL, meaning it's the software that actually processes our SQL commands. Synonymous to saying it's a `relational database` or `relational database management system` (`RDBMS`).
- It is:
  - serverless: a library loaded by our program, which then directly interacts with the underlying database data.
  - a common development database, not used for production because of performance limitations

**Mapping (v)**: The act pf determining how objects and their relationships are persisted in permanent data storage (in this case relational databases).

**Mapping (n)**: The definition of how an object's property or a relationship is persisted in permanent storage.

**Object-Relational Mapping (ORM)** is a technique that lets the developer query and manipulate data from a relation database using an object-oriented paradigm.
  - An ORM is written in an object oriented language (in this case, Ruby) and wrapped around the relational database.

  An ORM library encapsulates the code needed to manipulate data so that one can easily interact with the data and its attributes as objects, without writing SQL statements directly.

## API
- `::all`: shows every entry in the database
- `#initialize`: creates a new instance
- `#create`: saves that instance to the database
- `#update`: make edits to an instance

## Testing the ORM
To see the ORM in action, make sure you are inside of the `ORM` directory in your terminal
- run `bundle install`
- at the bottom of the `plays.rb` file, I create a new playwright and add him to the database as a `Playwright` instance.
- run `ruby "plays.rb"` to see the database before and after
- feel free to test other methods by entering them within this conditional
- if at any point you feel that your database is corrupted, run `cat import_db.sql | sqlite3 plays.db` to reset the database back to its originally seeded data (the data in the `import_db.sql` file)

### SQL Concepts (personal use)
- `Data Definition Language` (`DDL`): defining your database schema. 3 operators that SQL provides to manipulate a database schema:
  - `CREATE table`
  - `ALTER table`
  - `DROP table`
- `Data Manipulation Language` (`DML`): allows us to add/edit/delete the data in our database. The 4 main DML operations that SQL provides:
  - `SELECT`: retrieve values from one or more rows
  - `INSERT`: insert a row into a table
  - `UPDATE`: update values in one or more existing rows
  - `DELETE`: delete one or more rows
- avoiding `Bobby Tables` (colloquially called `SQL injection`) attacks
- using `Singleton` module to ensure there is only one instance of the database
- heredocs
