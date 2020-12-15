
CREATE TABLE Character(
                          cName VARCHAR(40) PRIMARY KEY,
                          description VARCHAR(40),
                          hairColor VARCHAR(40),
                          characterType CHAR NOT NULL, --assume that this is consistent with the appropriate tables
                          CHECK(characterType = 'W' OR characterType = 'N')
);

--relationship between two characters
CREATE TABLE feeling(
                        cNameOne VARCHAR(40),
                        cNameTwo VARCHAR(40),
                        feeling VARCHAR(40),
                        peakMoment VARCHAR(40),
                        PRIMARY KEY (cNameOne, cNameTwo), --therefore only one relationship can exist from one character to another
    --additionally, because the order is important relationships do not have to be mutual
                        CHECK (feeling = 'hate' OR feeling = 'love'),
                        FOREIGN KEY (cNameOne) REFERENCES Character(cName),
                        FOREIGN KEY (cNameTwo) REFERENCES Character(cName)
);
--note: it is impossible to ensure using DDL that a school has at least one student in it using DDL
--because that is dependent on the table attendsSchool. But there, school is not a unique value and
--cannot be. Therefore, a foreign key cannot be created.
CREATE TABLE School(
                       sName VARCHAR(40) PRIMARY KEY,
                       sType CHAR NOT NULL,
                       CHECK (sType = 'M' OR sType = 'T'), -- M for homogeneous and T for heterogeneous Assume this field corresponds
    -- to the tables designated for homogeneous and heterogeneous schools
);

--is a school
CREATE TABLE homogeneousSchool(
                                  sName VARCHAR(40) PRIMARY KEY,
                                  FOREIGN KEY (sName) REFERENCES School(sName)
);

--is a school
CREATE TABLE heterogeneousSchool(
                                    sName VARCHAR(40) PRIMARY KEY,
                                    FOREIGN KEY (sName) REFERENCES School(sName)
);

--This table is not well represented in the ER Diagram but addresses an issue that is unresolvable
--in an ERD. Because every wizard must attend a school, every character that attends a school must
--be a wizard. Therefore, attending a school is equivalent to being a wizard and this design
--is legitimate.
CREATE TABLE attendsSchool(
                              wName VARCHAR(40) UNIQUE, --can only attend one school
                              school VARCHAR(40),
                              PRIMARY KEY (wName, school),
                              FOREIGN KEY (school) REFERENCES School(sName)
);

--relationship between house and wizards. Ensures that at least one wizard in is a house
CREATE TABLE attendsHouse(
                             wName VARCHAR (40) UNIQUE , --wizard can only be in one house
                             school VARCHAR(40) NOT NULL,
                             hName VARCHAR(40),
                             PRIMARY KEY (wName, hName),
                             FOREIGN KEY (wName, school) REFERENCES attendsSchool(wName, school),
                             FOREIGN KEY (school) REFERENCES heterogeneousSchool(sName) --enforce that this school is in fact a heterogeneous school
);

--Enforces that headOfHouse is in house
CREATE TABLE headsHouse(
                           hName VARCHAR(40) PRIMARY KEY,
                           headOfHouse VARCHAR(40) UNIQUE,
                           FOREIGN KEY (headOfHouse, hName) REFERENCES attendsHouse(wName, hName)
);

--weak entity of heterogeneous school
CREATE TABLE House(
                      sName VARCHAR(40),
                      hName VARCHAR(40),
                      color VARCHAR(40),
                      numOfStudents INT,
                      PRIMARY KEY (sName, hName),
                      CHECK (numOfStudents != 0),
                      FOREIGN KEY (sName) REFERENCES heterogeneousSchool(sName), --enforces that only heterogeneous schools have houses
                      FOREIGN KEY (hName) REFERENCES headsHouse(hName) --ensures that only houses with someone in them are created
);

--Only wizards that are already at a school/house and are characters are created
CREATE TABLE Wizard(
                       wName VARCHAR(40) PRIMARY KEY,
                       wandNumber VARCHAR(40),
                       FOREIGN KEY (wName) REFERENCES Character(cName),
                       FOREIGN KEY (wName) REFERENCES attendsSchool(wName)
);

--relationship between wizard and school
CREATE TABLE schoolManager(
                              sName VARCHAR(40) PRIMARY KEY,
                              managerName VARCHAR(40) UNIQUE, --one wizard can manage only one school
                              FOREIGN KEY (sName) REFERENCES School,
                              FOREIGN KEY (managerName) REFERENCES Wizard(wName)
);

CREATE TABLE attendsHomogeneousSchool(
                                         wName VARCHAR(40),
                                         sName VARCHAR(40),
                                         PRIMARY KEY (wName, sName),
                                         FOREIGN KEY (wName) REFERENCES  Wizard(wName),
                                         FOREIGN KEY (sName) REFERENCES homogeneousSchool(sName)
);

--is a character
CREATE TABLE NonWizard(
                          nwName VARCHAR(40) PRIMARY KEY,
                          FOREIGN KEY (nwName) REFERENCES Character(cName)
);

