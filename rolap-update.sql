UPDATE Readers
SET email = 'Reader123@mail.ru', phone = '99999999999', registration_date = '2019-09-04'
WHERE reader_name = 'Name_113';

UPDATE Facts_table
SET is_returned = true
WHERE reader_id = 31 AND book_id = 87;

UPDATE Books
SET genre_id = (SELECT genre_id FROM Genres WHERE genre_name = 'History')
WHERE published_date > '2023-03-29';