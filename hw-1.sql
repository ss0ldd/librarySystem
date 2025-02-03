COMMENT ON TABLE Books IS 'Таблица для хранения информации об авторах, читателях, книгах и издатесльтвах для библиотеки';

DROP TABLE IF EXISTS Authors;
CREATE TABLE Authors
(
    author_id   serial PRIMARY KEY,
    author_name TEXT NOT NULL,
    birth_date  DATE,
    country     TEXT
);

INSERT INTO Authors(author_name, birth_date, country)
VALUES ('Aleksandr Sergeevich Pushkin', '06-06-1799', 'Russia');

INSERT INTO Authors(author_name, birth_date, country)
VALUES ('Nikolai Vasilievich Gogol', '01-04-1809', 'Russia');

INSERT INTO Authors(author_name, birth_date, country)
VALUES ('Ernest Hemingway', '21-07-1899', 'USA');

DROP TABLE IF EXISTS Publishers;
CREATE TABLE Publishers
(
    publisher_id   serial PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city           TEXT
);

INSERT INTO Publishers(publisher_name, city) VALUES ('AST', 'Moscow');

INSERT INTO Publishers(publisher_name, city) VALUES ('Smena', 'Kazan');

INSERT INTO Publishers(publisher_name, city) VALUES ('Macmillan', 'London');

DROP TABLE IF EXISTS Genres;
CREATE TABLE Genres
(
    genre_id   serial PRIMARY KEY,
    genre_name TEXT NOT NULL
);

INSERT INTO Genres(genre_name) VALUES ('Novel');

INSERT INTO Genres(genre_name) VALUES ('Romance');

INSERT INTO Genres(genre_name) VALUES ('Adventure');

DROP TABLE IF EXISTS Books CASCADE;
CREATE TABLE Books
(
    book_id        serial PRIMARY KEY,
    title          TEXT NOT NULL,
    author_id      int,
    publisher_id   int,
    genre_id       int,
    published_date DATE,
    isbn           TEXT,
    FOREIGN KEY (author_id) REFERENCES Authors (author_id) ON DELETE CASCADE,
    FOREIGN KEY (publisher_id) REFERENCES Publishers (publisher_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES Genres (genre_id) ON DELETE CASCADE
);

INSERT INTO Books(title, author_id, publisher_id, genre_id, published_date, isbn)
VALUES ('The Captain`s Daughter', 1, 1, 1, '2012-02-19', '0011001100');

INSERT INTO Books(title, author_id, publisher_id, genre_id, published_date, isbn)
VALUES ('Dead Souls', 2, 2, 1, '2000-03-19', '0211041507');

INSERT INTO Books(title, author_id, publisher_id, genre_id, published_date, isbn)
VALUES ('The Old Man and the Sea', 3, 3, 1, '2024-10-11', '0931071650');

DROP TABLE IF EXISTS Readers;
CREATE TABLE Readers
(
    reader_id         serial PRIMARY KEY,
    reader_name       TEXT,
    email             TEXT,
    phone             VARCHAR(11),
    registration_date DATE
);

INSERT INTO Readers(reader_name, email, phone, registration_date) VALUES ('Ivan Melihov', 'vanyusha@gmail.com', '81234567890', '2012-12-01');

INSERT INTO Readers(reader_name, email, phone, registration_date) VALUES ('Lera Semenova', 'lerooook@yandex.ru', '81784087740', '2017-04-05');

INSERT INTO Readers(reader_name, email, phone, registration_date) VALUES ('Lev Sergeev', 'levacool@outlook.com', '84321567980', '2024-03-11');

DROP TABLE IF EXISTS Borrowed_books CASCADE;
CREATE TABLE Borrowed_books
(
    borrow_id   serial PRIMARY KEY,
    book_id     int,
    reader_id   int,
    borrow_date DATE,
    is_returned BOOLEAN,
    FOREIGN KEY (book_id) REFERENCES Books (book_id) ON DELETE CASCADE,
    FOREIGN KEY (reader_id) REFERENCES Readers (reader_id) ON DELETE CASCADE
);

INSERT INTO Borrowed_books(book_id, reader_id, borrow_date, is_returned) VALUES (1, 1, '2012-12-07', true);

INSERT INTO Borrowed_books(book_id, reader_id, borrow_date, is_returned) VALUES (1, 1, '2024-11-17', false);

INSERT INTO Borrowed_books(book_id, reader_id, borrow_date, is_returned) VALUES (1, 1, '2024-05-07', true);