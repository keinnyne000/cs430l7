INSERT INTO Book(
    ISBN,
    Title,
    YearPublished
)
VALUES(
    '96-42013-10510',
    'Growing your own Weeds',
    2012
);

INSERT INTO PublishedBy(
    PublisherID,
    ISBN
)
VALUES(
    10000,
    '96-42013-10510'
);

INSERT INTO LocatedAt(
    LibraryName,
    ISBN,
    TotalCopies,
    CopiesNotCheckedOut,
    Shelf,
    Floor
) VALUES(
    'Main',
    '96-42013-10510',
    1,
    1,
    8,
    2
);

UPDATE LocatedAt
SET
    TotalCopies = 8,
    CopiesNotCheckedOut = 8 - (
        SELECT COUNT(*)
        FROM BorrowedBy bb
        WHERE bb.ISBN = '96-42103-10907'
          AND bb.CheckinDate IS NULL
    )
WHERE LibraryName = 'Main'
  AND ISBN = '96-42103-10907';


-- DELETE FROM Author
-- WHERE FirstName = 'Grace'
  -- AND LastName = 'Slick';


INSERT INTO Author (
    AuthorID,
    FirstName,
    LastName
)
SELECT
    305,
    'Commander',
    'Adams'
WHERE NOT EXISTS (
    SELECT 1
    FROM Author
    WHERE AuthorID = 305
);

INSERT INTO Phone (
    PhoneNumber,
    PhoneType
)
SELECT
    '970-555-5555',
    'office'
WHERE NOT EXISTS (
    SELECT 1
    FROM Phone
    WHERE PhoneNumber = '970-555-5555'
);

INSERT INTO AuthorPhone (
    AuthorID,
    PhoneNumber
)
SELECT
    305,
    '970-555-5555'
WHERE NOT EXISTS (
    SELECT 1
    FROM AuthorPhone
    WHERE AuthorID = 305
      AND PhoneNumber = '970-555-5555'
);

INSERT INTO Book (
    ISBN,
    Title,
    YearPublished
)
SELECT
    '96-42013-10510',
    'Growing your own Weeds',
    2012
WHERE NOT EXISTS (
    SELECT 1
    FROM Book
    WHERE ISBN = '96-42013-10510'
);

INSERT INTO PublishedBy (
    PublisherID,
    ISBN
)
SELECT
    10000,
    '96-42013-10510'
WHERE NOT EXISTS (
    SELECT 1
    FROM PublishedBy
    WHERE PublisherID = 10000
      AND ISBN = '96-42013-10510'
);

INSERT INTO LocatedAt (
    LibraryName,
    ISBN,
    TotalCopies,
    CopiesNotCheckedOut,
    Shelf,
    Floor
)
SELECT
    'South Park',
    '96-42013-10510',
    1,
    1,
    8,
    3
WHERE NOT EXISTS (
    SELECT 1
    FROM LocatedAt
    WHERE LibraryName = 'South Park'
      AND ISBN = '96-42013-10510'
);

DELETE la
FROM LocatedAt la
INNER JOIN Book b
    ON b.ISBN = la.ISBN
WHERE b.Title = 'Missing Tomorrow'
  AND la.LibraryName = 'Main';

UPDATE LocatedAt la
INNER JOIN Book b
    ON b.ISBN = la.ISBN
SET
    la.TotalCopies = la.TotalCopies + 2,
    la.CopiesNotCheckedOut = la.CopiesNotCheckedOut + 2
WHERE b.Title = 'Eating in the Fort'
  AND la.LibraryName = 'South Park';

-- INSERT INTO Book (
    -- ISBN,
    -- Title,
    -- YearPublished
-- )
-- SELECT
    -- '96-42013-10513',
    -- 'Growing your own Weeds',
    -- 2012
-- WHERE NOT EXISTS (
    -- SELECT 1
    -- FROM Book
    -- WHERE ISBN = '96-42013-10513'
-- );

-- INSERT INTO PublishedBy (
    -- PublisherID,
    -- ISBN
-- )
-- SELECT
    -- 90000,
    -- '96-42013-10513'
-- WHERE NOT EXISTS (
    -- SELECT 1
    -- FROM PublishedBy
    -- WHERE PublisherID = 90000
      -- AND ISBN = '96-42013-10513'
-- );

-- INSERT INTO LocatedAt (
    -- LibraryName,
    -- ISBN,
    -- TotalCopies,
    -- CopiesNotCheckedOut,
    -- Shelf,
    -- Floor
-- )
-- SELECT
    -- 'Main',
    -- '96-42013-10513',
    -- 1,
    -- 1,
    -- 8,
    -- 2
-- WHERE NOT EXISTS (
    -- SELECT 1
    -- FROM LocatedAt
    -- WHERE LibraryName = 'Main'
      -- AND ISBN = '96-42013-10513'
-- );

SELECT * FROM Audit;