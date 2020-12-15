CREATE VIEW LeaderWizard
as
SELECT SM.managerName, MIN(MA.time) as FirstMagic
FROM schoolManager as SM,MagicAct as MA
WHERE  EXISTS
    (SELECT *
     FROM loyalty WHERE loyalty.wName = SM.managerName
     GROUP BY wName
     HAVING COUNT (nwName) > 9
    ) AND
        SM.managerName = MA.wName
GROUP BY SM.managerName;


CREATE VIEW doucheWizard_And_UsefulMagic
as
SELECT Wizard.wName, COUNT(MagicAct.time) AS NumberOfAct
FROM Wizard, MagicAct
WHERE Wizard.wName = MagicAct.wName AND
    NOT EXISTS(
        (SELECT * FROM feeling WHERE Wizard.wName = feeling.cNameOne) EXCEPT
        (SELECT * FROM feeling WHERE Wizard.wName = feeling.cNameOne AND
                   feeling.feeling = 'LOVE')) AND
    NOT EXISTS (
        (SELECT * FROM feeling WHERE Wizard.wName = feeling.cNameTwo) EXCEPT
        (SELECT * FROM feeling WHERE Wizard.wName = feeling.cNameTwo AND
                   feeling.feeling = 'HATE')) AND
    NOT EXISTS(
        (SELECT DISTINCT CONVERT(date, MagicAct.time) FROM MagicAct) EXCEPT
        (SELECT DISTINCT CONVERT(date, MagicAct.time) FROM MagicAct WHERE Wizard.wName = MagicAct.wName)
        ) AND
    EXISTS(SELECT * FROM feeling WHERE feeling.cNameOne = Wizard.wName AND feeling.feeling = 'LOVE') AND
    EXISTS(SELECT * FROM feeling WHERE feeling.cNameTwo = Wizard.wName AND feeling.feeling = 'HATE')
GROUP BY Wizard.wName
ORDER BY COUNT(MagicAct.time) DESC;

