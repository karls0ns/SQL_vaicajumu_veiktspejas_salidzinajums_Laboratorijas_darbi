insert  into darbinieki_1
    select * from darbinieki where rownum <=70000;
    
insert  into darbinieki_1
    select * from darbinieki where darb_ID between 970001 and 1000000;

insert  into profesijas_1
    select * from A_profesijas;

CREATE INDEX darb_i1
ON Darbinieki_1(PROF_ID);

CREATE INDEX prof_i1
ON Profesijas_1(PROF_ID);

drop index darb_i1;
drop index prof_i1;

--------------------------------------------------100%-------------------------------------------------------------------------
select *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID;
    
    
select /*+ index(p prof_i1) */ *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID;
    
select /*+ index(d darb_i1) */ *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID;

select /*+ index(p prof_i1) index(d darb_i1)*/ *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID;
    

------------------------------------------100 ieraksti------------------------------------------------------------------
select *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID and  
          d.uzvards = 'Ross' and
          d.dzimums = 'Sieviete';
          
select /*+ index(p prof_i1) */ *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID and  
          d.uzvards = 'Ross' and
          d.dzimums = 'Sieviete';
          
select /*+ index(d darb_i1) */ *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID and  
          d.uzvards = 'Ross' and
          d.dzimums = 'Sieviete';

select /*+ index(p prof_i1) index(d darb_i1)*/ *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID and  
          d.uzvards = 'Ross' and
          d.dzimums = 'Sieviete';

-------------------------------------------10 ieraksti------------------------------------------------------------------
select *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID and  
          p.nodarbinatiba = 'Never' and 
          d.e_pasts like '%@eirey.tech' and 
          p.alga < 500;

select /*+ index(p prof_i1) */ *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID and  
          p.nodarbinatiba = 'Never' and 
          d.e_pasts like '%@eirey.tech' and 
          p.alga < 500;

select /*+ index(d darb_i1) */ *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID and  
          p.nodarbinatiba = 'Never' and 
          d.e_pasts like '%@eirey.tech' and 
          p.alga < 500;

select /*+ index(p prof_i1) index(d darb_i1)*/ *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID and  
          p.nodarbinatiba = 'Never' and 
          d.e_pasts like '%@eirey.tech' and 
          p.alga < 500;
    
--------------------------------------------------1 ieraksts------------------------------------------------------------------
CREATE INDEX darb_i1
ON Darbinieki_1(PROF_ID);

CREATE INDEX prof_i1
ON Profesijas_1(PROF_ID);

drop index darb_i1;
drop index prof_i1;

select *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID and d.vards = 'Amy' and d.uzvards = 'Pierce';
    
select /*+ index(p prof_i1) */ *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID and d.vards = 'Amy' and d.uzvards = 'Pierce';
    
select /*+ index(d darb_i1) */ *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID and d.vards = 'Amy' and d.uzvards = 'Pierce';
    
select /*+ index(p prof_i1) index(d darb_i1)*/ *
    from darbinieki_1 d, profesijas_1 p
    where d.prof_id = p.prof_ID and d.vards = 'Amy' and d.uzvards = 'Pierce';
