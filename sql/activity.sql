-- Create an SQL script to perform the following activities. Note: some of these activities will not be allowed by refential integrity. Identify them in your README.txt.
--     Add a new book to the Main library, ISBN # 96-42013-10510, shelf 8, floor 2, Title Growing your own Weeds, published by pubid 10000 on 6/24/2012.
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

-- Modify the number of copies of ISBN 96-42103-10907 to 8 in the Main library.

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


-- Delete Grace Slick from the Author table.

-- DELETE FROM Author
-- WHERE FirstName = 'Grace'
  -- AND LastName = 'Slick';


-- Add Commander Adams to the author table, id 305, office phone 970-555-5555.

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


-- Add a new book to the South Park library,
-- ISBN # 96-42013-10510, shelf 8, floor 3,
-- Title Growing your own Weeds, published by pubid 10000 on 6/24/2012.

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


-- Delete the book Missing Tomorrow from the Main Library.
-- This deletes the book-location relationship, not necessarily the Book row itself.

DELETE la
FROM LocatedAt la
INNER JOIN Book b
    ON b.ISBN = la.ISBN
WHERE b.Title = 'Missing Tomorrow'
  AND la.LibraryName = 'Main';


-- Add 2 new copies of Eating in the Fort in the South Park library.

UPDATE LocatedAt la
INNER JOIN Book b
    ON b.ISBN = la.ISBN
SET
    la.TotalCopies = la.TotalCopies + 2,
    la.CopiesNotCheckedOut = la.CopiesNotCheckedOut + 2
WHERE b.Title = 'Eating in the Fort'
  AND la.LibraryName = 'South Park';


-- Add a new book to the Main library,
-- ISBN # 96-42013-10513, shelf 8, floor 2,
-- Title Growing your own Weeds, published by pubid 90000 on 6/24/2012.
-- This may fail due to referential integrity if PublisherID 90000 does not exist.

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

-- Print the final contents of the Audit table.
SELECT * FROM Audit;

--     Referential Integrity on book insertions:
--         Books that cannot be fully added because of referential integrity constraints should not remain partially inserted in the database. Make sure any faulty or incomplete book-related insertions are removed before the final state check.
--     Readme requirements:
--         Students must identify the activities blocked by referential integrity
--         Write the SQL statement for the action, even if MySQL rejects it because of referential integrity
--         For activities that are blocked by referential integrity, your activity.sql should still include the attempted SQL statement. In README.txt, explain why the statement fails. 
--     Clarification on Activity 1 and 5 copy counts:
--         The activity says “Add a new book” but does not say how many copies.
--             The grader assumes, explicitly for both Main and South Park additions:
--                 TotalCopies = 1
--                 CopiesNotCheckedOut =1
--     Query output ordering:
--         For Step 5 queries, exact ordering rules are enforced by the autograder
-- 