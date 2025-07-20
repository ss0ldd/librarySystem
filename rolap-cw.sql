DROP TABLE IF EXISTS Authors;
CREATE TABLE Authors(
                        author_id serial PRIMARY KEY,
                        author_name VARCHAR(50) NOT NULL ,
                        birth_date DATE,
                        country VARCHAR(20)
);

DROP TABLE IF EXISTS Publishers;
CREATE TABLE Publishers(
                           publisher_id serial PRIMARY KEY,
                           publisher_name VARCHAR(20) NOT NULL UNIQUE,
                           city VARCHAR(20),
                           email VARCHAR(40) NOT NULL UNIQUE,
                           phone VARCHAR(11) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS Genres;
CREATE TABLE Genres(
                       genre_id serial PRIMARY KEY,
                       genre_name VARCHAR(20) NOT NULL
);

DROP TABLE IF EXISTS Books CASCADE;
CREATE TABLE Books(
                      book_id serial PRIMARY KEY,
                      author_id int,
                      publisher_id int,
                      title VARCHAR(30) NOT NULL,
                      genre_id int,
                      published_date DATE,
                      isbn VARCHAR(10) UNIQUE NOT NULL,
                      FOREIGN KEY (genre_id) REFERENCES Genres(genre_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS Readers;
CREATE TABLE Readers(
                        reader_id serial PRIMARY KEY,
                        reader_name VARCHAR(50),
                        email VARCHAR(40) NOT NULL UNIQUE,
                        phone VARCHAR(11) NOT NULL UNIQUE,
                        registration_date DATE
);

DROP TABLE IF EXISTS Facts_table CASCADE;
CREATE TABLE Facts_table(
                            facts_id serial PRIMARY KEY,
                            book_id int,
                            publisher_id int,
                            reader_id int,
                            author_id int,
                            borrow_date DATE,
                            is_returned BOOLEAN NOT NULL,
                            FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
                            FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id) ON DELETE CASCADE,
                            FOREIGN KEY (reader_id) REFERENCES Readers(reader_id) ON DELETE CASCADE,
                            FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE
);