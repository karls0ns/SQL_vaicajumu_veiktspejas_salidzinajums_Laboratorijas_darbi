--Tabula darbinieki
create or replace type DARBINIEKS_TIPS_3 as object(
    DARB_ID number, 
	VARDS varchar2(25), 
	UZVARDS varchar2(25), 
	E_PASTS varchar2(50), 
	PROF_ID number, 
	DZIMUMS varchar2(15)
    );

create table Darbinieki_3 of DARBINIEKS_TIPS_3;

insert into Darbinieki_3
    select * from darbinieki_1;


-- Atsaucu tabula    
create or replace type Atsauce_3 as object(
    A_ID number,
    A_Darbinieks ref DARBINIEKS_TIPS_3
    );
    
create or replace type Atsauces_3 as table of Atsauce_3;

create or replace type E_Atsauces_3 as object(
    ELEM_ATSAUCES_3 Atsauces_3);
    
create table TAB_ATSAUCES_3 of E_Atsauces_3
    nested table ELEM_ATSAUCES_3 store as IEK_TAB_3;

--Profesiju tabula
create or replace type PROFESIJA_TIPS_3 as object (
    PROF_ID number(4), 
	PROFESIJA varchar2(100), 
	NODARBINATIBA varchar2(10), 
	ALGA float(2),
    PROF_ATSAUCE ref E_Atsauces_3
    );
    
create table PROFESIJAS_3 of PROFESIJA_TIPS_3;

insert into PROFESIJAS_3
    (PROF_ID,PROFESIJA,NODARBINATIBA,ALGA)
    select PROF_ID,PROFESIJA,NODARBINATIBA,ALGA from PROFESIJAS_1;
    

-- ATSAUCE uz atsuacu tabulu   
DECLARE
    COUNTER         Number NOT NULL:= 1;
    Nid             Number NOT NULL:= -1;    
    ats_1		REF E_Atsauces_3;
    cursor PROFESIJAS_KUR is
        SELECT B.PROF_ID
        FROM PROFESIJAS_3 B;
BEGIN
    :COUNTER := 1;    
    FOR PROF_ID in PROFESIJAS_KUR
    LOOP   
        SELECT B.PROF_ID into :Nid
            FROM PROFESIJAS_3 B
            WHERE B.PROF_ID =:COUNTER;      
        insert into TAB_ATSAUCES_3 values (E_Atsauces_3(Atsauces_3(Atsauce_3(:Nid, NULL))));        
        select REF(a) into ats_1
            from TAB_ATSAUCES_3 a, TABLE(a.ELEM_ATSAUCES_3) b
            where b.A_ID = :Nid;
        update PROFESIJAS_3 a set a.PROF_ATSAUCE = ats_1
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
    ats_1       REF  DARBINIEKS_TIPS_3;    
    cursor DARBINIEKI_KUR is
        SELECT A.DARB_ID
        FROM Darbinieki_3 A;
BEGIN    
    Select Count(*) into :ViensIerakts
        from(
            Select REF(a)
                from TAB_ATSAUCES_3 a
            );            
    :PievSkait := :ViensIerakts + 1;
	FOR DARB_ID in DARBINIEKI_KUR
		LOOP
			SELECT A.PROF_ID into :Pid
				FROM Darbinieki_3 A
				WHERE A.DARB_ID = Darb_ID.Darb_ID;       
			Select Count (*) into :ViensAtrasts
				from( 
					Select REF(a) 
						from TAB_ATSAUCES_3 a, TABLE(a.ELEM_ATSAUCES_3) b
						where b.A_ID = :Pid and
							  b.A_Darbinieks is null
					);                    
            IF :ViensAtrasts = 1 then            
                select REF(a) into ats_1
                    from Darbinieki_3 a
                    where a.DARB_ID = darb_ID.darb_ID;
                update  TABLE(select  a.ELEM_ATSAUCES_3 from TAB_ATSAUCES_3 a, TABLE(a.ELEM_ATSAUCES_3) b
                    WHERE  b.A_ID = :Pid) c
                    set c.A_Darbinieks = ats_1
                    where c.A_ID = :Pid;                
            ELSE
                 :Pid1 := :Pid + :PievSkait;
                insert into TABLE(
                    select a.ELEM_ATSAUCES_3
                        from  TAB_ATSAUCES_3 a, TABLE(a.ELEM_ATSAUCES_3) b
                        where  b.A_ID = :Pid)
                        values (Atsauce_3(:PievSkait, NULL));                    
                select REF(a) into ats_1
                    from Darbinieki_3 a
                    where a.DARB_ID = DARB_ID.DARB_ID;
                update  TABLE(select  a.ELEM_ATSAUCES_3 from TAB_ATSAUCES_3 a, TABLE(a.ELEM_ATSAUCES_3) b
                    WHERE  b.A_ID = :PievSkait) c
                    set c.A_Darbinieks = ats_1
                    where c.A_ID = :PievSkait;                
                :PievSkait := :PievSkait + 1;
            end if;            
    END LOOP;
