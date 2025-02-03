COMMENT ON TABLE Books IS 'CTE. Таблица с информацией о читателях, взявших книги, напечатанные после 2000 года';

WITH RecentBooks AS (SELECT book_id, title, published_date
                     FROM Books
                     WHERE published_date > '2000-01-01'),
     BorrowedRecentBooks AS (SELECT borrowed.reader_id, book.title, book.published_date
                             FROM Borrowed_books AS borrowed
                                      JOIN RecentBooks book ON borrowed.book_id = book.book_id)
SELECT reader.reader_name, borrowed_recent.title, borrowed_recent.published_date
FROM Readers reader
         JOIN BorrowedRecentBooks borrowed_recent ON reader.reader_id = borrowed_recent.reader_id;

COMMENT ON TABLE Books IS 'CTE. Таблица с информацией о читателях, взявших книги после начала 2024';
WITH RecentBorrowed AS (SELECT book_id, borrow_date, reader_id
                        FROM Borrowed_books
                        WHERE borrow_date > '2024-01-01'),
     BorrowedBooks AS (SELECT book.book_id, book.title, recent_b.reader_id, recent_b.borrow_date
                       FROM Books book
                                JOIN RecentBorrowed recent_b ON book.book_id = recent_b.book_id)
SELECT reader.reader_id, reader.reader_name, borrowed_b.title, borrowed_b.borrow_date
FROM Readers reader
         JOIN BorrowedBooks borrowed_b ON borrowed_b.reader_id = reader.reader_id;

COMMENT ON TABLE Books IS 'JOIN';
SELECT reader.reader_name, book.title, borrowed_b.borrow_date
FROM Readers reader
         JOIN Borrowed_books borrowed_b ON reader.reader_id = borrowed_b.reader_id
         JOIN Books book ON borrowed_b.book_id = book.book_id;

SELECT publ.publisher_name, book.title
FROM Books book
         JOIN Publishers publ ON publ.publisher_id = book.publisher_id;

SELECT reader.reader_name, book.title, borrowed_b.borrow_date
FROM Readers reader
         LEFT JOIN Borrowed_books borrowed_b ON reader.reader_id = borrowed_b.reader_id
         LEFT JOIN Books book ON borrowed_b.book_id = book.book_id;

SELECT book.title, borrowed_b.borrow_date, reader.reader_name
FROM Borrowed_books borrowed_b
         RIGHT JOIN Readers reader ON reader.reader_id = borrowed_b.reader_id
         RIGHT JOIN Books book ON book.book_id = borrowed_b.book_id;

SELECT reader.reader_name, book.title, borrowed_b.borrow_date
FROM Readers reader
         FULL OUTER JOIN Borrowed_books borrowed_b ON reader.reader_id = borrowed_b.reader_id
         FULL OUTER JOIN Books book ON borrowed_b.book_id = book.book_id;

COMMENT ON TABLE Books IS 'JOIN';

SELECT author_name AS name, 'Author' AS type
FROM Authors
        UNION ALL
        SELECT publisher_name AS name, 'Publisher' AS type
        FROM Publishers;
SELECT reader_name, registration_date, 'Before 2020' AS category
FROM Readers
        WHERE registration_date < '2020-01-01'
        UNION ALL
SELECT reader_name, registration_date, 'After 2020' AS category
FROM Readers
        WHERE registration_date >= '2020-01-01';
