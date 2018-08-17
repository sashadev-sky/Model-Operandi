DROP TABLE IF EXISTS paintings;
DROP TABLE IF EXISTS painters;

CREATE TABLE paintings
(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  year INTEGER,
  painter_id INTEGER NOT NULL,

  FOREIGN KEY (painter_id) REFERENCES painters(id)
);

DROP TABLE if exists painters;

CREATE TABLE painters
(
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  birth_year INTEGER
);

INSERT INTO
  painters
  (name, birth_year)
VALUES
  ('Claude Monet', 1840),
  ('Edvard Munch', 1863);

INSERT INTO
  paintings
  (title, year, painter_id)
VALUES
  ('Wisteria', 1925, (SELECT id
    FROM painters
    WHERE name = 'Claude Monet')),
  ('The Scream', 1893, (SELECT id
    FROM painters
    WHERE name = 'Edvard Munch')),
  ('The Yellow Log', 1912, (SELECT id
    FROM painters
    WHERE name = 'Edvard Munch')),
  ('The Haymaker', 1917, (SELECT id
    FROM painters
    WHERE name = 'Edvard Munch'));
