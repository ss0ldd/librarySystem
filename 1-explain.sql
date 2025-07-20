EXPLAIN (analyse, verbose ) SELECT author.country, author.birth_date
FROM readers reader
JOIN borrowed_books borrowed_b ON borrowed_b.reader_id = reader.reader_id
JOIN books book ON book.book_id = borrowed_b.book_id
JOIN authors author ON book.author_id = author.author_id
WHERE (author.country = 'FRANCE' OR author.country = 'USA') AND author.birth_date > '1920-01-01';
-- https://explain.tensor.ru/archive/explain/15688b5192c1f0e2d4ada5ed52b4eba1:0:2025-04-04

EXPLAIN (analyse, verbose ) SELECT book.isbn, book.published_date, publisher.city, borrowed_b.is_returned
FROM books book
JOIN borrowed_books borrowed_b ON borrowed_b.book_id = book.book_id
JOIN authors author ON author.author_id = book.author_id
JOIN publishers publisher ON publisher.publisher_id = book.publisher_id
WHERE (book.published_date > '2018-01-01' OR publisher.city = 'Moscow') AND borrowed_b.is_returned = true;
-- https://explain.tensor.ru/archive/explain/4e009ea5e3f0ebe9be48214039b69e0b:0:2025-04-04

EXPLAIN (analyse, verbose ) SELECT reader.email, book.title, genre.genre_name, book.published_date
FROM books book
JOIN genres genre ON genre.genre_id = book.genre_id
JOIN borrowed_books borrowed_b ON borrowed_b.book_id = book.book_id
JOIN readers reader ON borrowed_b.reader_id = reader.reader_id
WHERE (genre.genre_name = 'History' OR genre.genre_name = 'Biography') AND (book.published_date > '2010-01-01' AND book.published_date < '2023-01-01')
-- https://explain.tensor.ru/archive/explain/b93de66a69aa19f44faaa3f9669e6cdd:0:2025-04-04