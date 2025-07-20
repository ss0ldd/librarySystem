SELECT *
FROM facts_table
JOIN Authors a ON facts_table.author_id = a.author_id
JOIN Readers r ON facts_table.reader_id = r.reader_id
JOIN Books b ON facts_table.book_id = b.book_id
JOIN Genres g ON b.genre_id = g.genre_id
JOIN Publishers p ON facts_table.publisher_id = p.publisher_id;

SELECT r.reader_name, r.phone, r.email, b.title, ft.is_returned
FROM Readers r
JOIN facts_table ft ON ft.reader_id = r.reader_id
JOIN books b ON b.book_id = ft.book_id
WHERE r.reader_name = 'Name_1328';

SELECT b.title, g.genre_name, a.author_name, ft.is_returned
FROM Books b
JOIN Genres g ON b.genre_id = g.genre_id
JOIN Authors a ON b.author_id = a.author_id
JOIN Facts_table ft ON b.book_id = ft.book_id
WHERE g.genre_name = 'History' AND b.published_date > '1965-05-29' AND ft.is_returned = 'true'