END;

select Value(c).A_ID, Value(c).A_DARBINIEKS.VARDS, Value(c).A_DARBINIEKS.UZVARDS
    from TABLE
        (select DEREF(a.PROF_ATSAUCE).ELEM_ATSAUCES_3 b
            from PROFESIJAS_3 a
            where a.PROF_ID = 1) c;    

select * from profesijas_3;

CREATE INDEX prof_i3
ON Profesijas_3(PROF_ID);

drop index prof_i3;

--------------------------------------------------100%-------------------------------------------------------------------------            
select D.Prof_ID, D.Profesija, D.Nodarbinatiba, D.Alga, 
        Value(c).A_Darbinieks.Darb_ID, Value(c).A_Darbinieks.Vards, Value(c).A_Darbinieks.Uzvards, Value(c).A_Darbinieks.E_Pasts, 
        Value(c).A_Darbinieks.Prof_ID, value(c).A_Darbinieks.Dzimums  
        from Profesijas_3 D, Table(
        select DEREF(a.PROF_ATSAUCE).ELEM_ATSAUCES_3 b
        from Profesijas_3 a
        where a.prof_ID = D.prof_ID)c;    
        
select /*+ index(a prof_i3) */ D.Prof_ID, D.Profesija, D.Nodarbinatiba, D.Alga, 
        Value(c).A_Darbinieks.Darb_ID, Value(c).A_Darbinieks.Vards, Value(c).A_Darbinieks.Uzvards, Value(c).A_Darbinieks.E_Pasts, 
        Value(c).A_Darbinieks.Prof_ID, value(c).A_Darbinieks.Dzimums  
        from Profesijas_3 D, Table(
        select DEREF(a.PROF_ATSAUCE).ELEM_ATSAUCES_3 b
        from Profesijas_3 a
        where a.prof_ID = D.prof_ID)c;
        
------------------------------------------100 ieraksti------------------------------------------------------------------
CREATE INDEX prof_i3
ON Profesijas_3(PROF_ID);

drop index prof_i3;

select D.Prof_ID, D.Profesija, D.Nodarbinatiba, D.Alga, 
        Value(c).A_Darbinieks.Darb_ID, Value(c).A_Darbinieks.Vards, Value(c).A_Darbinieks.Uzvards, Value(c).A_Darbinieks.E_Pasts, 
        Value(c).A_Darbinieks.Prof_ID, value(c).A_Darbinieks.Dzimums    
        from Profesijas_3 D, Table(
        select DEREF(a.PROF_ATSAUCE).ELEM_ATSAUCES_3 b
            from Profesijas_3 a
            where a.prof_ID = D.prof_ID)c
        where c.A_Darbinieks.uzvards = 'Ross' and
              c.A_Darbinieks.dzimums = 'Sieviete';
              
