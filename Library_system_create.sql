COMMENT ON TABLE Books IS 'Создание таблицы с информацией об авторах, читателях, книгах и издатесльтвах для библиотеки';

DROP TABLE IF EXISTS Authors;
CREATE TABLE Authors(
    author_id serial PRIMARY KEY,
    author_name TEXT NOT NULL ,
    birth_date DATE,
    country TEXT
);

DROP TABLE IF EXISTS Publishers;
CREATE TABLE Publishers(
    publisher_id serial PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

DROP TABLE IF EXISTS Genres;
CREATE TABLE Genres(
    genre_id serial PRIMARY KEY,
    genre_name TEXT NOT NULL
);

DROP TABLE IF EXISTS Books CASCADE;
CREATE TABLE Books(
    book_id serial PRIMARY KEY,
    title TEXT NOT NULL,
    author_id int,
    publisher_id int,
    genre_id int,
    published_date DATE,
    isbn TEXT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS Readers;
CREATE TABLE Readers(
    reader_id serial PRIMARY KEY,
    reader_name TEXT,
    email TEXT,
    phone VARCHAR(11),
    registration_date DATE
);

DROP TABLE IF EXISTS Borrowed_books CASCADE;
CREATE TABLE Borrowed_books(
    borrow_id serial PRIMARY KEY,
    book_id int,
    reader_id int,
    borrow_date DATE,
    is_returned BOOLEAN,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (reader_id) REFERENCES Readers(reader_id) ON DELETE CASCADE
);