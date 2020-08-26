create or replace type PROFESIJA_B_TIPS as object (
    PROF_ID number(4), 
	PROFESIJA varchar2(100), 
	NODARBINATIBA varchar2(10), 
	ALGA float(2)
    );
    
create table PROFESIJAS_B of PROFESIJA_B_TIPS;

insert into PROFESIJAS_B   
    select * from PROFESIJAS;



create or replace type DARBINIEKS_B_TIPS as object(
    DARB_ID number, 
	VARDS varchar2(25), 
	UZVARDS varchar2(25), 
	E_PASTS varchar2(50), 
	PROF_ID number, 
	DZIMUMS varchar2(15),
    PROF_ATSAUCE ref PROFESIJA_B_TIPS
    );

create table Darbinieki_B of DARBINIEKS_B_TIPS;

insert into DARBINIEKI_B
    (darb_ID,vards,uzvards,e_pasts,prof_ID,dzimums) 
    select darb_ID,vards,uzvards,e_pasts,prof_ID,dzimums from darbinieki_A;


DECLARE                            
    ats_1       REF  PROFESIJA_B_TIPS;    
    cursor DARBINIEKI_KUR is
        SELECT A.DARB_ID,A.Prof_ID
        FROM DARBINIEKI_B A;
BEGIN  
	FOR DARB_ID in DARBINIEKI_KUR
		LOOP       
            select REF(a) into ats_1
                from Profesijas_B a
                where a.Prof_ID = darb_ID.prof_ID;
            update DARBINIEKI_B a
                set a.PROF_ATSAUCE = ats_1
                where a.darb_ID = darb_ID.darb_ID;                      
        END LOOP;
END;

select vards, deref(prof_atsauce).profesija from darbinieki_B;

--100%
select d.darb_ID, d.vards, d.uzvards, d.e_pasts, d.prof_id, deref(d.PROF_ATSAUCE).prof_ID,
    deref(d.PROF_ATSAUCE).profesija, deref(d.PROF_ATSAUCE).nodarbinatiba,deref(d.PROF_ATSAUCE).alga
    from darbinieki_B d;
    
--7% 
select d.darb_ID, d.vards, d.uzvards, d.e_pasts, d.prof_id, deref(d.PROF_ATSAUCE).prof_ID,
    deref(d.PROF_ATSAUCE).profesija, deref(d.PROF_ATSAUCE).nodarbinatiba,deref(d.PROF_ATSAUCE).alga
    from darbinieki_B d
    where d.dzimums = 'Vîrietis' and  deref(d.PROF_ATSAUCE).nodarbinatiba = 'Daily';
    
--1%
select d.darb_ID, d.vards, d.uzvards, d.e_pasts, d.prof_id, deref(d.PROF_ATSAUCE).prof_ID,
    deref(d.PROF_ATSAUCE).profesija, deref(d.PROF_ATSAUCE).nodarbinatiba,deref(d.PROF_ATSAUCE).alga
    from darbinieki_B d
    where deref(d.PROF_ATSAUCE).profesija = 'Paramedic' or  deref(d.PROF_ATSAUCE).profesija ='Doctor';

--0.01%
select d.darb_ID, d.vards, d.uzvards, d.e_pasts, d.prof_id, deref(d.PROF_ATSAUCE).prof_ID,
    deref(d.PROF_ATSAUCE).profesija, deref(d.PROF_ATSAUCE).nodarbinatiba,deref(d.PROF_ATSAUCE).alga
    from darbinieki_B d
    where d.vards = 'Amy' and d.uzvards = 'Pierce';  