select /*+ index(a prof_i3) */ D.Prof_ID, D.Profesija, D.Nodarbinatiba, D.Alga, 
        Value(c).A_Darbinieks.Darb_ID, Value(c).A_Darbinieks.Vards, Value(c).A_Darbinieks.Uzvards, Value(c).A_Darbinieks.E_Pasts, 
        Value(c).A_Darbinieks.Prof_ID, value(c).A_Darbinieks.Dzimums    
        from Profesijas_3 D, Table(
        select DEREF(a.PROF_ATSAUCE).ELEM_ATSAUCES_3 b
            from Profesijas_3 a
            where a.prof_ID = D.prof_ID)c
        where c.A_Darbinieks.uzvards = 'Ross' and
              c.A_Darbinieks.dzimums = 'Sieviete';
-------------------------------------------10 ieraksti------------------------------------------------------------------
CREATE INDEX prof_i3
ON Profesijas_3(PROF_ID);

drop index prof_i3;

select D.Prof_ID, D.Profesija, D.Nodarbinatiba, D.Alga, 
        Value(c).A_Darbinieks.Darb_ID, Value(c).A_Darbinieks.Vards, Value(c).A_Darbinieks.Uzvards, Value(c).A_Darbinieks.E_Pasts, 
        Value(c).A_Darbinieks.Prof_ID, value(c).A_Darbinieks.Dzimums    
        from Profesijas_3 D, Table(
        select DEREF(a.PROF_ATSAUCE).ELEM_ATSAUCES_3 b
            from Profesijas_3 a
            where a.prof_ID = D.prof_ID)c
        where d.nodarbinatiba = 'Never' and 
              c.A_Darbinieks.e_pasts like '%@eirey.tech' and 
              d.alga < 500;
              
select /*+ index(a prof_i3) */ D.Prof_ID, D.Profesija, D.Nodarbinatiba, D.Alga, 
        Value(c).A_Darbinieks.Darb_ID, Value(c).A_Darbinieks.Vards, Value(c).A_Darbinieks.Uzvards, Value(c).A_Darbinieks.E_Pasts, 
        Value(c).A_Darbinieks.Prof_ID, value(c).A_Darbinieks.Dzimums    
        from Profesijas_3 D, Table(
        select DEREF(a.PROF_ATSAUCE).ELEM_ATSAUCES_3 b
            from Profesijas_3 a
            where a.prof_ID = D.prof_ID)c
        where d.nodarbinatiba = 'Never' and 
              c.A_Darbinieks.e_pasts like '%@eirey.tech' and 
              d.alga < 500;
          
--------------------------------------------------1 ieraksts------------------------------------------------------------------
CREATE INDEX prof_i3
ON Profesijas_3(PROF_ID);

drop index prof_i3;

select D.Prof_ID, D.Profesija, D.Nodarbinatiba, D.Alga, 
        Value(c).A_Darbinieks.Darb_ID, Value(c).A_Darbinieks.Vards, Value(c).A_Darbinieks.Uzvards, Value(c).A_Darbinieks.E_Pasts, 
        Value(c).A_Darbinieks.Prof_ID, value(c).A_Darbinieks.Dzimums    
        from Profesijas_3 D, Table(
        select DEREF(a.PROF_ATSAUCE).ELEM_ATSAUCES_3 b
            from Profesijas_3 a
            where a.prof_ID = D.prof_ID)c
        where c.A_Darbinieks.vards = 'Amy' and c.A_Darbinieks.uzvards = 'Pierce';
        
select /*+ index(a prof_i3) */ D.Prof_ID, D.Profesija, D.Nodarbinatiba, D.Alga, 
        Value(c).A_Darbinieks.Darb_ID, Value(c).A_Darbinieks.Vards, Value(c).A_Darbinieks.Uzvards, Value(c).A_Darbinieks.E_Pasts, 
        Value(c).A_Darbinieks.Prof_ID, value(c).A_Darbinieks.Dzimums    
        from Profesijas_3 D, Table(
        select DEREF(a.PROF_ATSAUCE).ELEM_ATSAUCES_3 b
            from Profesijas_3 a
            where a.prof_ID = D.prof_ID)c
        where c.A_Darbinieks.vards = 'Amy' and c.A_Darbinieks.uzvards = 'Pierce';