/**
 @author ss0ldd
*/

BEGIN;

SAVEPOINT before_changes;

CREATE TABLE New_Authors
(
    author_name TEXT NOT NULL,
    birth_date  DATE,
    country     TEXT NOT NULL,
    PRIMARY KEY (author_name, birth_date, country)
);

CREATE TABLE New_Publishers
(
    publisher_name TEXT NOT NULL,
    city           TEXT,
    PRIMARY KEY (publisher_name, city)
);

CREATE TABLE New_Genres
(
    genre_name TEXT NOT NULL,
    PRIMARY KEY (genre_name)
);

CREATE TABLE New_Books
(
    title          TEXT NOT NULL,
    author_name    TEXT NOT NULL,
    birth_date DATE NOT NULL,
    country TEXT NOT NULL,
    publisher_name TEXT NOT NULL,
    city           TEXT NOT NULL,
    genre_name     TEXT NOT NULL,
    published_date DATE,
    isbn           TEXT,
    PRIMARY KEY (title, author_name, birth_date, country, publisher_name, genre_name, published_date, isbn),
    FOREIGN KEY (author_name, birth_date, country) REFERENCES New_Authors (author_name, birth_date, country),
    FOREIGN KEY (publisher_name, city) REFERENCES New_Publishers (publisher_name, city),
    FOREIGN KEY (genre_name) REFERENCES New_Genres (genre_name)
);

CREATE TABLE New_Readers
(
    reader_name       TEXT,
    email             TEXT NOT NULL,
    phone             VARCHAR(11),
    registration_date DATE,
    PRIMARY KEY (email)
);

CREATE TABLE New_Borrowed_books
(
    book_title   TEXT NOT NULL,
    author_name  TEXT NOT NULL,
    birth_date DATE NOT NULL,
    country TEXT NOT NULL,
    reader_email TEXT NOT NULL,
    borrow_date  DATE NOT NULL,
    is_returned  BOOLEAN,

    PRIMARY KEY (book_title, author_name, birth_date, country, reader_email, borrow_date),
    FOREIGN KEY (book_title, author_name, birth_date, country) REFERENCES New_Books (title, author_name, birth_date, country),
    FOREIGN KEY (reader_email) REFERENCES New_Readers (email)
);

INSERT INTO New_Authors (author_name, birth_date, country)
SELECT author_name, birth_date, country
FROM Authors;

INSERT INTO New_Publishers (publisher_name, city)
SELECT publisher_name, city
FROM Publishers;

INSERT INTO New_Genres (genre_name)
SELECT genre_name
FROM Genres;

INSERT INTO New_Books(title, author_name, birth_date, country, publisher_name, city, genre_name, published_date, isbn)
SELECT book.title,
       author.author_name,
       author.birth_date,
       author.country,
       publ.publisher_name,
       publ.city,
       genre.genre_name,
       book.published_date,
       book.isbn
FROM Books book
         JOIN Authors author ON book.author_id = author.author_id
         JOIN Publishers publ ON publ.publisher_id = book.publisher_id
         JOIN Genres genre ON genre.genre_id = book.genre_id;

INSERT INTO New_Readers (reader_name, email, phone, registration_date)
SELECT reader_name, email, phone, registration_date
FROM Readers;

INSERT INTO New_Borrowed_books(book_title, author_name, birth_date, country, reader_email, borrow_date, is_returned)
SELECT book.title,
       author.author_name,
       author.birth_date,
       author.country,
       reader.email,
       borrowed_b.borrow_date,
       borrowed_b.is_returned
FROM Borrowed_books borrowed_b
         JOIN Books book ON borrowed_b.book_id = book.book_id
         JOIN Authors author ON book.author_id = author.author_id
         JOIN Readers reader ON borrowed_b.reader_id = reader.reader_id;

ROLLBACK TO SAVEPOINT before_changes;

DROP TABLE IF EXISTS Authors CASCADE;
DROP TABLE IF EXISTS Publishers CASCADE;
DROP TABLE IF EXISTS Genres CASCADE;
DROP TABLE IF EXISTS Books CASCADE;
DROP TABLE IF EXISTS Readers CASCADE;
DROP TABLE IF EXISTS Borrowed_books CASCADE;

ALTER TABLE New_Authors RENAME TO Authors;
ALTER TABLE New_Publishers RENAME TO Publishers;
ALTER TABLE New_Genres RENAME TO Genres;
ALTER TABLE New_Books RENAME TO Books;
ALTER TABLE New_Readers RENAME TO Readers;
ALTER TABLE New_Borrowed_books RENAME TO Borrowed_books;

COMMIT;