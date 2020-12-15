CREATE VIEW LeaderWizard
as
SELECT SM.managerName, MIN(MA.time) as FirstMagic
FROM schoolManager as SM,MagicAct as MA
WHERE  EXISTS
(SELECT wName
 FROM loyalty
 GROUP BY wName
 HAVING COUNT (nwName) > 9
)
GROUP BY SM.managerName;
HAVING COUNT (MA.time) > 0