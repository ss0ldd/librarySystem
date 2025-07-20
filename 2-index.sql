CREATE INDEX CONCURRENTLY included_index_books ON books(author_id) INCLUDE (title, isbn, published_date);

CREATE INDEX CONCURRENTLY borrowed_books_index
    ON public.borrowed_books(book_id);

CREATE INDEX CONCURRENTLY functional_partial_index
    ON public.authors(lower(country))
    WHERE
        birth_date > '1998-01-01'::date;

EXPLAIN (analyse, verbose ) SELECT author.author_name, author.country, author.birth_date, book.title, book.isbn, book.published_date
                            FROM readers reader
                                     JOIN borrowed_books borrowed_b ON borrowed_b.reader_id = reader.reader_id
                                     JOIN books book ON book.book_id = borrowed_b.book_id
                                     JOIN authors author ON book.author_id = author.author_id
                            WHERE (lower(author.country) = 'france' OR lower(author.country) = 'usa') AND author.birth_date > '1998-01-01';
-- https://explain.tensor.ru/archive/explain/d2d229ee0f8644eaeb5ed7245f68165e:0:2025-04-09

-- Nested Loop  (cost=13.02..23.82 rows=1 width=46) (actual time=0.195..0.751 rows=3 loops=1)
-- "  Output: author.author_name, author.country, author.birth_date, book.title, book.isbn, book.published_date"
--   Inner Unique: true
--   ->  Nested Loop  (cost=12.74..23.43 rows=1 width=50) (actual time=0.173..0.715 rows=3 loops=1)
-- "        Output: borrowed_b.reader_id, book.title, book.isbn, book.published_date, author.author_name, author.country, author.birth_date"
--         ->  Nested Loop  (cost=12.60..23.25 rows=1 width=50) (actual time=0.158..0.643 rows=24 loops=1)
-- "              Output: book.title, book.isbn, book.published_date, book.book_id, author.author_name, author.country, author.birth_date"
--               ->  Bitmap Heap Scan on public.authors author  (cost=8.30..12.32 rows=1 width=22) (actual time=0.120..0.168 rows=25 loops=1)
-- "                    Output: author.author_id, author.author_name, author.birth_date, author.country"
--                     Recheck Cond: (((lower(author.country) = 'france'::text) AND (author.birth_date > '1998-01-01'::date)) OR ((lower(author.country) = 'usa'::text) AND (author.birth_date > '1998-01-01'::date)))
--                     Heap Blocks: exact=18
--                     ->  BitmapOr  (cost=8.30..8.30 rows=1 width=0) (actual time=0.058..0.060 rows=0 loops=1)
--                           ->  Bitmap Index Scan on functional_partial_index  (cost=0.00..4.15 rows=1 width=0) (actual time=0.051..0.051 rows=14 loops=1)
--                                 Index Cond: (lower(author.country) = 'france'::text)
--                           ->  Bitmap Index Scan on functional_partial_index  (cost=0.00..4.15 rows=1 width=0) (actual time=0.005..0.005 rows=11 loops=1)
--                                 Index Cond: (lower(author.country) = 'usa'::text)
--               ->  Bitmap Heap Scan on public.books book  (cost=4.30..10.91 rows=2 width=36) (actual time=0.009..0.010 rows=1 loops=25)
-- "                    Output: book.book_id, book.title, book.author_id, book.publisher_id, book.genre_id, book.published_date, book.isbn"
--                     Recheck Cond: (book.author_id = author.author_id)
--                     Heap Blocks: exact=22
--                     ->  Bitmap Index Scan on included_index_books  (cost=0.00..4.29 rows=2 width=0) (actual time=0.006..0.006 rows=1 loops=25)
--                           Index Cond: (book.author_id = author.author_id)
--         ->  Index Scan using borrowed_books_index on public.borrowed_books borrowed_b  (cost=0.15..0.17 rows=1 width=8) (actual time=0.002..0.002 rows=0 loops=24)
-- "              Output: borrowed_b.borrow_id, borrowed_b.book_id, borrowed_b.reader_id, borrowed_b.borrow_date, borrowed_b.is_returned"
--               Index Cond: (borrowed_b.book_id = book.book_id)
--   ->  Index Only Scan using readers_pkey on public.readers reader  (cost=0.27..0.39 rows=1 width=4) (actual time=0.010..0.010 rows=1 loops=3)
--         Output: reader.reader_id
--         Index Cond: (reader.reader_id = borrowed_b.reader_id)
--         Heap Fetches: 3
-- Planning Time: 11.375 ms
-- Execution Time: 0.902 ms