--relationship between non-wizard to wizard
CREATE TABLE loyalty(
                        nwName VARCHAR(40),
                        wName VARCHAR(40) UNIQUE, --non-wizard can only be loyal to one wizard at most
                        PRIMARY KEY (nwName, wName),
                        FOREIGN KEY (nwName) REFERENCES NonWizard(nwName),
                        FOREIGN KEY (wName) REFERENCES Wizard(wName)
);

CREATE TABLE Spell(
                      enchantment VARCHAR(40) PRIMARY KEY,
                      difficulty INT,
                      description VARCHAR(40),
                      CHECK (difficulty <= 5 AND difficulty >= 1)
);

--weak entity of wizard and in relationship with Spell
CREATE TABLE MagicAct(
                         wName VARCHAR(40),
                         time TIMESTAMP,
                         spell VARCHAR(40) NOT NULL,
                         PRIMARY KEY (wName, time),
                         FOREIGN KEY (wName) REFERENCES Wizard(wName),
                         FOREIGN KEY (spell) REFERENCES Spell(enchantment)
);

/* unneccesary because this was absorbed within magicAct. erase if you too do not think that this is important
CREATE TABLE cast(
    wName VARCHAR(40),
    time TIMESTAMP,
    enchantment VARCHAR(40),
    PRIMARY KEY (wName, time, enchantment),
    FOREIGN KEY (wName) REFERENCES Wizard(wName),
    FOREIGN KEY (time) REFERENCES MagicAct(time),
    FOREIGN KEY (enchantment) REFERENCES Spell(enchantment)
);
 */

--only for wizards
CREATE TABLE plays(
                      wName VARCHAR (40) PRIMARY KEY,
                      position VARCHAR(40),
                      CHECK(position = 'seeker' OR position = 'chaser' OR position = 'beater' OR position = 'keeper'),
                      FOREIGN KEY (wName) REFERENCES Wizard(wName)
);

--the NOT NULL fields of player 1-7 ensures that exactly 7 players are associated with each year's team
CREATE TABLE teamOfYear(
                           hName VARCHAR(40),
                           sName VARCHAR(40),
                           year DATE,
                           broomModel VARCHAR(40),
                           player1 VARCHAR (40) NOT NULL,
                           player2 VARCHAR (40) NOT NULL,
                           player3 VARCHAR (40) NOT NULL,
                           player4 VARCHAR (40) NOT NULL,
                           player5 VARCHAR (40) NOT NULL,
                           player6 VARCHAR (40) NOT NULL,
                           player7 VARCHAR (40) NOT NULL,
                           PRIMARY KEY (sName,hName, year),
                           FOREIGN KEY (sName, hName) REFERENCES House(sName, hName),
                           FOREIGN KEY (player1) REFERENCES attendsHouse(wName),
                           FOREIGN KEY (player2) REFERENCES attendsHouse(wName),
                           FOREIGN KEY (player3) REFERENCES attendsHouse(wName),
                           FOREIGN KEY (player4) REFERENCES attendsHouse(wName),
                           FOREIGN KEY (player5) REFERENCES attendsHouse(wName),
                           FOREIGN KEY (player6) REFERENCES attendsHouse(wName),
                           FOREIGN KEY (player7) REFERENCES attendsHouse(wName),
                           --CHECK (player1 <> player2 <> player3 <> player4 <> player5 <> player6 <> player6 <> player7) -- All player must be different
);


--relationship between two teams
CREATE TABLE Game(
                     sHost VARCHAR(40),
                     hostHouse VARCHAR(40),
                     hostYear DATE,
                     guestHouse VARCHAR(40),
                     sGuest VARCHAR(40),
                     guestYear DATE,
                     hostScore VARCHAR(40),
                     guestScore VARCHAR(40),
                     PRIMARY key (sHost, hostHouse, hostYear,sGuest, guestHouse, guestYear), --ensures that this host, hosted only appears once
                     CHECK(hostYear = guestYear), --ensures that only teams of the same year play against one another
                     FOREIGN KEY (sHost, hostHouse, hostYear) REFERENCES teamOfYear(sName, hName, year),
                     FOREIGN KEY (sGuest, guestHouse, guestYear) REFERENCES teamOfYear(sName, hName, year),
);

CREATE TABLE spectated(
                          cName VARCHAR(40),
                          sHost VARCHAR(40),
                          hostHouse VARCHAR(40),
                          hostYear DATE,
                          sGuest VARCHAR(40),
                          guestHouse VARCHAR(40),
                          guestYear DATE,
                          rating INT,
                          PRIMARY KEY(cName, sHost, hostHouse, hostYear, sGuest, guestHouse, guestYear),
                          CHECK(rating >= 1 AND rating <=7),
                          FOREIGN KEY (cName) REFERENCES Character(cName),
                          FOREIGN KEY (sHost, hostHouse, hostYear, sGuest, guestHouse, guestYear)
                              REFERENCES Game(sHost, hostHouse, hostYear,sGuest, guestHouse, guestYear)
);
