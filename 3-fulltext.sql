ALTER TABLE Books ADD COLUMN description TEXT;
ALTER TABLE Books ADD COLUMN tsvector_col TSVECTOR;

UPDATE Books
SET tsvector_col = to_tsvector('russian', coalesce(title, '') || ' ' || coalesce(description, ''));

CREATE INDEX idx_fts_books ON Books USING GIN(tsvector_col);

SELECT book_id, title, description
FROM Books
WHERE tsvector_col @@ to_tsquery('russian', 'роман');

SELECT book_id, title, description
FROM Books
WHERE tsvector_col @@ to_tsquery('russian', 'история & война');

SELECT book_id, title, description
FROM Books
WHERE tsvector_col @@ to_tsquery('russian', 'фэнтези | приключения');

SELECT book_id, title, description
FROM Books
WHERE tsvector_col @@ to_tsquery('russian', 'роман & !комедия');

SELECT book_id, title, tsvector_col
FROM Books
WHERE tsvector_col IS NOT NULL
LIMIT 5;