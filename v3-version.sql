/**
 @author ss0ldd
*/

COMMENT ON TABLE Books IS 'Таблица для хранения информации об авторах, читателях, книгах и издатесльтвах для библиотеки';

BEGIN;

ALTER TABLE Authors
    ALTER COLUMN author_name TYPE VARCHAR(100),
    ADD death_date        DATE,
    ADD gender            TEXT CHECK (gender IN ('female', 'male')),
    ADD biography_summary TEXT;

ALTER TABLE Publishers
    ALTER publisher_name TYPE VARCHAR(100),
    ADD CONSTRAINT unique_publisher UNIQUE (publisher_name),
    ALTER city TYPE VARCHAR(100),
    ADD website       TEXT,
    ADD contact_email TEXT;

ALTER TABLE Genres
    ALTER COLUMN genre_name TYPE VARCHAR(100),
    ADD CONSTRAINT unique_genre UNIQUE (genre_name),
    ADD description TEXT CHECK (LENGTH(description) <= 500);

ALTER TABLE Books
    ADD CONSTRAINT title_length CHECK (LENGTH(title) <= 100),
    ADD CONSTRAINT isbn_length CHECK (LENGTH(isbn) = 10),
    ADD CONSTRAINT unique_isbn UNIQUE (isbn),
    ADD pages_number int CHECK (pages_number > 0),
    ADD language     TEXT,
    ADD availability boolean;

ALTER TABLE Readers
    ADD CONSTRAINT unique_email UNIQUE (email),
    ADD birthday      DATE,
    ADD passport_info VARCHAR(10) UNIQUE,
    ADD study_group   VARCHAR(6);


ALTER TABLE Borrowed_books
    ADD return_date  DATE,
    ADD damage_notes TEXT CHECK (LENGTH(damage_notes) <= 300);

ROLLBACK;