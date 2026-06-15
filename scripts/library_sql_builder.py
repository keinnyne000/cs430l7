from pathlib import Path

import readers as rd
import pandas as pd
import numpy as np


def loadData(dataDir: str | Path) -> dict[str, pd.DataFrame]:
    dataDir = Path(dataDir)

    authorDF = rd.authorToDF(dataDir / "author.txt")
    publisherDF = rd.publisherToDF(dataDir / "publisher.txt")
    checkoutDF, membersDF = rd.membersToDF(dataDir / "members.txt")

    writtenDF, bookDF = rd.bookToDF(dataDir / "book.txt", "Main")
    writtenDF2, bookDF2 = rd.bookToDF(dataDir / "newbook.txt", "South Park")

    writtenDF = pd.concat([writtenDF, writtenDF2], ignore_index=True)
    bookDF = pd.concat([bookDF, bookDF2], ignore_index=True)

    return {
        "authorDF": authorDF,
        "publisherDF": publisherDF,
        "checkoutDF": checkoutDF,
        "membersDF": membersDF,
        "writtenDF": writtenDF,
        "bookDF": bookDF,
    }


def sqlValue(value):
    if pd.isna(value):
        return "NULL"

    if isinstance(value, (int, float, np.integer, np.floating)):
        return str(value)

    escaped = str(value).replace("'", "''")
    return f"'{escaped}'"


def dfToSQL(queryDF: pd.DataFrame, tableName: str) -> str:
    colnames = queryDF.columns

    columns = ", ".join(f"`{cname}`" for cname in colnames)

    values = []
    for _, row in queryDF.iterrows():
        rowValues = [sqlValue(item) for item in row]
        values.append("(" + ", ".join(rowValues) + ")")

    return (
        f"INSERT INTO `{tableName}` ({columns}) VALUES\n"
        + ",\n".join(values)
        + ";"
    )


def buildAuthor(authorDF):
    return authorDF[['AuthorID', 'FirstName', 'LastName']].drop_duplicates()


def buildPhone(authorDF, publisherDF):
    authorPhones = authorDF[['PhoneNumber', 'PhoneType']].drop_duplicates()
    publisherPhones = publisherDF[['PhoneNumber', 'PhoneType']].drop_duplicates()

    return (
        pd.concat([authorPhones, publisherPhones], ignore_index=True)
        .dropna(subset=['PhoneNumber'])
        .drop_duplicates()
    )


def buildPublisher(publisherDF):
    return publisherDF[['PublisherID', 'Name']].drop_duplicates()


def buildBook(bookDF):
    return bookDF[['ISBN', 'Title', 'YearPublished']].drop_duplicates()


def buildMember(membersDF):
    return membersDF[['MemberID', 'LastName', 'FirstName', 'DOB']].drop_duplicates()


def buildBorrowedBy(checkoutDF):
    return checkoutDF[['MemberID', 'ISBN', 'CheckoutDate', 'CheckinDate']].drop_duplicates()


def buildWrittenBy(writtenDF):
    return writtenDF[['AuthorID', 'ISBN']].drop_duplicates()


def buildPublishedBy(bookDF):
    return bookDF[['PublisherID', 'ISBN']].drop_duplicates()


def buildAuthorPhone(authorDF):
    return (
        authorDF[['AuthorID', 'PhoneNumber']]
        .dropna(subset=['PhoneNumber'])
        .drop_duplicates()
    )


def buildPublisherPhone(publisherDF):
    return (
        publisherDF[['PublisherID', 'PhoneNumber']]
        .dropna(subset=['PhoneNumber'])
        .drop_duplicates()
    )


def buildAll(dataDir: str | Path) -> str:
    data = loadData(dataDir)

    tables = {
        "Author": buildAuthor(data["authorDF"]),
        "Phone": buildPhone(data["authorDF"], data["publisherDF"]),
        "Publisher": buildPublisher(data["publisherDF"]),
        "Book": buildBook(data["bookDF"]),
        "Member": buildMember(data["membersDF"]),
        "BorrowedBy": buildBorrowedBy(data["checkoutDF"]),
        "WrittenBy": buildWrittenBy(data["writtenDF"]),
        "PublishedBy": buildPublishedBy(data["bookDF"]),
        "AuthorPhone": buildAuthorPhone(data["authorDF"]),
        "PublisherPhone": buildPublisherPhone(data["publisherDF"]),
    }

    queries = []

    for tableName, tableDF in tables.items():
        queries.append(dfToSQL(tableDF, tableName))

    fullSQL = "\n\n".join(queries)

    return fullSQL