
CREATE TABLE Character(
                          cName VARCHAR(40) PRIMARY KEY,
                          description VARCHAR(40) NOT NULL,
                          hairColor VARCHAR(40) NOT NULL,
                          characterType CHAR NOT NULL, --assume that this is consistent with the appropriate tables
                          CHECK(characterType = 'W' OR characterType = 'N')
);

--relationship between two characters
CREATE TABLE feeling(
    cNameOne VARCHAR(40),
    cNameTwo VARCHAR(40),
    feeling VARCHAR(40) NOT NULL,
    peakMoment VARCHAR(40) NOT NULL,
    PRIMARY KEY (cNameOne, cNameTwo),
    CHECK (feeling = 'hate' OR feeling = 'love'),
    FOREIGN KEY (cNameOne) REFERENCES Character(cName) ON DELETE CASCADE,
    FOREIGN KEY (cNameTwo) REFERENCES Character(cName)-- ON DELETE CASCADE
);

CREATE TABLE School(
                       sName VARCHAR(40) PRIMARY KEY,
                       sType CHAR NOT NULL,
                       CHECK (sType = 'M' OR sType = 'T'), -- M for homogeneous and T for heterogeneous
);

--is a school
CREATE TABLE homogeneousSchool(
    sName VARCHAR(40) PRIMARY KEY,
    FOREIGN KEY (sName) REFERENCES School(sName) ON DELETE CASCADE
);

--is a school
CREATE TABLE heterogeneousSchool(
    sName VARCHAR(40) PRIMARY KEY,
    FOREIGN KEY (sName) REFERENCES School(sName) ON DELETE CASCADE
);

CREATE TABLE attendsSchool(
    wName VARCHAR(40) UNIQUE, --can only attend one school
    school VARCHAR(40),
    PRIMARY KEY (wName, school),
    FOREIGN KEY (school) REFERENCES School(sName) ON DELETE CASCADE
);

--relationship between house and wizards. Ensures that at least one wizard in is a house
CREATE TABLE attendsHouse(
    wName VARCHAR (40) UNIQUE , --wizard can only be in one house
    school VARCHAR(40) NOT NULL,
    hName VARCHAR(40),
    PRIMARY KEY (wName, hName),
    FOREIGN KEY (wName, school) REFERENCES attendsSchool(wName, school) ON DELETE CASCADE,
    --enforce that this school is in fact a heterogeneous school
    FOREIGN KEY (school) REFERENCES heterogeneousSchool(sName)  --ON DELETE CASCADE
);

--Enforces that headOfHouse is in house
CREATE TABLE headsHouse(
    hName VARCHAR(40) PRIMARY KEY,
    headOfHouse VARCHAR(40) UNIQUE,
    FOREIGN KEY (headOfHouse, hName) REFERENCES attendsHouse(wName, hName) ON DELETE CASCADE
);

--weak entity of heterogeneous school
CREATE TABLE House(
    hName VARCHAR(40) PRIMARY KEY ,
    sName VARCHAR(40) NOT NULL ,
    color VARCHAR(40) NOT NULL,
    numOfStudents INT NOT NULL, --needs SQL in order to properly maintain. see notes.
    CHECK (numOfStudents != 0),
    --enforces that only heterogeneous schools have houses
    FOREIGN KEY (sName) REFERENCES heterogeneousSchool(sName) ON DELETE CASCADE,
    --ensures that only houses with someone in them are created
    FOREIGN KEY (hName) REFERENCES headsHouse(hName) --ON DELETE CASCADE -- at every moment that the house exists there
                                                                       -- should be a head of house
);

--Only wizards that are already at a school/house and are characters are created
CREATE TABLE Wizard(
                       wName VARCHAR(40) PRIMARY KEY,
                       wandNumber VARCHAR(40) NOT NULL,
                       FOREIGN KEY (wName) REFERENCES Character(cName) ON DELETE CASCADE,
                       FOREIGN KEY (wName) REFERENCES attendsSchool(wName) --ON DELETE CASCADE
);

--relationship between wizard and school
CREATE TABLE schoolManager(
                              sName VARCHAR(40) PRIMARY KEY,
                              managerName VARCHAR(40) UNIQUE NOT NULL, --one wizard can manage only one school
                              FOREIGN KEY (sName) REFERENCES School ON DELETE CASCADE,
                              FOREIGN KEY (managerName) REFERENCES Wizard(wName) --ON DELETE CASCADE
);

CREATE TABLE attendsHomogeneousSchool(
    wName VARCHAR(40),
    sName VARCHAR(40),
    PRIMARY KEY (wName, sName),
    FOREIGN KEY (wName) REFERENCES  Wizard(wName) ON DELETE CASCADE,
    FOREIGN KEY (sName) REFERENCES homogeneousSchool(sName) --ON DELETE CASCADE
);