CREATE INDEX CONCURRENTLY book_index ON books (book_id) WHERE books.published_date > '2018-01-01';
CREATE INDEX CONCURRENTLY author_index ON authors (author_id);
CREATE INDEX CONCURRENTLY borrowed_b_index ON borrowed_books (book_id) WHERE NOT is_returned;
CREATE INDEX CONCURRENTLY publishers_index ON publishers (publisher_id) WHERE publishers.city = 'Moscow';


EXPLAIN (analyse, verbose) SELECT book.isbn, book.published_date, publisher.city, borrowed_b.is_returned
                            FROM books book
                                     JOIN borrowed_books borrowed_b ON borrowed_b.book_id = book.book_id
                                     JOIN authors author ON author.author_id = book.author_id
                                     JOIN publishers publisher ON publisher.publisher_id = book.publisher_id
                            WHERE (book.published_date > '2018-01-01' AND publisher.city = 'Moscow') AND borrowed_b.is_returned = false;
-- https://explain.tensor.ru/archive/explain/470af2d4759ea5559e6187660a11f0e3:0:2025-04-14

-- Nested Loop  (cost=257.91..291.78 rows=48 width=25) (actual time=1.319..1.478 rows=51 loops=1)
-- "  Output: book.isbn, book.published_date, publisher.city, borrowed_b.is_returned"
--   Inner Unique: true
--   ->  Merge Join  (cost=257.63..270.64 rows=48 width=29) (actual time=1.305..1.395 rows=51 loops=1)
-- "        Output: book.isbn, book.published_date, book.author_id, borrowed_b.is_returned, publisher.city"
--         Inner Unique: true
--         Merge Cond: (book.publisher_id = publisher.publisher_id)
--         ->  Sort  (cost=257.35..257.95 rows=242 width=24) (actual time=1.288..1.296 rows=251 loops=1)
-- "              Output: book.isbn, book.published_date, book.author_id, book.publisher_id, borrowed_b.is_returned"
--               Sort Key: book.publisher_id
--               Sort Method: quicksort  Memory: 36kB
--               ->  Hash Join  (cost=127.94..247.76 rows=242 width=24) (actual time=0.682..1.234 rows=251 loops=1)
-- "                    Output: book.isbn, book.published_date, book.author_id, book.publisher_id, borrowed_b.is_returned"
--                     Inner Unique: true
--                     Hash Cond: (borrowed_b.book_id = book.book_id)
--                     ->  Bitmap Heap Scan on public.borrowed_books borrowed_b  (cost=54.34..167.13 rows=2679 width=5) (actual time=0.100..0.419 rows=2679 loops=1)
-- "                          Output: borrowed_b.borrow_id, borrowed_b.book_id, borrowed_b.reader_id, borrowed_b.borrow_date, borrowed_b.is_returned"
--                           Recheck Cond: (NOT borrowed_b.is_returned)
--                           Heap Blocks: exact=86
--                           ->  Bitmap Index Scan on borrowed_b_index  (cost=0.00..53.67 rows=2679 width=0) (actual time=0.080..0.080 rows=2679 loops=1)
--                     ->  Hash  (cost=58.00..58.00 rows=1248 width=27) (actual time=0.569..0.569 rows=1251 loops=1)
-- "                          Output: book.isbn, book.published_date, book.book_id, book.author_id, book.publisher_id"
--                           Buckets: 2048  Batches: 1  Memory Usage: 90kB
--                           ->  Index Scan using book_index on public.books book  (cost=0.28..58.00 rows=1248 width=27) (actual time=0.011..0.386 rows=1251 loops=1)
-- "                                Output: book.isbn, book.published_date, book.book_id, book.author_id, book.publisher_id"
--         ->  Index Scan using publishers_index on public.publishers publisher  (cost=0.28..89.77 rows=2233 width=13) (actual time=0.014..0.055 rows=294 loops=1)
-- "              Output: publisher.publisher_id, publisher.publisher_name, publisher.city"
--   ->  Index Only Scan using author_index on public.authors author  (cost=0.29..0.44 rows=1 width=4) (actual time=0.001..0.001 rows=1 loops=51)
--         Output: author.author_id
--         Index Cond: (author.author_id = book.author_id)
--         Heap Fetches: 0
-- Planning Time: 0.585 ms
-- Execution Time: 1.546 ms

