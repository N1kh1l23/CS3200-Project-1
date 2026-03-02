-- SlangDB: Table Definitions
-- CS 3200 - Database Design | Practicum 1
-- Members: Anthony Kim, Nikhil Sharma

PRAGMA foreign_keys = ON;

CREATE TABLE Origin (
    originId    INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL UNIQUE,
    description TEXT,
    cultureGroup TEXT NOT NULL
);

CREATE TABLE Term (
    termId          INTEGER PRIMARY KEY AUTOINCREMENT,
    text            TEXT NOT NULL UNIQUE,
    difficultyRating INTEGER CHECK(difficultyRating BETWEEN 1 AND 5),
    trendingStatus  TEXT CHECK(trendingStatus IN ('Rising', 'Peak', 'Declining', 'Dead')),
    popularityScore REAL CHECK(popularityScore BETWEEN 0.0 AND 10.0),
    dateAdded       TEXT DEFAULT (date('now')),
    originId        INTEGER NOT NULL,
    FOREIGN KEY (originId) REFERENCES Origin(originId)
);

CREATE TABLE Definition (
    definitionId INTEGER PRIMARY KEY AUTOINCREMENT,
    text         TEXT NOT NULL,
    partOfSpeech TEXT CHECK(partOfSpeech IN ('noun', 'verb', 'adjective', 'interjection', 'adverb')),
    dateAdded    TEXT DEFAULT (date('now')),
    termId       INTEGER NOT NULL,
    FOREIGN KEY (termId) REFERENCES Term(termId)
);

CREATE TABLE Example (
    exampleId    INTEGER PRIMARY KEY AUTOINCREMENT,
    sentence     TEXT NOT NULL,
    source       TEXT,
    dateRecorded TEXT DEFAULT (date('now')),
    definitionId INTEGER NOT NULL,
    FOREIGN KEY (definitionId) REFERENCES Definition(definitionId)
);

CREATE TABLE Category (
    categoryId  INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE Region (
    regionId   INTEGER PRIMARY KEY AUTOINCREMENT,
    regionName TEXT NOT NULL UNIQUE,
    country    TEXT NOT NULL
);

CREATE TABLE TermCategory (
    termId     INTEGER NOT NULL,
    categoryId INTEGER NOT NULL,
    PRIMARY KEY (termId, categoryId),
    FOREIGN KEY (termId) REFERENCES Term(termId),
    FOREIGN KEY (categoryId) REFERENCES Category(categoryId)
);

CREATE TABLE TermRegion (
    termId         INTEGER NOT NULL,
    regionId       INTEGER NOT NULL,
    popularityScore REAL CHECK(popularityScore BETWEEN 0.0 AND 10.0),
    PRIMARY KEY (termId, regionId),
    FOREIGN KEY (termId) REFERENCES Term(termId),
    FOREIGN KEY (regionId) REFERENCES Region(regionId)
);

CREATE TABLE SemanticRelation (
    relationId      INTEGER PRIMARY KEY AUTOINCREMENT,
    fromTermId      INTEGER NOT NULL,
    toTermId        INTEGER NOT NULL,
    relationType    TEXT CHECK(relationType IN ('Synonym', 'Antonym', 'Related')),
    confidenceScore REAL CHECK(confidenceScore BETWEEN 0.0 AND 1.0),
    dateCreated     TEXT DEFAULT (date('now')),
    CHECK (fromTermId != toTermId),
    FOREIGN KEY (fromTermId) REFERENCES Term(termId),
    FOREIGN KEY (toTermId) REFERENCES Term(termId)
);