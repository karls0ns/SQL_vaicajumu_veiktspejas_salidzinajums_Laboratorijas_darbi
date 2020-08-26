create or replace type DARBINIEKS_TIPS_2 as object(
    DARB_ID number, 
	VARDS varchar2(25), 
	UZVARDS varchar2(25), 
	E_PASTS varchar2(50), 
	PROF_ID number, 
	DZIMUMS varchar2(15)
    );
    
create or replace type  DARBINIEKS_2 as table of   DARBINIEKS_TIPS_2;     
       
create table Profesijas_2(
    PROF_ID number(4), 
	PROFESIJA varchar2(100), 
	NODARBINATIBA varchar2(10), 
	ALGA float(2),
    Darbinieki DARBINIEKS_2)
    nested table Darbinieki  store as IEK_TAB_2; 
    
DECLARE
    cursor Profesijas_KUR is
        SELECT A.Prof_ID,A.Profesija,A.Nodarbinatiba,A.Alga
        FROM Profesijas_1 A;
BEGIN    
    FOR Prof_ID in Profesijas_KUR
    LOOP   
        INSERT INTO Profesijas_2 values( 
        Prof_ID.Prof_ID,Prof_ID.Profesija,Prof_ID.Nodarbinatiba,Prof_ID.Alga,
        DARBINIEKS_2(DARBINIEKS_TIPS_2(1,'a','a','a',0,'a')));
    END LOOP;
END;

DECLARE
    cursor Darbinieki_KUR is
        SELECT A.Darb_ID,A.Vards,A.Uzvards,A.E_Pasts,A.Prof_ID,A.Dzimums
        FROM Darbinieki_1 A;
    BEGIN    
        FOR Darb_ID in Darbinieki_KUR
        LOOP   
                insert into TABLE(
                select A.Darbinieki
                    from  Profesijas_2 A
                    where A.Prof_ID = Darb_ID.Prof_ID)
                    values (DARBINIEKS_TIPS_2(Darb_ID.Darb_ID,Darb_ID.Vards,Darb_ID.Uzvards,Darb_ID.E_Pasts,Darb_ID.Prof_ID,Darb_ID.Dzimums));
        END LOOP;
END;

--izdzes liekos ierakstus
DECLARE
    COUNTER         Number NOT NULL:= 1;
begin
    :COUNTER := 1;    
    Select Count(*) into :Prof
        from Profesijas_2;
    While :COUNTER <= 242
    loop                
        DELETE FROM Table(
            SELECT Darbinieki FROM Profesijas_2 c WHERE c.prof_ID = :COUNTER
            ) addr
            WHERE
                VALUE(addr) = Darbinieks_Tips_2(
                    1,'a','a','a',0,'a'
                );
        :COUNTER := :COUNTER + 1;
    end loop;
end; 


CREATE INDEX prof_i2
ON Profesijas_2(PROF_ID);

drop index prof_i2;

--------------------------------------------------100%-------------------------------------------------------------------------
select value(d).Darb_ID, value(d).Vards, value(d).Uzvards, value(d).e_pasts, value(d).prof_ID, value(d).dzimums,
       p.prof_ID, p.profesija, p.nodarbinatiba, p.alga
    from Profesijas_2 p, Table(p.Darbinieki) d;
    
select /*+ index(p prof_i2) */ value(d).Darb_ID, value(d).Vards, value(d).Uzvards, value(d).e_pasts, value(d).prof_ID, value(d).dzimums,
       p.prof_ID, p.profesija, p.nodarbinatiba, p.alga
    from Profesijas_2 p, Table(p.Darbinieki) d;
    
------------------------------------------100 ieraksti------------------------------------------------------------------
select value(d).Darb_ID, value(d).Vards, value(d).Uzvards, value(d).e_pasts, value(d).prof_ID, value(d).dzimums,
       p.prof_ID, p.profesija, p.nodarbinatiba, p.alga
    from Profesijas_2 p, Table(p.Darbinieki) d
    where d.uzvards = 'Ross' and
          d.dzimums = 'Sieviete';
          
select /*+ index(p prof_i2) */ value(d).Darb_ID, value(d).Vards, value(d).Uzvards, value(d).e_pasts, value(d).prof_ID, value(d).dzimums,
       p.prof_ID, p.profesija, p.nodarbinatiba, p.alga
    from Profesijas_2 p, Table(p.Darbinieki) d
    where d.uzvards = 'Ross' and
          d.dzimums = 'Sieviete';
          
-------------------------------------------10 ieraksti------------------------------------------------------------------
select value(d).Darb_ID, value(d).Vards, value(d).Uzvards, value(d).e_pasts, value(d).prof_ID, value(d).dzimums,
       p.prof_ID, p.profesija, p.nodarbinatiba, p.alga
    from Profesijas_2 p, Table(p.Darbinieki) d
    where p.nodarbinatiba = 'Never' and 
          d.e_pasts like '%@eirey.tech' and 
          p.alga < 500;
          
select /*+ index(p prof_i2) */ value(d).Darb_ID, value(d).Vards, value(d).Uzvards, value(d).e_pasts, value(d).prof_ID, value(d).dzimums,
       p.prof_ID, p.profesija, p.nodarbinatiba, p.alga
    from Profesijas_2 p, Table(p.Darbinieki) d
    where p.nodarbinatiba = 'Never' and 
          d.e_pasts like '%@eirey.tech' and 
          p.alga < 500;
          
--------------------------------------------------1 ieraksts------------------------------------------------------------------
select value(d).Darb_ID, value(d).Vards, value(d).Uzvards, value(d).e_pasts, value(d).prof_ID, value(d).dzimums,
       p.prof_ID, p.profesija, p.nodarbinatiba, p.alga
    from Profesijas_2 p, Table(p.Darbinieki) d
    where d.vards = 'Amy' and d.uzvards = 'Pierce';
    
select /*+ index(p prof_i2) */ value(d).Darb_ID, value(d).Vards, value(d).Uzvards, value(d).e_pasts, value(d).prof_ID, value(d).dzimums,
       p.prof_ID, p.profesija, p.nodarbinatiba, p.alga
    from Profesijas_2 p, Table(p.Darbinieki) d
    where d.vards = 'Amy' and d.uzvards = 'Pierce';
    