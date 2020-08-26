--Tabula darbinieki
create or replace type B_DARBINIEKS_TIPS as object(
    DARB_ID number, 
	VARDS varchar2(25), 
	UZVARDS varchar2(25), 
	E_PASTS varchar2(50), 
	PROF_ID number, 
	DZIMUMS varchar2(15)
    );

create table B_Darbinieki of B_DARBINIEKS_TIPS;

insert into B_DARBINIEKI
    select * from darbinieki where rownum <=100000;


-- Atsaucu tabula    
create or replace type B_Atsauce as object(
    A_ID number,
    A_Darbinieks ref B_DARBINIEKS_TIPS
    );
    
create or replace type B_Atsauces as table of B_Atsauce;

create or replace type B_E_Atsauces as object(
    B_ELEM_ATSAUCES B_Atsauces);
    
create table B_TAB_ATSAUCES of B_E_Atsauces
    nested table B_ELEM_ATSAUCES store as B_IEK_TAB;

--Profesiju tabula
create or replace type B_PROFESIJA_TIPS as object (
    PROF_ID number(4), 
	PROFESIJA varchar2(100), 
	NODARBINATIBA varchar2(10), 
	ALGA float(2),
    PROF_ATSAUCE ref B_E_Atsauces
    );
    
create table B_PROFESIJAS of B_PROFESIJA_TIPS;

insert into B_PROFESIJAS
    (PROF_ID,PROFESIJA,NODARBINATIBA,ALGA)
    select PROF_ID,PROFESIJA,NODARBINATIBA,ALGA from PROFESIJAS;
    

-- ATSAUCE uz atsuacu tabulu   
DECLARE
    COUNTER         Number NOT NULL:= 1;
    Nid             Number NOT NULL:= -1;    
    ats_1		REF B_E_atsauces;
    cursor PROFESIJAS_KUR is
        SELECT B.PROF_ID
        FROM B_PROFESIJAS B;
BEGIN
    :COUNTER := 1;    
    FOR PROF_ID in PROFESIJAS_KUR
    LOOP   
        SELECT B.PROF_ID into :Nid
            FROM B_PROFESIJAS B
            WHERE B.PROF_ID =:COUNTER;      
        insert into B_TAB_ATSAUCES values (B_E_atsauces(B_Atsauces(B_Atsauce(:Nid, NULL))));        
        select REF(a) into ats_1
            from B_TAB_ATSAUCES a, TABLE(a.B_ELEM_ATSAUCES) b
            where b.A_ID = :Nid;
        update B_PROFESIJAS a set a.PROF_ATSAUCE = ats_1
            WHERE  a.PROF_ID = :Nid;            
        :COUNTER := :COUNTER + 1;
   END LOOP;
END;


-- Atsauces uz darbiniekiem
DECLARE      
    Pid             Number NOT NULL:= -1;                   
    ViensIerakts    Number NOT NULL:= -1;
    PievSkait       Number NOT NULL:= -1;    
    ViensAtrasts    Number NOT NULL:= -1;
    Pid1            Number NOT NULL:= -1;                 
    ats_1       REF  B_DARBINIEKS_TIPS;    
    cursor DARBINIEKI_KUR is
        SELECT A.DARB_ID
        FROM B_DARBINIEKI A;
