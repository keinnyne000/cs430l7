from datetime import datetime
import pandas as pd


def getRows(filePath: str):
    file = open(filePath, "r")
    content = file.read()
    content = content.splitlines()
    lines = []
    for row in content:
        if(len(row)==0):
            continue
        line = row.split(',')
        line = [item.strip() for item in line]
        new_line = []
        for item in line:
            try:
                new_line.append(int(item))
            except:
                new_line.append(item)
        lines.append(new_line)
    return lines


def authorToDF(filePath) -> pd.DataFrame:
    # In Cols: [AuthorID, Name, PhoneNumber(type)...]
    # 101, Bobby Ewing, 970-555-1000 (c), 970-555-1010 (h)
    cols = ['AuthorID', 'FirstName', 'LastName', 'PhoneNumber', 'PhoneType']
    rows = getRows(filePath)

    lines = []
    for row in rows:
        name = row[1].split(' ')
        firstName = name[0]
        lastName = name[1]
        phoneNumbers = row[2:]
        for number in phoneNumbers:
            numberLiteral = number[:-4] if number != 'None' else None
            phone_type = number[-2]
            lines.append((row[0], firstName, lastName, numberLiteral, phone_type)) 
            
    return pd.DataFrame(lines, columns=cols) 
    

def publisherToDF(filePath: str):
    # In Cols: [PublisherId, Name, PhoneNumber(type)...]
    # 10006, Flagstaff Publishing, 970-555-5060 (o), 970-555-5070 (c)
    cols = ['PublisherID', 'Name', 'PhoneNumber', 'PhoneType']
    rows = getRows(filePath)
    
    lines = []
    for row in rows:
        phoneNumbers = row[2:]
        for number in phoneNumbers:
            numberLiteral = number[:-4] if number != 'None' else None
            phoneType = number[-2]
            lines.append((row[0], row[1], numberLiteral, phoneType))
    return pd.DataFrame(lines, columns=cols)
            

def membersToDF(filePath: str):
    # In: Member, Name, Gender, DOB
    # In2: ISBN, CheckinDate, CheckoutDate
    # MemberID, FirstName, LastName, DOB, Gender, list[Borrows]
    memberCols = ['MemberID', 'FirstName', 'LastName', 'Gender', 'DOB']
    checkoutCols = ['MemberID', 'ISBN', 'CheckoutDate', 'CheckinDate']

    rows = getRows(filePath)
    lastMemberID = ""
    memberLines = []
    checkoutLines = []
    for row in rows:
        if(len(row) == 4):
            # member
            lastMemberID = row[0]
            name = row[1].split(' ')
            memberLines.append((row[0], name[0], name[1], row[2], formatDate(row[3])))

        else:
            # checkout
            checkinDate = None
            if(len(row) > 2):
                checkinDate = formatDate(row[2])
            checkoutLines.append((lastMemberID, row[0], formatDate(row[1]), checkinDate))
    
    checkoutDF = pd.DataFrame(checkoutLines, columns=checkoutCols)
    memberDF = pd.DataFrame(memberLines, columns=memberCols)
    return checkoutDF, memberDF


def bookToDF(filePath: str, libraryName: str):
    # ISBN, NumberOfCopies, Shelf, Floor, Title, Publisher, DatePublished
    # AuthorIDs
    writtenCols = ['AuthorID', 'ISBN']
    bookCols = ['ISBN', 'NumberOfCopies', 'Shelf', 'Floor', 'Title', 'PublisherID', 'DatePublished', 'YearPublished', 'LibraryName']

    rows = getRows(filePath)
    lastISBN = ""
    writtenLines = []
    bookLines = []
    
    for row in rows:
        if isinstance(row[0], int):
            for authorid in row:
                writtenLines.append((authorid, lastISBN))
        else:
            lastISBN = row[0]
            bookLines.append((row[0], row[1], row[2], row[3],
                              row[4], row[5], formatDate(row[6]),
                              int(row[6][-4:]), libraryName))
    
    writtenDF = pd.DataFrame(writtenLines, columns=writtenCols)
    bookDF = pd.DataFrame(bookLines, columns=bookCols)
    return writtenDF, bookDF

def formatDate(date: str) -> str:
    return datetime.strptime(date, "%m/%d/%Y").strftime("%Y-%m-%d")