INSERT INTO authors (author_name, birth_date, country)
SELECT
    CONCAT('Author_', FLOOR(RANDOM() * 5000)),
    DATE '1900-01-01' + FLOOR(RANDOM() * 365 * 100)::INTEGER,
    (ARRAY['uk', 'usa', 'russia', 'china', 'france', 'italy', 'mexico', 'turkey', 'netherlands'])[FLOOR(RANDOM() * 5) + 1] AS country
FROM GENERATE_SERIES(1, 100);

INSERT INTO Genres(genre_name)
SELECT unnest(ARRAY[
    'Fiction', 'Biography', 'Detective', 'Thriller', 'Crime',
    'Romance', 'Adventure', 'Science', 'History', 'Tale',
    'Tragedy', 'Poetry', 'Non-fiction', 'Fantasy', 'Comedy',
    'Drama', 'Mystery', 'Lyric', 'Novel', 'Short stories'
    ]);

INSERT INTO Publishers (publisher_name, city, email, phone)
SELECT
    CONCAT('Publisher_', FLOOR(RANDOM()*100000)),
    (ARRAY['Moscow', 'Saint-Petersburg', 'Kazan', 'Yekaterinburg', 'Ufa'])[FLOOR(RANDOM() * 5) + 1] AS city,
    CONCAT('Publisher_', FLOOR(RANDOM() * 100000), '@mail.ru'),
    LPAD(FLOOR(RANDOM() * 10000000000)::TEXT, 11, '0')
FROM GENERATE_SERIES(1, 100);

INSERT INTO books (author_id, publisher_id, title, genre_id, published_date, isbn)
SELECT
    (ARRAY(SELECT author_id FROM Authors))[FLOOR(RANDOM() * (SELECT COUNT(*) FROM Authors)) + 1],
    (ARRAY(SELECT publisher_id FROM Publishers))[FLOOR(RANDOM() * (SELECT COUNT(*) FROM Publishers)) + 1],
    CONCAT('Book name_', FLOOR(RANDOM() * 8000)),
    (ARRAY(SELECT genre_id FROM Genres))[FLOOR(RANDOM() * (SELECT COUNT(*) FROM Genres)) + 1],
    DATE '1950-01-01' + FLOOR(RANDOM() * 365 * 75)::INTEGER,
    LPAD(FLOOR(RANDOM() * 1000000000)::TEXT, 10, '0')
FROM GENERATE_SERIES(1, 100);

INSERT INTO Readers(reader_name, email, phone, registration_date)
SELECT
    CONCAT('Name_', FLOOR(RANDOM() * 10000)),
    CONCAT('Reader_', FLOOR(RANDOM() * 10000), '@kpfu.ru'),
    LPAD(FLOOR(RANDOM() * 10000000000)::TEXT, 11, '0'),
    DATE '2010-01-01' + FLOOR(RANDOM() * 365 * 15)::INTEGER
FROM GENERATE_SERIES(1, 100);

INSERT INTO facts_table (book_id, publisher_id, reader_id, author_id, borrow_date, is_returned)
SELECT
    (ARRAY(SELECT book_id FROM Books))[FLOOR(RANDOM() * (SELECT COUNT(*) FROM Books)) + 1],
    (ARRAY(SELECT publisher_id FROM Publishers))[FLOOR(RANDOM() * (SELECT COUNT(*) FROM Publishers)) + 1],
    (ARRAY(SELECT reader_id FROM Readers))[FLOOR(RANDOM() * (SELECT COUNT(*) FROM Readers)) + 1],
    (ARRAY(SELECT author_id FROM Authors))[FLOOR(RANDOM() * (SELECT COUNT(*) FROM Authors)) + 1],
    DATE '2010-01-01' + FLOOR(RANDOM() * 365 * 15)::INTEGER,
    CASE WHEN RANDOM() < 0.8 THEN TRUE ELSE FALSE END
FROM GENERATE_SERIES(1, 100);