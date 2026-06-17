CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    FirstName VARCHAR(64) NOT NULL,
    LastName VARCHAR(64) NOT NULL
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

CREATE TABLE Library (
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
    MemberID INT NOT NULL,
    ISBN VARCHAR(16) NOT NULL,
    CheckoutDate DATE NOT NULL,
    CheckinDate DATE,
    PRIMARY KEY (MemberID, ISBN, CheckoutDate),

    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (ISBN) REFERENCES Book(ISBN)
);

CREATE TABLE WrittenBy (
    AuthorID INT NOT NULL,
    ISBN VARCHAR(16) NOT NULL,
    PRIMARY KEY (AuthorID, ISBN),

    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    FOREIGN KEY (ISBN) REFERENCES Book(ISBN)
);

CREATE TABLE PublishedBy (
    PublisherID INT NOT NULL,
    ISBN VARCHAR(16) NOT NULL,
    PRIMARY KEY (PublisherID, ISBN),

    FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID),
    FOREIGN KEY (ISBN) REFERENCES Book(ISBN)
);

CREATE TABLE AuthorPhone (
    AuthorID INT NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    PRIMARY KEY (AuthorID, PhoneNumber),

    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    FOREIGN KEY (PhoneNumber) REFERENCES Phone(PhoneNumber)
);

CREATE TABLE PublisherPhone (
    PublisherID INT NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    PRIMARY KEY (PublisherID, PhoneNumber),

    FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID),
    FOREIGN KEY (PhoneNumber) REFERENCES Phone(PhoneNumber)
);

CREATE TABLE LocatedAt (
    LibraryName VARCHAR(64) NOT NULL,
    ISBN VARCHAR(16) NOT NULL,
    TotalCopies INT,
    CopiesNotCheckedOut INT,
    Shelf INT,
    Floor INT,
    PRIMARY KEY (LibraryName, ISBN),

    FOREIGN KEY (LibraryName) REFERENCES Library(Name),
    FOREIGN KEY (ISBN) REFERENCES Book(ISBN)
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