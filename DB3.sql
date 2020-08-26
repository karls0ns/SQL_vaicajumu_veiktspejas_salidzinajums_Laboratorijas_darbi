create table SKOLOTAJI(
ID number(4),
VARDS varchar2(30),
UZVARDS varchar2(30),
MACIBU_PRIEKSMETS varchar2(30)
);

create table Klases(
ID number(4),
NOSAUKUMS varchar2(3),
SKOLOTAJA_ID number(4),
TELPAS_ID number(4)
);

create table SKOLNIEKI(
ID Number(4),
VARDS varchar2(30),
UZVARDS varchar2(30),
KLASES_ID number(4),
PULCINA_ID number(4)
);

create table TELPAS(
ID number(4),
NUMURS number(3),
KLASES_ID number(4),
SKOLOTAJA_ID number(4),
PULCINA_ID number(4)
);

create table PULCINI(
ID number(4),
NOSAUKUMS varchar2(30),
APRAKSTS varchar2(1000)
);

select * from skolotaji;
select * from klases;
select * from pulcini;
select * from telpas;
select * from skolnieki
where KLASES_ID = 78;


    
select P.NOSAUKUMS, S.VARDS as "Skolnieka Vârds", S.UZVARDS as "Skolniek Uzvârds", K.NOSAUKUMS as Klase, SK.VARDS as "Skolotâja vârds", SK.UZVARDS as "Skolotâja uzvârds"
from TELPAS T, PULCINI P, SKOLNIEKI S, KLASES K, SKOLOTAJI SK
where
    T.ID = 113 and
    P.ID = T.PULCINA_ID and
    P.ID = S.PULCINA_ID and
    K.ID = S.KLASES_ID and
    K.SKOLOTAJA_ID = SK.ID 
order by S.UZVARDS, S.VARDS;

SELECT VARDS, telpas.NUMURS
FROM skolnieki
LEFT OUTER JOIN telpas
ON skolnieki.klases_ID = telpas.klases_ID;

Select S.VARDS, T.NUMURS
from skolnieki s, telpas t
    where s.klases_ID = t.klases_ID;


select * from skolnieki
where pulcina_ID is not NULL;

select * from skolnieki
where exists 
 (select * from skolnieki where pulcina_ID is  not Null) ;
    
    
create view Skolnieki_V AS
    Select Vards, Uzvards
    from Skolnieki;





Select Vards, Uzvards from skolnieki
    where vards = 'Shaun';
    
Select Vards, Uzvards from skolnieki_v
    where vards = 'Shaun';


select distinct vards from skolnieki;

select s.Vards, s.ID, k.nosaukums
    from skolnieki s, klases k
    where s.klases_ID = k.ID;
    
select s.Vards, s.ID
    from skolnieki s
    
    union all
    
    select k.nosaukums, k.ID
    from klases k;