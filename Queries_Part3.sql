CREATE VIEW LeaderWizard
as
SELECT SM.managerName, MIN(MA.time) as FirstMagic
FROM schoolManager as SM,MagicAct as MA
WHERE  EXISTS
(SELECT wName
 FROM loyalty WHERE loyalty.wName = SM.wName
 GROUP BY wName
 HAVING COUNT (nwName) > 9
) AND
SM.wName = MA.wName
GROUP BY SM.managerName;
HAVING COUNT (MA.time) > 0


SELECT
FROM Wizard
WHERE NOT EXISTS ((SELECT * FROM feeling Where Wizard.wName = feeling.cNameOne) MINUS
                  (SELECT * FROM feeling WHERE Wizard.wName = feeling.cNameOne AND
                   feeling.feeling = 'LOVE')) AND
