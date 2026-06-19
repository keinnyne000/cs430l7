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