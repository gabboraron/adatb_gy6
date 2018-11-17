/*
K�sz�ts�nk k�t t�bl�t az egyikben legyenek sportcsapatok csapat_id, n�v.
A m�sikban a j�t�kosok, id, n�v, mezsz�m, csapat_id. A csapat azonos�t� legyen idegen kulcs.
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

/* A m�dos�t�st egy m�sodp�ld�nyon v�gezz�k, hogy a t�bla eredeti tartalma megmaradjon*/

CREATE TABLE dolg2 AS SELECT * FROM nikovits.dolgozo;
CREATE TABLE oszt2 AS SELECT * FROM nikovits.osztaly;

select * FROM dolg2;
select * from dolgozo where oazon in (select oazon from dolgozo);

/* T�r�lj�k azokat a dolgoz�kat, akiknek jutal�ka NULL.*/
/*SELECT * from dolg2 where jutalek IS NULL;*/
DELETE FROM dolg2 where jutalek IS NULL;

/* T�r�lj�k azokat a dolgoz�kat, akiknek a bel�p�si d�tuma 1982 el�tti. */
/*SELECT * FROM dolg2 WHERE belepes < TO_DATE('1982-01-01','YYYY-MM-DD');*/
DELETE FROM dolg2 WHERE belepes < TO_DATE('1982-01-01','YYYY-MM-DD');

/*T�r�lj�k azokat a dolgoz�kat, akik oszt�ly�nak telephelye DALLAS.*/
DROP table dolg2;
CREATE TABLE dolg2 AS SELECT * FROM nikovits.dolgozo;
/*select * from oszt2;
select * from dolg2 d NATURAL JOIN oszt2 o WHERE o.telephely = 'DALLAS';
select * from dolg2 d where d.oazon in (select oazon from oszt2 o WHERE o.telephely = 'DALLAS');*/
DELETE FROM dolg2 d where d.oazon in (select oazon from oszt2 o WHERE o.telephely = 'DALLAS');
delete from dolgozo where dkod in (select skod from dolgozo natural join osztaly where telephely='DALLAS')

/* T�r�lj�k azokat a dolgoz�kat, akiknek a fizet�se kisebb, mint az �tlagfizet�s. */
select * from dolg2 WHERE fizetes < (select avg(fizetes) from dolg2);
delete from dolg2 WHERE fizetes < (select avg(fizetes) from dolg2);

/* T�r�lj�k a jelenleg legjobban keres� dolgoz�t. */
select * from dolg2 WHERE fizetes = (select max(fizetes) from dolg2);
delete from dolg2 WHERE fizetes = (select max(fizetes) from dolg2);


/*T�r�lj�k ki azokat az oszt�lyokat, akiknek van olyan dolgoz�ja, aki a 2-es fizet�si 
   kateg�ri�ba esik (l�sd m�g Fiz_kategoria t�bl�t).*/
   select oazon from dolgozo join fiz_kategoria
    on fizetes between also and felso
    where kategoria = 2;
delete from dolgozo where oazon in(
select oazon from dolgozo join fiz_kategoria
    on fizetes between also and felso
    where kategoria = 2);
    
    /* 2es fizet�si kategor�a */
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