CREATE INDEX CONCURRENTLY books_id_index ON books(genre_id) WHERE (books.published_date > '2010-01-01' AND books.published_date < '2023-01-01');
CREATE INDEX CONCURRENTLY borrowed_books_id_index ON borrowed_books(book_id);
CREATE INDEX CONCURRENTLY readers_id_index ON readers(reader_id);

EXPLAIN (analyse, verbose ) SELECT reader.email, book.title, genre.genre_name, book.published_date
                            FROM books book
                                     JOIN genres genre ON genre.genre_id = book.genre_id
                                     JOIN borrowed_books borrowed_b ON borrowed_b.book_id = book.book_id
                                     JOIN readers reader ON borrowed_b.reader_id = reader.reader_id
                            WHERE (genre.genre_name = 'History' OR genre.genre_name = 'Biography') AND (book.published_date > '2010-01-01' AND book.published_date < '2023-01-01')
-- https://explain.tensor.ru/archive/explain/35ab201f08ba76fb4815d5053b33c14f:0:2025-04-14#explain

--     Nested Loop  (cost=58.55..250.02 rows=23 width=69) (actual time=0.109..1.634 rows=246 loops=1)
-- "  Output: reader.email, book.title, genre.genre_name, book.published_date"
--   Inner Unique: true
--   ->  Nested Loop  (cost=58.27..241.98 rows=23 width=54) (actual time=0.103..1.215 rows=246 loops=1)
-- "        Output: book.title, book.published_date, genre.genre_name, borrowed_b.reader_id"
--         ->  Hash Join  (cost=57.98..228.99 rows=24 width=54) (actual time=0.098..0.765 rows=250 loops=1)
-- "              Output: book.title, book.published_date, book.book_id, genre.genre_name"
--               Inner Unique: true
--               Hash Cond: (book.genre_id = genre.genre_id)
--               ->  Bitmap Heap Scan on public.books book  (cost=28.77..193.50 rows=2382 width=26) (actual time=0.074..0.485 rows=2379 loops=1)
-- "                    Output: book.book_id, book.title, book.author_id, book.publisher_id, book.genre_id, book.published_date, book.isbn"
--                     Recheck Cond: ((book.published_date > '2010-01-01'::date) AND (book.published_date < '2023-01-01'::date))
--                     Heap Blocks: exact=129
--                     ->  Bitmap Index Scan on books_id_index  (cost=0.00..28.18 rows=2382 width=0) (actual time=0.054..0.055 rows=2379 loops=1)
--               ->  Hash  (cost=29.05..29.05 rows=13 width=36) (actual time=0.016..0.017 rows=4 loops=1)
-- "                    Output: genre.genre_name, genre.genre_id"
--                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                     ->  Seq Scan on public.genres genre  (cost=0.00..29.05 rows=13 width=36) (actual time=0.008..0.013 rows=4 loops=1)
-- "                          Output: genre.genre_name, genre.genre_id"
--                           Filter: ((genre.genre_name = 'History'::text) OR (genre.genre_name = 'Biography'::text))
--                           Rows Removed by Filter: 36
--         ->  Index Scan using borrowed_books_id_index on public.borrowed_books borrowed_b  (cost=0.29..0.52 rows=2 width=8) (actual time=0.001..0.002 rows=1 loops=250)
-- "              Output: borrowed_b.borrow_id, borrowed_b.book_id, borrowed_b.reader_id, borrowed_b.borrow_date, borrowed_b.is_returned"
--               Index Cond: (borrowed_b.book_id = book.book_id)
--   ->  Index Scan using readers_id_index on public.readers reader  (cost=0.29..0.35 rows=1 width=23) (actual time=0.001..0.001 rows=1 loops=246)
-- "        Output: reader.reader_id, reader.reader_name, reader.email, reader.phone, reader.registration_date"
--         Index Cond: (reader.reader_id = borrowed_b.reader_id)
-- Planning Time: 0.471 ms
-- Execution Time: 1.677 ms
