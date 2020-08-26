create or replace type C_DARBINIEKS_TIPS as object(
    DARB_ID number, 
	VARDS varchar2(25), 
	UZVARDS varchar2(25), 
	E_PASTS varchar2(50), 
	PROF_ID number, 
	DZIMUMS varchar2(15)
    );
    
create or replace type  C_DARBINIEKS as table of   C_DARBINIEKS_TIPS;     
    
create or replace type C_PROFESIJA_TIPS as object (
    PROF_ID number(4), 
	PROFESIJA varchar2(100), 
	NODARBINATIBA varchar2(10), 
	ALGA float(2)
    );
    
create table C_Profesijas(
    Profesija         C_PROFESIJA_TIPS,
    Darbinieki        C_DARBINIEKS)
    nested table Darbinieki  store as C_IEK_TAB; 
    
DECLARE
    cursor Profesijas_KUR is
        SELECT A.Prof_ID,A.Profesija,A.Nodarbinatiba,A.Alga
        FROM Profesijas A;
BEGIN    
    FOR Prof_ID in Profesijas_KUR
    LOOP   
        INSERT INTO C_Profesijas values( 
        C_PROFESIJA_TIPS(Prof_ID.Prof_ID,Prof_ID.Profesija,Prof_ID.Nodarbinatiba,Prof_ID.Alga),
        C_DARBINIEKS(C_DARBINIEKS_TIPS(1,'a','a','a',0,'a')));
    END LOOP;
END;

DECLARE
    cursor Darbinieki_KUR is
        SELECT A.Darb_ID,A.Vards,A.Uzvards,A.E_Pasts,A.Prof_ID,A.Dzimums
        FROM Darbinieki A
        where rownum <= 100000;
    BEGIN    
        FOR Darb_ID in Darbinieki_KUR
        LOOP   
                insert into TABLE(
                select A.Darbinieki
                    from  C_Profesijas A
                    where A.Profesija.Prof_ID = Darb_ID.Prof_ID)
                    values (C_DARBINIEKS_TIPS(Darb_ID.Darb_ID,Darb_ID.Vards,Darb_ID.Uzvards,Darb_ID.E_Pasts,Darb_ID.Prof_ID,Darb_ID.Dzimums));
        END LOOP;
END;

--izdzes liekos ierakstus
DECLARE
    COUNTER         Number NOT NULL:= 1;
begin
    :COUNTER := 1;    
    Select Count(*) into :Prof
        from C_Profesijas;
    While :COUNTER <= 242
    loop                
        DELETE FROM Table(
            SELECT Darbinieki FROM C_Profesijas c WHERE c.profesija.prof_ID = :COUNTER
            ) addr
            WHERE
                VALUE(addr) = C_Darbinieks_Tips(
                    1,'a','a','a',0,'a'
                );
        :COUNTER := :COUNTER + 1;
    end loop;
end;  


--100%
select value(d).Darb_ID as Darb_ID, value(d).Vards as Vards, value(d).Uzvards as Uzvards, value(d).e_pasts as e_pasts, 
       value(d).prof_ID as prof_ID, value(d).dzimums as dzimums,
       c.profesija.prof_ID as prof_ID , c.profesija.profesija as profesija, c.profesija.nodarbinatiba as nodarbinatiba, c.profesija.alga as alga
    from C_Profesijas c, Table(C.Darbinieki) d;
   
  
--7%    
select value(d).Darb_ID as Darb_ID, value(d).Vards as Vards, value(d).Uzvards as Uzvards, value(d).e_pasts as e_pasts, 
       value(d).prof_ID as prof_ID, value(d).dzimums as dzimums,
       c.profesija.prof_ID as prof_ID , c.profesija.profesija as profesija, c.profesija.nodarbinatiba as nodarbinatiba, c.profesija.alga as alga
    from C_Profesijas c, Table(C.Darbinieki) d
    where c.profesija.alga <= 600;

--1%    
select value(d).Darb_ID as Darb_ID, value(d).Vards as Vards, value(d).Uzvards as Uzvards, value(d).e_pasts as e_pasts, 
       value(d).prof_ID as prof_ID, value(d).dzimums as dzimums,
       c.profesija.prof_ID as prof_ID , c.profesija.profesija as profesija, c.profesija.nodarbinatiba as nodarbinatiba, c.profesija.alga as alga
    from C_Profesijas c, Table(C.Darbinieki) d
    where c.profesija.profesija like 'Developer%' and
          d.dzimums = 'Vîrietis';
  
--0.1%   
select value(d).Darb_ID as Darb_ID, value(d).Vards as Vards, value(d).Uzvards as Uzvards, value(d).e_pasts as e_pasts, 
       value(d).prof_ID as prof_ID, value(d).dzimums as dzimums,
       c.profesija.prof_ID as prof_ID , c.profesija.profesija as profesija, c.profesija.nodarbinatiba as nodarbinatiba, c.profesija.alga as alga
    from C_Profesijas c, Table(C.Darbinieki) d
    where d.uzvards = 'Adler';