create table A_darbinieki(
    DARB_ID NUMBER, 
	VARDS VARCHAR2(25), 
	UZVARDS VARCHAR2(25), 
	E_PASTS VARCHAR2(50), 
	PROF_ID NUMBER, 
	DZIMUMS VARCHAR2(15)
    );

insert into A_darbinieki
    select * from darbinieki where rownum <=100000;

-- 100%
select *
    from profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id;

-- 7%
Select *
    from A_darbinieki d , profesijas p 
    where p.prof_id = d.prof_id and 
          p.alga <= 600;         

-- 1%         
select *
    from profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id and
          p.profesija like 'Developer%' and
          d.dzimums = 'Vîrietis';
          
-- 0.1%
select * 
    from profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id and           
          d.uzvards = 'Adler'; 
          
   