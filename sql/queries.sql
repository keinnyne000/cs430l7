-- 5. Create SQL statements to provide the following information:
-- 
--         List the contents of the Library relation in order according to name.
--         List the contents of the Located at relation in alphabetic order according to ISBN.
--         For each book that has copies in both libraries, list the book name, number of copies, and library sorted by book name.
--         For each library, list library name, and the number of titles sorted by library.

SELECT * FROM Library l
ORDER BY l.Name;

SELECT * FROM LocatedAt la
ORDER BY la.ISBN;

SELECT b.Title, la.TotalCopies, la.LibraryName
FROM Book b INNER JOIN LocatedAt la ON b.ISBN = la.ISBN
WHERE b.ISBN IN (
    SELECT ISBN FROM LocatedAt
    GROUP BY ISBN 
    HAVING COUNT(DISTINCT LibraryName) = 2
    )
ORDER BY b.Title;

SELECT la.LibraryName, COUNT(*) FROM Library l
INNER JOIN LocatedAt la ON la.LibraryName = l.Name
GROUP BY la.LibraryName
ORDER BY la.LibraryName;

-- 6. Create a set of triggers that stores action, date and time anyone successfully adds an author, adds or deletes a book from a library, or modifies the number of copies of a book. An example of creating a trigger in MySQL can be found hereLinks to an external site..
-- 
--     Expected trigger action:
--         Trigger names may be different, but the triggers will be graded by behavior. The Audit table must record the following events.
--             Author INSERT
--             LocatedAt INSERT
--             LocatedAt DELETE
--             LocatedAt UPDATE when copy counts are modified

DELIMITER //
CREATE TRIGGER author_insert
AFTER INSERT ON Author
FOR EACH ROW BEGIN
INSERT INTO Audit(
    TableName,
    AuditAction,
    ActionDateTime
)
VALUES (
    'Author',
    'INSERT',
    NOW()
);
END //

CREATE TRIGGER locat_insert
AFTER INSERT ON LocatedAt
FOR EACH ROW BEGIN
INSERT INTO Audit(
    TableName,
    AuditAction,
    ActionDateTime
)
VALUES (
    'LocatedAt',
    'INSERT',
    NOW()
);
END //

CREATE TRIGGER locat_delete
AFTER DELETE ON LocatedAt
FOR EACH ROW BEGIN
INSERT INTO Audit(
    TableName,
    AuditAction,
    ActionDateTime
)
VALUES (
    'LocatedAt',
    'DELETE',
    NOW()
);
END //

CREATE TRIGGER locat_update
BEFORE UPDATE ON LocatedAt
FOR EACH ROW BEGIN
    IF OLD.CopiesNotCheckedOut <> NEW.CopiesNotCheckedOut THEN
        INSERT INTO Audit(
            TableName,
            AuditAction,
            ActionDateTime
        )
        VALUES (
            'LocatedAt',
            'UPDATE',
            NOW()
        );
    END IF;
END //

-- CREATE TRIGGER update_copies
-- AFTER UPDATE ON BorrowedBy
-- FOR EACH ROW BEGIN
    -- UPDATE LocatedAt la
    -- SET la.CopiesNotCheckedOut = la.TotalCopies - (
        -- SELECT COUNT(*) FROM BorrowedBy bb
        -- WHERE bb.ISBN = NEW.ISBN 
        -- AND la.LibraryName -- ! MORE NEEDED HERE
        -- AND bb.CheckinDate is NULL
    -- )
    -- WHERE la.ISBN = NEW.ISBN;
-- END//
DELIMITER ;

-- 7. Create a view that gives Book name, list of authors, and library name on one line.
-- 
--     (Hint: The GROUP_CONCAT clause could be handy here)
--     Our implementation of using views requires use of the SECURITY INVOKER syntax.
--     An example is:
--         CREATE SQL SECURITY INVOKER VIEW view_name AS SELECT * FROM table_name;

CREATE SQL SECURITY INVOKER VIEW BookAuthorView AS
SELECT
    b.Title AS BookName,
    GROUP_CONCAT(
        CONCAT(a.FirstName, ' ', a.LastName)
        ORDER BY a.LastName, a.FirstName
        SEPARATOR ', '
    ) AS Authors,
    l.Name AS LibraryName
FROM Book b
INNER JOIN WrittenBy wb
    ON b.ISBN = wb.ISBN
INNER JOIN Author a
    ON a.AuthorID = wb.AuthorID
INNER JOIN LocatedAt la
    ON b.ISBN = la.ISBN
INNER JOIN Library l
    ON l.Name = la.LibraryName
GROUP BY
    b.ISBN,
    b.Title,
    l.Name;

-- 8. Using this view, provide a list of books, authors, shelf, and library name sorted by book name.
-- 
--     View:
--         The view should provide one row per book-library combination containing: book name, list of authors, and library name.
--         Final query must follow: Using the created view, list book name, authors, shelf, and library name sorted by book name

SELECT
    bav.BookName,
    bav.Authors,
    la.Shelf,
    bav.LibraryName
FROM BookAuthorView bav
INNER JOIN Book b
    ON b.Title = bav.BookName
INNER JOIN LocatedAt la
    ON la.ISBN = b.ISBN
   AND la.LibraryName = bav.LibraryName
ORDER BY bav.BookName;