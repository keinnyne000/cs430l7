create table Author (
    AuthorID INT PRIMARY KEY,
    FirstName varchar(64) NOT NULL,
    LastName varchar(64) NOT NULL
);

CREATE TABLE Phone (
    PhoneNumber VARCHAR(20) PRIMARY KEY NOT NULL,
    PhoneType VARCHAR(30) NOT NULL
);

CREATE TABLE Publisher (
    PublisherID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(64) NOT NULL
);

CREATE TABLE Book (
    ISBN VARCHAR(16) PRIMARY KEY NOT NULL,
    Title VARCHAR(64) NOT NULL,
    YearPublished INT NOT NULL
);

CREATE TABLE Member (
    MemberID INT PRIMARY KEY NOT NULL,
    LastName VARCHAR(64) NOT NULL,
    FirstName VARCHAR(64) NOT NULL,
    DOB DATE NOT NULL,
    Gender VARCHAR(1) NOT NULL
);

CREATE TABLE Library(
    Name VARCHAR(64) PRIMARY KEY NOT NULL,
    Street VARCHAR(64) NOT NULL,
    City VARCHAR(64) NOT NULL,
    State VARCHAR(2) NOT NULL
);

CREATE TABLE Audit (
    AuditID INT PRIMARY KEY NOT NULL,
    TableName VARCHAR(32) NOT NULL,
    AuditAction VARCHAR(32) NOT NULL,
    ActionDateTime TIMESTAMP NOT NULL
);

-- Relations:
CREATE TABLE BorrowedBy (
    MemberID INT,
    ISBN VARCHAR(16),
    CheckoutDate DATE,
    CheckinDate DATE,
    PRIMARY KEY (MemberID, ISBN, CheckoutDate)
);

CREATE TABLE WrittenBy (
    AuthorID INT,
    ISBN VARCHAR(16),
    PRIMARY KEY (AuthorID, ISBN)
);

CREATE TABLE PublishedBy (
    PublisherID INT,
    ISBN VARCHAR(16),
    PRIMARY KEY (PublisherID, ISBN)
);

CREATE TABLE AuthorPhone (
    AuthorID INT,
    PhoneNumber VARCHAR(20),
    PRIMARY KEY (AuthorID, PhoneNumber)
);

CREATE TABLE PublisherPhone (
    PublisherID INT,
    PhoneNumber VARCHAR(20),
    PRIMARY KEY (PublisherID, PhoneNumber)
);

CREATE TABLE LocatedAt (
    LibraryName VARCHAR(64),
    ISBN VARCHAR(16),
    TotalCopies INT,
    CopiesNotCheckedOut INT,
    Shelf INT,
    Floor INT,
    PRIMARY KEY(LibraryName, ISBN)
);

-- DELIMITER //
-- CREATE TRIGGER update_copies
-- AFTER UPDATE ON BorrowedBy
-- FOR EACH ROW BEGIN
    -- UPDATE LocatedAt la
    -- SET la.CopiesNotCheckedOut = la.TotalCopies - (
        -- SELECT COUNT(*) FROM BorrowedBy bb
        -- WHERE bb.ISBN = NEW.ISBN 
        -- AND bb.CheckinDate is NULL
    -- )
    -- WHERE la.ISBN = NEW.ISBN;
-- END//
-- DELIMITER ;