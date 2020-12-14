CREATE TABLE Character(
    cName VARCHAR(40) PRIMARY KEY,
    description VARCHAR(40),
    hairColor VARCHAR(40),
    characterType CHAR NOT NULL,

    CHECK(characterType = 'W' OR characterType = 'N')
);

CREATE TABLE Wizard(
    wName VARCHAR(40) PRIMARY KEY,
    wandNumber VARCHAR(40),
    mSchool VARCHAR(40),
    house VARCHAR(40),
    CHECK((mSchool = null OR house = null) AND NOT (mSchool = null AND house = null)),
    FOREIGN KEY (mSchool) REFERENCES homogeneousSchool(sName),
    FOREIGN KEY (wName) REFERENCES Character(cName),
    FOREIGN KEY
);

CREATE TABLE NonWizard(
    nwName VARCHAR(40) PRIMARY KEY,
    FOREIGN KEY (nwName) REFERENCES Character(cName)
);

CREATE TABLE MagicAct(
    wName VARCHAR(40),
    time TIMESTAMP,
    spell VARCHAR(40) NOT NULL,
    PRIMARY KEY (wName, time),
    FOREIGN KEY (wName) REFERENCES Wizard(wName),
    FOREIGN KEY (spell) REFERENCES Spell(enchantment)
);

CREATE TABLE Spell(
    enchantment VARCHAR(40) PRIMARY KEY,
    difficulty INT,
    description VARCHAR(40),
    CHECK (difficulty <= 5 AND difficulty <= 1)
);

CREATE TABLE School(
    sName VARCHAR(40) PRIMARY KEY,
    manager VARCHAR(40) UNIQUE,
    sType CHAR NOT NULL,
    CHECK (sType == 'M' OR sType=='T') -- M for homogeneous and T for heterogeneous
    FOREIGN KEY (manager) REFERENCES Wizard(wName)
);

CREATE TABLE homogeneousSchool(
    sName VARCHAR(40) PRIMARY KEY,
    FOREIGN KEY (sName) REFERENCES School(sName)
);

CREATE TABLE heterogeneousSchool(
    sName VARCHAR(40) PRIMARY KEY,
    FOREIGN KEY (sName) REFERENCES School(sName)
);

CREATE TABLE House(
    sName VARCHAR(40),
    hName VARCHAR(40),
    color VARCHAR(40),
    headOfHouse VARCHAR(40) UNIQUE,
    numOfStudents INT,
    PRIMARY KEY (sName, hName),
    CHECK (numOfStudents != 0),
    FOREIGN KEY (sName) REFERENCES School(sName)
);

CREATE TABLE teamOfYear(
    hName VARCHAR(40),
    year YEAR,
    broomModel VARCHAR(40),
    player1 VARCHAR (40) NOT NULL,
    player2 VARCHAR (40) NOT NULL,
    player3 VARCHAR (40) NOT NULL,
    player4 VARCHAR (40) NOT NULL,
    player5 VARCHAR (40) NOT NULL,
    player6 VARCHAR (40) NOT NULL,
    player7 VARCHAR (40) NOT NULL,
    PRIMARY KEY (hName, year),
    FOREIGN KEY (hName) REFERENCES House(hName),
    FOREIGN KEY (player1) REFERENCES plays(wName),
    FOREIGN KEY (player2) REFERENCES plays(wName),
    FOREIGN KEY (player3) REFERENCES plays(wName),
    FOREIGN KEY (player4) REFERENCES plays(wName),
    FOREIGN KEY (player5) REFERENCES plays(wName),
    FOREIGN KEY (player6) REFERENCES plays(wName),
    FOREIGN KEY (player7) REFERENCES plays(wName)
);

CREATE TABLE feeling(
    cNameOne VARCHAR(40),
    cNameTwo VARCHAR(40),
    feeling VARCHAR(40),
    peakMoment VARCHAR(40),
    PRIMARY KEY (cNameOne, cNameTwo),
    FOREIGN KEY (cNameOne) REFERENCES Character(cName),
    FOREIGN KEY (cNameTwo) REFERENCES Character(cName),
    CHECK (feeling = 'hate' OR feeling = 'love')
);

CREATE TABLE loyalty(
    nwName VARCHAR(40),
    wName VARCHAR(40),
    PRIMARY KEY (nwName, wName),
    FOREIGN KEY (nwName) REFERENCES NonWizard(nwName),
    FOREIGN KEY (wName) REFERENCES Wizard(wName)
);

CREATE TABLE cast(
    wName VARCHAR(40),
    time TIMESTAMP,
    enchantment VARCHAR(40),
    PRIMARY KEY (wName, time, enchantment),
    FOREIGN KEY (wName) REFERENCES Wizard(wName),
    FOREIGN KEY (time) REFERENCES MagicAct(time),
    FOREIGN KEY (enchantment) REFERENCES Spell(enchantment)
);

CREATE TABLE attendsHomogeneousSchool(
    wName VARCHAR(40),
    sName VARCHAR(40),
    PRIMARY KEY (wName, sName),
    FOREIGN KEY (wName) REFERENCES  Wizard(wName),
    FOREIGN KEY (sName) REFERENCES homogeneousSchool(sName)
);
/*
CREATE TABLE attendsHouse(
    wName VARCHAR(40),
    hName VARCHAR(40),
    PRIMARY KEY (wName, hName),
    FOREIGN KEY (wName) REFERENCES  Wizard(wName),
    FOREIGN KEY (hName) REFERENCES House(sName)
)*/

CREATE TABLE plays(
    wName VARCHAR (40) PRIMARY KEY,
    position VARCHAR(40),
    CHECK(position = 'seeker' OR position = 'chaser'
    OR position = 'beater' OR position = 'keeper'),
    FOREIGN KEY (wName) REFERENCES Wizard(wName)
)

CREATE TABLE hostGame(
    hostHouse VARCHAR(40),
    hostYear YEAR,
    hostedHouse VARCHAR(40),
    hostedYear YEAR,
    hostScore VARCHAR(40),
    hostedScore VARCHAR(40),
    PRIMARY key (hostHouse, hostYear, hostedHouse, hostedYear),
    CHECK(hostYear = hostedYear),
    FOREIGN KEY (hostHouse, hostYear) REFERENCES teamOfYear(hName, year),
    FOREIGN KEY (hostedHouse, hostedYear) REFERENCES teamOfYear(hName, year),
)