BEGIN    
    Select Count(*) into :ViensIerakts
        from(
            Select REF(a)
                from B_TAB_ATSAUCES a
            );            
    :PievSkait := :ViensIerakts + 1;
	FOR DARB_ID in DARBINIEKI_KUR
		LOOP
			SELECT A.PROF_ID into :Pid
				FROM B_DARBINIEKI A
				WHERE A.DARB_ID = Darb_ID.Darb_ID;       
			Select Count (*) into :ViensAtrasts
				from( 
					Select REF(a) 
						from B_TAB_ATSAUCES a, TABLE(a.B_ELEM_ATSAUCES) b
						where b.A_ID = :Pid and
							  b.A_Darbinieks is null
					);                    
            IF :ViensAtrasts = 1 then            
                select REF(a) into ats_1
                    from B_DARBINIEKI a
                    where a.DARB_ID = darb_ID.darb_ID;
                update  TABLE(select  a.B_ELEM_ATSAUCES from B_TAB_ATSAUCES a, TABLE(a.B_ELEM_ATSAUCES) b
                    WHERE  b.A_ID = :Pid) c
                    set c.A_Darbinieks = ats_1
                    where c.A_ID = :Pid;                
            ELSE
                 :Pid1 := :Pid + :PievSkait;
                insert into TABLE(
                    select a.B_ELEM_ATSAUCES
                        from  B_TAB_ATSAUCES a, TABLE(a.B_ELEM_ATSAUCES) b
                        where  b.A_ID = :Pid)
                        values (B_Atsauce(:PievSkait, NULL));                    
                select REF(a) into ats_1
                    from B_DARBINIEKI a
                    where a.DARB_ID = DARB_ID.DARB_ID;
                update  TABLE(select  a.B_ELEM_ATSAUCES from B_TAB_ATSAUCES a, TABLE(a.B_ELEM_ATSAUCES) b
                    WHERE  b.A_ID = :PievSkait) c
                    set c.A_Darbinieks = ats_1
                    where c.A_ID = :PievSkait;                
                :PievSkait := :PievSkait + 1;
            end if;            
    END LOOP;
END;

select Value(c).A_ID, Value(c).A_DARBINIEKS.VARDS, Value(c).A_DARBINIEKS.UZVARDS
    from TABLE
        (select DEREF(a.PROF_ATSAUCE).B_ELEM_ATSAUCES b
            from B_PROFESIJAS a
            where a.PROF_ID = 150) c;    
        
--100%
select D.Prof_ID, D.Profesija, D.Nodarbinatiba, D.Alga, 
        Value(c).A_Darbinieks.Darb_ID, Value(c).A_Darbinieks.Vards, Value(c).A_Darbinieks.Uzvards, Value(c).A_Darbinieks.E_Pasts, 
        Value(c).A_Darbinieks.Prof_ID, value(c).A_Darbinieks.Dzimums  
        from B_Profesijas D, Table(
        select DEREF(a.PROF_ATSAUCE).B_ELEM_ATSAUCES b
        from B_Profesijas a
        where a.prof_ID = D.prof_ID)c;
        
--7%
select D.Prof_ID, D.Profesija, D.Nodarbinatiba, D.Alga, 
        Value(c).A_Darbinieks.Darb_ID, Value(c).A_Darbinieks.Vards, Value(c).A_Darbinieks.Uzvards, Value(c).A_Darbinieks.E_Pasts, 
        Value(c).A_Darbinieks.Prof_ID, value(c).A_Darbinieks.Dzimums  
        from B_Profesijas D, Table(
        select DEREF(a.PROF_ATSAUCE).B_ELEM_ATSAUCES b
        from B_Profesijas a
        where a.prof_ID = D.prof_ID)c
        where d.alga <= 600;
        
--1%
select D.Prof_ID, D.Profesija, D.Nodarbinatiba, D.Alga, 
        Value(c).A_Darbinieks.Darb_ID, Value(c).A_Darbinieks.Vards, Value(c).A_Darbinieks.Uzvards, Value(c).A_Darbinieks.E_Pasts, 
        Value(c).A_Darbinieks.Prof_ID, value(c).A_Darbinieks.Dzimums  
        from B_Profesijas D, Table(
        select DEREF(a.PROF_ATSAUCE).B_ELEM_ATSAUCES b
        from B_Profesijas a
        where a.prof_ID = D.prof_ID)c
        where D.profesija like 'Developer%' and
              c.A_Darbinieks.dzimums = 'Vîrietis';
--0.01%              
select D.Prof_ID, D.Profesija, D.Nodarbinatiba, D.Alga, 
        Value(c).A_Darbinieks.Darb_ID, Value(c).A_Darbinieks.Vards, Value(c).A_Darbinieks.Uzvards, Value(c).A_Darbinieks.E_Pasts, 
        Value(c).A_Darbinieks.Prof_ID, value(c).A_Darbinieks.Dzimums  
        from B_Profesijas D, Table(
        select DEREF(a.PROF_ATSAUCE).B_ELEM_ATSAUCES b
        from B_Profesijas a
        where a.prof_ID = D.prof_ID)c
        where c.A_Darbinieks.uzvards = 'Adler';  
      

  