--is a character
CREATE TABLE NonWizard(
    nwName VARCHAR(40) PRIMARY KEY,
    FOREIGN KEY (nwName) REFERENCES Character(cName) ON DELETE CASCADE
);

--relationship between non-wizard to wizard
CREATE TABLE loyalty(
                        nwName VARCHAR(40),
                        wName VARCHAR(40) UNIQUE, --non-wizard can only be loyal to one wizard at most
                        PRIMARY KEY (nwName, wName),
                        FOREIGN KEY (nwName) REFERENCES NonWizard(nwName) ON DELETE CASCADE,
                        FOREIGN KEY (wName) REFERENCES Wizard(wName) --ON DELETE CASCADE
);

CREATE TABLE Spell(
                      enchantment VARCHAR(40) PRIMARY KEY,
                      difficulty INT NOT NULL,
                      description VARCHAR(40) NOT NULL,
                      CHECK (difficulty <= 5 AND difficulty >= 1)
);

--weak entity of wizard and in relationship with Spell
CREATE TABLE MagicAct(
                         wName VARCHAR(40),
                         time DATETIME,
                         spell VARCHAR(40) NOT NULL,
                         PRIMARY KEY (wName, time),
                         FOREIGN KEY (wName) REFERENCES Wizard(wName) ON DELETE CASCADE,
                         FOREIGN KEY (spell) REFERENCES Spell(enchantment) --ON DELETE CASCADE
);

--only for wizards
CREATE TABLE plays(
                      wName VARCHAR (40) PRIMARY KEY,
                      position VARCHAR(40),
                      CHECK(position = 'seeker' OR position = 'chaser' OR position = 'beater' OR position = 'keeper'),
                      FOREIGN KEY (wName) REFERENCES Wizard(wName) ON DELETE CASCADE
);

--the NOT NULL fields of player 1-7 ensures that exactly 7 players are associated with each year's team
CREATE TABLE teamOfYear(
                           hName VARCHAR(40),
                           year INT,
                           broomModel VARCHAR(40),
                           player1 VARCHAR (40) NOT NULL,
                           player2 VARCHAR (40) NOT NULL,
                           player3 VARCHAR (40) NOT NULL,
                           player4 VARCHAR (40) NOT NULL,
                           player5 VARCHAR (40) NOT NULL,
                           player6 VARCHAR (40) NOT NULL,
                           player7 VARCHAR (40) NOT NULL,
                           PRIMARY KEY (hName, year),
                           CHECK(year >= 0 AND year < 10000), --reasonable boundaries on the range of years
                           FOREIGN KEY (hName) REFERENCES House(hName) ON DELETE CASCADE,
                           FOREIGN KEY (player1) REFERENCES attendsHouse(wName), --no delete cascade because even
                           FOREIGN KEY (player2) REFERENCES attendsHouse(wName), --if one wizard does not exist
                           FOREIGN KEY (player3) REFERENCES attendsHouse(wName), --the team should not be erased
                           FOREIGN KEY (player4) REFERENCES attendsHouse(wName),
                           FOREIGN KEY (player5) REFERENCES attendsHouse(wName),
                           FOREIGN KEY (player6) REFERENCES attendsHouse(wName),
                           FOREIGN KEY (player7) REFERENCES attendsHouse(wName),
                           
);


--relationship between two teams
CREATE TABLE Game(
                     hostHouse VARCHAR(40),
                     hostYear INT, --the proper range is ensured by the foreign key
                     guestHouse VARCHAR(40),
                     guestYear INT, --the proper range is ensured by the foreign key
                     hostScore VARCHAR(40),
                     guestScore VARCHAR(40),
                     PRIMARY key (hostHouse, hostYear, guestHouse, guestYear), --ensures that this host, hosted only appears once
                     CHECK(hostYear = guestYear), --ensures that only teams of the same year play against one another
                     FOREIGN KEY (hostHouse, hostYear) REFERENCES teamOfYear(hName, year) ON DELETE CASCADE ,
                     FOREIGN KEY (guestHouse, guestYear) REFERENCES teamOfYear(hName, year) --ON DELETE CASCADE,
);

CREATE TABLE spectated(
                          cName VARCHAR(40),
                          hostHouse VARCHAR(40),
                          hostYear INT,--the proper range is ensured by the foreign key
                          guestHouse VARCHAR(40),
                          guestYear INT,--the proper range is ensured by the foreign key
                          rating INT,
                          PRIMARY KEY(cName,hostHouse, hostYear,guestHouse, guestYear),
                          CHECK(rating >= 1 AND rating <=7),
                          FOREIGN KEY (cName) REFERENCES Character(cName) ON DELETE CASCADE,
                          FOREIGN KEY (hostHouse, hostYear,guestHouse, guestYear)
                              REFERENCES Game(hostHouse, hostYear,guestHouse, guestYear) ON DELETE CASCADE
);
