CREATE TABLE Entities (
                          entity_id SERIAL PRIMARY KEY,
                          name TEXT NOT NULL
);

CREATE TABLE Attributes (
                            attribute_id SERIAL PRIMARY KEY,
                            attribute_name TEXT UNIQUE NOT NULL,
                            data_type TEXT NOT NULL CHECK (data_type IN ('string', 'integer', 'date'))
);

CREATE TABLE EntityValues (
                              entity_id INT REFERENCES Entities(entity_id) ON DELETE CASCADE,
                              attribute_id INT REFERENCES Attributes(attribute_id),
                              value JSONB NOT NULL,
                              PRIMARY KEY (entity_id, attribute_id)
);

INSERT INTO Entities (name)
VALUES ('Война и мир');

INSERT INTO Attributes (attribute_name, data_type)
VALUES
    ('Переводчик', 'string'),
    ('Серия', 'string'),
    ('ISBN', 'string'),
    ('Рейтинг', 'integer'),
    ('Дата поступления', 'date');

INSERT INTO EntityValues (entity_id, attribute_id, value)
VALUES
    (1, 1, '{"value": "Александр Маршалл"}'),
    (1, 2, '{"value": "Зарубежная классика"}'),
    (1, 5, '{"value": "2020-01-15"}');

SELECT
    e.name AS книга,
    a.attribute_name AS атрибут,
    CASE
        WHEN a.data_type = 'string' THEN v.value ->> 'value'
        WHEN a.data_type = 'integer' THEN (v.value ->> 'value')::TEXT
        WHEN a.data_type = 'date' THEN (v.value ->> 'value')::DATE::TEXT
        END AS значение
FROM Entities e
         JOIN EntityValues v ON e.entity_id = v.entity_id
         JOIN Attributes a ON v.attribute_id = a.attribute_id;