SPOOL project.out
SET ECHO ON
/*
CIS 353 - Database Design Project <Inventory Database>
<Cheng Li, Cody Krueger, Cameron Helme, Ryan Basso>
*/
DROP TABLE player CASCADE CONSTRAINTS;
DROP TABLE property CASCADE CONSTRAINTS;
DROP TABLE weapon CASCADE CONSTRAINTS;
DROP TABLE armor CASCADE CONSTRAINTS;
DROP TABLE potion CASCADE CONSTRAINTS;
DROP TABLE spell CASCADE CONSTRAINTS;
DROP TABLE inventory CASCADE CONSTRAINTS;
DROP TABLE damagetype CASCADE CONSTRAINTS;
DROP TABLE playerproperty CASCADE CONSTRAINTS;
--
-- Create the tables for invertory
-- ----------------------------------------------------------------
CREATE TABLE player(
playerName	CHAR(20),
qp		INTEGER 	NOT NULL,
maxWeight	FLOAT		NOT NULL,
class		CHAR(20)	NOT NULL,
--
-- playerIC1:
-- playerName is the primary key.
CONSTRAINT playerIC1 PRIMARY KEY (playerName),
-- playerIC2:
-- A player must be able to hold some amount of weight.
-- and qp(QuestPoint) cannot be negative, you either have 0, or more.
CONSTRAINT playerIC2 CHECK (maxWeight > 0 AND qp >= 0),
-- playerIC3:
-- Player can only be one of following classes.
CONSTRAINT playerIC3 CHECK (class in ('Barbarian', 'Bard', 'Cleric', 
				      'Druid', 'Fighter',  
				      'Paladin', 'Ranger', 'Rogue', 
				      'Sorcerer', 'Wizard'))
);
-- ----------------------------------------------------------------
CREATE TABLE inventory(
inventoryName	CHAR(15),
iPlayer		CHAR(15)	NOT NULL,
location	CHAR(50)	NOT NULL,
--
-- iIC1:
-- inventoryName is the primary key.
CONSTRAINT iIC1 PRIMARY KEY(inventoryName, iPlayer)
);
-- ----------------------------------------------------------------
CREATE TABLE property(
propertyName	CHAR(15),
address		CHAR(50)	NOT NULL,
numRoom		INTEGER		NOT NULL,
--
-- pIC1:
-- propertyName is the primary key.
CONSTRAINT pIC1 PRIMARY KEY (propertyName),
-- pIC2:
-- A property must has at least one room.
CONSTRAINT pIC2 CHECK (numRoom > 0)
);
-- ----------------------------------------------------------------
CREATE TABLE weapon(
wid		INTEGER,
wName		CHAR(20)	NOT NULL,
damage		CHAR(10)	NOT NULL,
wType		CHAR(15)	NOT NULL,
wWeight		FLOAT		NOT NULL,
playerName	CHAR(15) 	NOT NULL,
inventoryName	CHAR(15)	NOT NULL,
--
-- wIC1:
-- wid is the primary key.
CONSTRAINT wIC1 PRIMARY KEY (wid),
-- wIC2:
-- A weapon can have no damage, but the damage must not be negative.
--CONSTRAINT wIC2 CHECK (damage >= 0),
-- wIC3:
-- A weapon must have a weight greater than 0.
CONSTRAINT wIC3 CHECK (wWeight > 0.0),
-- wIC4:
-- The weapon must be hold by a player and exist in one inventory only.
CONSTRAINT wIC4 FOREIGN KEY (inventoryName, playerName) REFERENCES inventory(inventoryName, iPlayer)
);
-- ----------------------------------------------------------------
CREATE TABLE armor(
aid		INTEGER,
armorName	CHAR(25)	NOT NULL,
AC		INTEGER		NOT NULL,
aType		CHAR(15)	NOT NULL,
aCheck		INTEGER		NOT NULL,
aWeight		FLOAT		NOT NULL,
playerName      CHAR(15)        NOT NULL,
inventoryName   CHAR(15)        NOT NULL,
--
-- aIC1:
-- aid is the primary key.
CONSTRAINT aIC1 PRIMARY KEY (aid),
-- aIC2:
-- An armor must have a weight greater than 0.
CONSTRAINT aIC2 CHECK (aWeight > 0),
-- aIC3:
-- The armor must actually exist in an inventory and hold by player.
CONSTRAINT aIC3 FOREIGN KEY (inventoryName, playerName) REFERENCES inventory(inventoryName, iPlayer),
-- aIC4:
-- AC (armor class quality) must be at least 0.
CONSTRAINT aIC4 CHECK (AC >= 0),
-- aIC5:
-- If armor is 'heavy', check must be greater than 1.
CONSTRAINT aIC5 CHECK ((aType = 'heavy' AND aCheck > 1) OR (aType != 'heavy'))
);
-- ----------------------------------------------------------------
CREATE TABLE spell(
sid		INTEGER,
spellName	CHAR(25)	NOT NULL,
casterLevel	INTEGER		NOT NULL,
playerName	CHAR(15)	NOT NULL,
inventoryName	CHAR(15)	NOT NULL,
--
-- spIC1:
-- sid is the primary key.
CONSTRAINT spIC1 PRIMARY KEY (sid),
-- spIC2:
-- Caster level is at least one.
CONSTRAINT spIC2 CHECK (casterLevel >= 1),
-- spIC3:
-- The weapon must actually exist in an inventory and hold by player.
CONSTRAINT spIC3 FOREIGN KEY (inventoryName, playerName) REFERENCES inventory(inventoryName, iPlayer)
);
-- ----------------------------------------------------------------
CREATE TABLE potion(
pid		INTEGER,
potionName	CHAR(25)	NOT NULL,
sid		INTEGER		NOT NULL,
playerName      CHAR(15)        NOT NULL,
inventoryName   CHAR(15)        NOT NULL,
-- poIC1:
-- pid is the primary key
CONSTRAINT poIC1 PRIMARY KEY (pid),
-- poIC2:
-- Potion must also be a type of spell.
CONSTRAINT poIC2 FOREIGN KEY (sid) REFERENCES spell(sid),
-- poIC4:
-- The weapon must actually exist in an inventory and hold by player.
CONSTRAINT poIC4 FOREIGN KEY (inventoryName, playerName) REFERENCES inventory(inventoryName, iPlayer)
);
-- ----------------------------------------------------------------
CREATE TABLE damagetype(
wid		INTEGER		NOT NULL,
damageType	CHAR(15)	NOT NULL,
-- dIC1:
-- wid and damageType are the primary key.
CONSTRAINT dIC1 PRIMARY KEY (wid, damageType),
-- dIC2:
-- a weapon must actually exist.
CONSTRAINT dIC2 FOREIGN KEY (wid) REFERENCES weapon(wid)
);
-- ----------------------------------------------------------------
CREATE TABLE playerproperty(
propertyName	CHAR(15)	NOT NULL,
playerName	CHAR(15)	NOT NULL,
dateBought      DATE		NOT NULL,
-- ppIC1:
-- propertyName and playerName primary key.
CONSTRAINT ppIC1 PRIMARY KEY (propertyName, playerName),
-- ppIC2:
-- A property must actually exist.
CONSTRAINT ppIC2 FOREIGN KEY (propertyName) REFERENCES property(propertyName),
-- ppIC3:
-- A Player must actually exist.
CONSTRAINT ppIC3 FOREIGN KEY (playerName) REFERENCES player(playerName)
);
--
--
--
--ADD THE INSERT DATA BELOW
--
--
--
--
-- ----------------------------------------------------------
-- Populate the database
-- ----------------------------------------------------------
--
SET FEEDBACK OFF
--
alter session set  NLS_DATE_FORMAT = 'YYYY-MM-DD';
--
--gp and qp issue - 1 row 2 constraint issue
insert into player values ('Johannes', 18000, 175.0, 'Paladin');
insert into player values ('Lerdeth', 7000, 260.0, 'Barbarian');
insert into player values ('Alacor', 150, 100.0, 'Wizard');
insert into player values ('Andriel', 750, 130.0, 'Cleric');
--
--
insert into inventory values ('chest', 'Johannes', 'Ship: SS Victory');
insert into inventory values ('saddle bags', 'Johannes', 'Horse: Fury');
insert into inventory values ('vault', 'Johannes', 'Bank of Herrod');
insert into inventory values ('backpack', 'Johannes', 'On Person');
insert into inventory values ('belt', 'Johannes', 'On Person');
insert into inventory values ('equipped', 'Johannes', 'On Person');
insert into inventory values ('backpack', 'Lerdeth', 'On Person');
insert into inventory values ('belt', 'Lerdeth', 'On Person');
insert into inventory values ('saddle bags', 'Lerdeth', 'Horse: brown');
insert into inventory values ('backpack', 'Alacor', 'On Person');
insert into inventory values ('equipped', 'Alacor', 'On Person');
insert into inventory values ('backpack', 'Andriel', 'On Person');
insert into inventory values ('equipped', 'Andriel', 'On Person');
--
--
insert into property values ('house1', '123 Straight St, Herrod', 5);
insert into property values ('house2', 'Ft Zombiehead, Apt 3, Dead Isle', 3);
insert into property values ('ship', 'SS Victory', 4);
insert into property values ('castle_north', 'Vaterland Capitol', 25);
--
--here is where we could had 2 constraint, name contains 'sword', damage must contain slashing
--damage is said to be greater than 0, but that is not possible with string
--remember float for weight
insert into weapon values (01, 'Longsword, Blessed', '1d8+1', '1-handed', 4.0, 'Johannes', 'belt');
insert into weapon values (02, 'Dagger', '1d4', 'light', 1.0, 'Johannes', 'belt');
insert into weapon values (03, 'Lance +1', '1d8+1', '2-handed', 10.0, 'Johannes', 'saddle bags');
insert into weapon values (04, 'Lance', '1d8', '2-handed', 10.0, 'Lerdeth', 'saddle bags');
insert into weapon values (05, 'Greatsword', '2d6', '2-handed', 8.0, 'Lerdeth', 'belt');
insert into weapon values (06, 'Dagger', '1d4', 'light', 1.0, 'Lerdeth', 'belt');
insert into weapon values (07, 'Javelin', '1d6', 'light', 2.0, 'Lerdeth', 'backpack');
insert into weapon values (08, 'Mace, Hvy', '1d8', '1-handed', 2.0, 'Andriel', 'equipped');
insert into weapon values (09, 'Club', '1d6', '1-handed', 2.0, 'Lerdeth', 'belt');
--
--
insert into armor values (11, 'Full Plate +3', 11, 'heavy', 5, 50.0, 'Johannes', 'equipped');
insert into armor values (12, 'Full Plate', 8, 'heavy', 6, 50.0, 'Lerdeth', 'backpack');
insert into armor values (13, 'Robe of the Arch Magi', 2, 'light', 0, 5.5, 'Alacor', 'backpack');
insert into armor values (14, 'Leather', 2, 'light', 0, 15.0, 'Johannes', 'chest');
insert into armor values (15, 'Brass Chain Shirt', 5, 'light', 1, 25.0, 'Johannes', 'backpack');
--
--
insert into spell values (21, 'Cure Light Wounds', 1, 'Andriel', 'backpack');
insert into spell values (22, 'Cure Moderate Wounds', 3, 'Andriel', 'backpack');
insert into spell values (23, 'Cure Serious Wounds', 5, 'Andriel', 'backpack');
insert into spell values (24, 'Cure Critical Wounds', 7, 'Andriel', 'backpack');
insert into spell values (25, 'Evards Black Tentacles', 8, 'Alacor', 'backpack');
--
--
insert into potion values (31, 'Cure Potion', 21, 'Andriel', 'backpack');
insert into potion values (32, 'Cure Potion', 22, 'Andriel', 'backpack');
insert into potion values (33, 'Cure Potion', 23, 'Andriel', 'backpack');
insert into potion values (34, 'Cure Potion', 24, 'Andriel', 'backpack');
insert into potion values (35, 'Scroll of Tentacles', 25, 'Alacor', 'backpack');
--
--
insert into damagetype values (01, 'slashing');
insert into damagetype values (01, 'piercing');
insert into damagetype values (02, 'slashing');
insert into damagetype values (02, 'piercing');
insert into damagetype values (05, 'slashing');
insert into damagetype values (05, 'piercing');
insert into damagetype values (06, 'slashing');
insert into damagetype values (06, 'piercing');
insert into damagetype values (03, 'piercing');
insert into damagetype values (04, 'piercing');
insert into damagetype values (07, 'piercing');
insert into damagetype values (08, 'bludgeoning');
insert into damagetype values (09, 'bludgeoning');
--
--
insert into playerproperty values ('house1', 'Andriel', '1184-05-12');
insert into playerproperty values ('house2', 'Johannes', '1185-08-22');
insert into playerproperty values ('ship', 'Johannes', '1185-08-22');
insert into playerproperty values ('castle_north', 'Johannes', '1180-01-01');
--
--
--insert into weapon values ( , '', '', '', , '', '');
--
--
--
-- ----------------------------------------------------------
--
--
-- ----------------------------------------------------------
-- Queries
-- ----------------------------------------------------------
SET FEEDBACK ON
COMMIT;
-- Print Player Table
SELECT * FROM player;
-- Print Inventory Table
SELECT * FROM inventory;
-- Print Property Table
SELECT * FROM property;
-- Print Weapon Table
SELECT * FROM weapon;
-- Print Armor Table
SELECT * FROM armor;
-- Print Spell Table
SELECT * FROM spell;
-- Print Potion Table
SELECT * FROM potion;
-- Print damage type Table
SELECT * FROM damagetype;
-- Print player property table.
SELECT * FROM playerproperty;
--
-- < START OF QUERIES >
-- < Q01 - A join involving at least four relations. >
-- Find the player name and the player class having an inventory that contains a weapon that has damage type 'piercing'.
SELECT 	P.playerName, P.class, I.inventory, W.wName
FROM 	player P, Inventory I, damagetype D, weapon W
WHERE 	p.playerName = I.iPlayer AND
	I.iPlayer = W.playerName AND
	I.inventoryName = W.inventoryName AND
	W.wid = D.wid AND
	D.damageType = "piercing";
