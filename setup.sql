CREATE TABLE Person (
    id INTEGER PRIMARY KEY,
    firstname VARCHAR NOT NULL,
    lastname VARCHAR NOT NULL,
    email VARCHAR,
    phoneNumber VARCHAR,
    ssn VARCHAR
);

CREATE TABLE Company (
    id INTEGER PRIMARY KEY,
    companyName VARCHAR NOT NULL,
    isHiring BOOLEAN NOT NULL DEFAULT 1
);

CREATE TABLE Address (
    id INTEGER PRIMARY KEY,
    street VARCHAR,
    city VARCHAR,
    state VARCHAR,
    zip VARCHAR
);

CREATE TABLE JobListing (
    id INTEGER PRIMARY KEY,
    companyId INTEGER NOT NULL,
    salaryMin INTEGER,
    salaryMax INTEGER,
    isActive BOOLEAN NOT NULL DEFAULT 1,
    workType TEXT CHECK(workType IN ('remote', 'hybrid', 'onsite')),
    locationId INTEGER,
    FOREIGN KEY (companyId) REFERENCES Company(id),
    FOREIGN KEY (locationId) REFERENCES Address(id)
);

CREATE TABLE Requirement (
    id INTEGER PRIMARY KEY,
    description VARCHAR NOT NULL
);

CREATE TABLE JobRequirement (
    listingId INTEGER NOT NULL,
    requirementId INTEGER NOT NULL,
    isMandatory BOOLEAN NOT NULL DEFAULT 0,
    PRIMARY KEY (listingId, requirementId),
    FOREIGN KEY (listingId) REFERENCES JobListing(id),
    FOREIGN KEY (requirementId) REFERENCES Requirement(id)
);

CREATE TABLE JobApplication (
    id INTEGER PRIMARY KEY,
    personId INTEGER NOT NULL,
    companyId INTEGER NOT NULL,
    listingId INTEGER NOT NULL,
    status TEXT CHECK(status IN ('pending', 'interviewing', 'rejected', 'offered')) NOT NULL DEFAULT 'pending',
    FOREIGN KEY (personId) REFERENCES Person(id),
    FOREIGN KEY (companyId) REFERENCES Company(id),
    FOREIGN KEY (listingId) REFERENCES JobListing(id)
);

CREATE TABLE Interview (
    id INTEGER PRIMARY KEY,
    applicationId INTEGER NOT NULL,
    round INTEGER NOT NULL DEFAULT 1,
    type TEXT CHECK(type IN ('phone', 'technical', 'behavioral', 'onsite')),
    passed BOOLEAN,
    FOREIGN KEY (applicationId) REFERENCES JobApplication(id)
);

CREATE TABLE Offer (
    id INTEGER PRIMARY KEY,
    applicationId INTEGER NOT NULL,
    salary INTEGER,
    startingBonus DECIMAL,
    easyBonus DECIMAL,
    stocks INTEGER,
    accepted BOOLEAN,
    expiryDate DATE,
    FOREIGN KEY (applicationId) REFERENCES JobApplication(id)
);
