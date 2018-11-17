/*
Készítsünk két táblát az egyikben legyenek sportcsapatok csapat_id, név.
A másikban a játékosok, id, név, mezszám, csapat_id. A csapat azonosító legyen idegen kulcs.
*/
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

/* A módosítást egy másodpéldányon végezzük, hogy a tábla eredeti tartalma megmaradjon*/

CREATE TABLE dolg2 AS SELECT * FROM nikovits.dolgozo;
CREATE TABLE oszt2 AS SELECT * FROM nikovits.osztaly;

select * FROM dolg2;
select * from dolgozo where oazon in (select oazon from dolgozo);

/* Töröljük azokat a dolgozókat, akiknek jutaléka NULL.*/
/*SELECT * from dolg2 where jutalek IS NULL;*/
DELETE FROM dolg2 where jutalek IS NULL;

/* Töröljük azokat a dolgozókat, akiknek a belépési dátuma 1982 elõtti. */
/*SELECT * FROM dolg2 WHERE belepes < TO_DATE('1982-01-01','YYYY-MM-DD');*/
DELETE FROM dolg2 WHERE belepes < TO_DATE('1982-01-01','YYYY-MM-DD');

/*Töröljük azokat a dolgozókat, akik osztályának telephelye DALLAS.*/
DROP table dolg2;
CREATE TABLE dolg2 AS SELECT * FROM nikovits.dolgozo;
/*select * from oszt2;
select * from dolg2 d NATURAL JOIN oszt2 o WHERE o.telephely = 'DALLAS';
select * from dolg2 d where d.oazon in (select oazon from oszt2 o WHERE o.telephely = 'DALLAS');*/
DELETE FROM dolg2 d where d.oazon in (select oazon from oszt2 o WHERE o.telephely = 'DALLAS');
delete from dolgozo where dkod in (select skod from dolgozo natural join osztaly where telephely='DALLAS')

/* Töröljük azokat a dolgozókat, akiknek a fizetése kisebb, mint az átlagfizetés. */
select * from dolg2 WHERE fizetes < (select avg(fizetes) from dolg2);
delete from dolg2 WHERE fizetes < (select avg(fizetes) from dolg2);

/* Töröljük a jelenleg legjobban keresõ dolgozót. */
select * from dolg2 WHERE fizetes = (select max(fizetes) from dolg2);
delete from dolg2 WHERE fizetes = (select max(fizetes) from dolg2);


/*Töröljük ki azokat az osztályokat, akiknek van olyan dolgozója, aki a 2-es fizetési 
   kategóriába esik (lásd még Fiz_kategoria táblát).*/
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