-- < Q02 - A self-join >
-- Find the pair of players having at least one of the same inventory. 
SELECT 	I1.iPlayer, I2.iPlayer
FROM 	inventory I1, inventory I2
WHERE	I1.inventoryName = I2.inventoryName AND
	I1.iPlayer < I2.iPlayer;
-- < Q03 - UNION, INTERSECT, and/or MINUS. >
-- Find the sid and spell name of every spell whose casterLevel is above 2
-- or contain a type of potion.
SELECT	S.sid, S.spellName
FROM 	spell S
WHERE 	s.casterLevel > 2
UNION
SELECT 	S.sid, S.spellName
FROM 	spell S, potion P
WHERE	s.sid = P.pid;
-- < Q04 - SUM, AVG, MAX, and/or MIN. >
-- Find the total weight, highest weight, and average weight of weapon in each inventory.
SELECT	I.iPlayer, I.inventoryName, SUM(W.wWeight), MAX(W.wWeight), AVG(W.wWeight)
FROM 	weapon W, inventory I
WHERE	I.iPlayer = W.playerName AND
	I.inventoryName = W.playerName
GROUP BY I.iPlayer, I.inventoryName;
-- < Q05 - GROUP BY, HAVING, and ORDER BY, all appearing in the same query. >
-- Find the player holding having an inventory that has more than 2 armor in the inventory,
-- also find the total weight of armor is the inventory holding and sort it by total weight.
SELECT  I.iPlayer, I.inventoryName, SUM(A.aWeight), COUNT(*)
FROM    armor A, inventory I
WHERE   I.iPlayer = A.playerName AND
        I.inventoryName = A.inventoryName
