# 7. óra | GY6
> fájl: http://vopraai.web.elte.hu/tananyag/adatb1819/7.ora/feladat.txt

`````SQL

CREATE TABLE proba1

`````

Ha készítéskor van olyan amiben van `NOT NULL` akkor nem lehet benne `null` értékű oszlop vagy hasonló.
default érték adás:

`DEFAULT 'Joe'`

Egyben:
````SQL

CREATE TABLE proba123(
  u_id INT NOT NULL,
  --oszlopnév típus megszorítás
  nev VARCHAR(10) DEFAULT 'Joe' NOT NULL 
  --...
);

````

## Kulcsok
idegen kulcs: 
`````SQL
CONSTRAINT sportcsapatok_fk
 Foreign key (csapat id)
 references sportcsapatok(csapat_id)
`````
ahol a `cspat_id` az elsődleges kulcs a `sportcsapatok`ban:
````SQL
 CONSTRAINT sportcs_pk PRIMARY KEY (csapat_id)
````
Egybe:
````SQL
CREATE TABLE sportcs
(
    csapat_id numeric(10) not null,
    nev       varchar(50) not null,
    CONSTRAINT sportcs_pk PRIMARY KEY (csapat_id)
);

CREATE TABLE jatekosok
(
    j_id      numeric(10) not null,
    nev       varchar(50) not null,
    mezszam   numeric(2)  not null,
    csapat_id numeric(10) not null,
    CONSTRAINT jatekosok_fk FOREIGN KEY (csapat_id) REFERENCES sportcs(csapat_id)
);
````


`elsődleges kulcs` alapján gyors a keresés
`idegen kulcs` alapján jól lehet összekapcsoln



## Hibát fog adni akkor ha:
- úgy törlök ki beszállítót hogy az szerepel valahol máshol a termékek között
- olyant akarok betenni aki már létezik

`create view` - nézet táblát hoz létre, amit úgy tudunk kezelni mintha egy tábla lenne de nem hoz létre egy másolatot, így ha az eredetiben törlődik valami akkor itt is

- nézet tábla praktikus ha pl két táblát joinulunk össze, mindent lehet vele amit egy normálissal

`ALTER TABLE` parancs után lehet módosításokat elrendelni, pl: 
`````SQL
ALTER TABLE proba123 DROP COLUMN nev;
ALTER TABLE proba123 ADD / MODIFY nev VARCHAR(30);
`````

`TRUNCATE`tel lehet törölni úgy hogy közben a struktúra megmarad csak a tábla vész el
````SQL
TRUNCATE TABLE proba123;
````

Teljes törlés : 
````SQL
DROP TABLE proba123;

````
Feltételes törlés:
````SQL

DELETE FROM proba123 WHERE nev='Peti';

````


`INSERT INTO` sort szúr be:
````SQL

INSERT INTO proba123 VALUES (2, 'Feri');
INSERT INTO proba123 (nev, uid) VALUES ('Jozsi', 3);

````

Módosítás `update table`vel
````SQL

UPDATE proba123 SET nev='Peti', id=1 WHERE nev='Jozsi';

````

## Feladatok
> feltétel használata törléshez
````SQL
select * from dolgozo where oazon in
  (select oazon from dolgozo);
````

> Töröljük azokat a dolgozókat, akiknek jutaléka NULL.
````SQL
/*SELECT * from dolg2 where jutalek IS NULL;*/
DELETE FROM dolg2 where jutalek IS NULL;
````

> Töröljük azokat a dolgozókat, akiknek a belépési dátuma 1982 előtti. 
````SQL
/*SELECT * FROM dolg2 WHERE belepes < TO_DATE('1982-01-01','YYYY-MM-DD');*/
DELETE FROM dolg2 WHERE belepes < TO_DATE('1982-01-01','YYYY-MM-DD');
````

>Töröljük azokat a dolgozókat, akik osztályának telephelye DALLAS.
```SQL
DROP table dolg2;
CREATE TABLE dolg2 AS SELECT * FROM nikovits.dolgozo;
/*select * from oszt2;
select * from dolg2 d NATURAL JOIN oszt2 o WHERE o.telephely = 'DALLAS';
select * from dolg2 d where d.oazon in (select oazon from oszt2 o WHERE o.telephely = 'DALLAS');*/
DELETE FROM dolg2 d where d.oazon in (select oazon from oszt2 o WHERE o.telephely = 'DALLAS');
/* VAGY */
delete from dolgozo where dkod in (select skod from dolgozo natural join osztaly where telephely='DALLAS')
````
> Töröljük azokat a dolgozókat, akiknek a fizetése kisebb, mint az átlagfizetés.
````SQL
select * from dolg2 WHERE fizetes < (select avg(fizetes) from dolg2);
delete from dolg2 WHERE fizetes < (select avg(fizetes) from dolg2);
````

> Töröljük a jelenleg legjobban kereső dolgozót. 
````SQL
select * from dolg2 WHERE fizetes = (select max(fizetes) from dolg2);
delete from dolg2 WHERE fizetes = (select max(fizetes) from dolg2);
````

> Töröljük ki azokat az osztályokat, akiknek van olyan dolgozója, aki a 2-es fizetési 
   kategóriába esik (lásd még Fiz_kategoria táblát).
````SQL
   select oazon from dolgozo join fiz_kategoria
    on fizetes between also and felso
    where kategoria = 2;

delete from dolgozo where oazon in(
select oazon from dolgozo join fiz_kategoria
    on fizetes between also and felso
    where kategoria = 2);

    /* 2es fizetési kategoría */

select oazon from dolgozo join fiz_kategoria
    on fizetes between also and felso
    where kategoria = 2 
    group by oazon
    having count(*)>=2;    

delete from osztaly where oazon in 
(select oazon from dolgozo join fiz_kategoria
    on fizetes between also and felso
    where kategoria = 2 
    group by oazon
    having count(*)>=2);
````