GROUP BY I.iPlayer, I.inventoryName
HAVING 	COUNT(*) > 2
ORDER BY SUM(A.aWeight);
-- < Q06 - A correlated subquery. >
-- -- Find the name of every weapon that has a damageType
SELECT W.wName
FROM weapon W
WHERE W.wid =
	(SELECT D.wid
	 FROM damagetype D
	 WHERE D.wid = W.wid);
-- < Q07 - A non-correlated subquery. >
-- Find the name of every weapon that has the damageType 'slashing'
SELECT W.wName
FROM weapon W
WHERE W.wid = 
	(SELECT D.wid
	 FROM damagetype D
	 WHERE D.damageType = "slashing");
-- < Q08 - A relational DIVISION query. >
-- Find the name of every inventory that is not on the player's person
SELECT I.iPlayer, I.inventoryName
FROM inventory I
WHERE I.location NOT EXISTS (SELECT I2.location
				FROM inventory I
				WHERE I2.location = "On Person");
-- < Q09 - An outer join query. >
-- Find the class and the name of every player's inventory
SELECT P.class, I.inventoryName
FROM inventory I
LEFT OUTER JOIN player P
ON I.iPlayer = P.playerName;
-- < Q10 - A RANK query >
-- Finding the rank of weight 10.0 among all the weapons.
SELECT RANK(10.0) WITHIN GROUP
(ORDER BY wWeight) "Weapon Weight RANK FOR 10.0"
FROM weapon;
-- < Q11 - A Top-N query. >
-- Finding the top five casterlevel of spell in the inventory.
SELECT 	sid, spellName, casterLevel
FROM	spell
ORDER BY casterLevel DESC
FETCH FIRST 5 ROWS ONLY;
--
-- Testing: <IC name>
COMMIT;
--
SPOOL OFF
