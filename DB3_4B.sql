insert  into darbinieki_a
    select * from darbinieki where rownum <=70000;
    
insert  into darbinieki_a
    select * from darbinieki where darb_ID between 970001 and 1000000;


CREATE INDEX darb_iA
ON Darbinieki_A(PROF_ID);

drop index darb_iA;

CREATE INDEX prof_iA
ON Profesijas_A(PROF_ID);

drop index prof_iA;

--100%
select *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID;
    
select /*+ index(p prof_iA) */ *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID;
    
select /*+ index(d darb_iA) */ *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID;

select /*+ index(p prof_iA) index(d darb_iA)*/ *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID;
    
--7%
select *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID and p.nodarbinatiba = 'Daily' and d.dzimums = 'Vîrietis';
    
select /*+ index(p prof_iA) */ *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID and p.nodarbinatiba = 'Daily' and d.dzimums = 'Vîrietis';
    
select /*+ index(p prof_iA) */ *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID and p.nodarbinatiba = 'Daily' and d.dzimums = 'Vîrietis';
    
select /*+ index(p prof_iA) index(d darb_iA)*/ *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID and p.nodarbinatiba = 'Daily' and d.dzimums = 'Vîrietis';

--1%    
select  *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID and (p.profesija = 'Paramedic' or  p.profesija ='Doctor');
    
select /*+ index(p prof_iA) */ *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID and (p.profesija = 'Paramedic' or  p.profesija ='Doctor'); 
    
select /*+ index(d darb_iA) */ *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID and (p.profesija = 'Paramedic' or  p.profesija ='Doctor'); 
    
select /*+ index(p prof_iA) index(d darb_iA)*/ *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID and (p.profesija = 'Paramedic' or  p.profesija ='Doctor'); 
    
--0.01%
select *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID and d.vards = 'Amy' and d.uzvards = 'Pierce';
    
select /*+ index(p prof_iA) */ *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID and d.vards = 'Amy' and d.uzvards = 'Pierce';
    
select /*+ index(d darb_iA) */ *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID and d.vards = 'Amy' and d.uzvards = 'Pierce';
    
select /*+ index(p prof_iA) index(d darb_iA)*/ *
    from darbinieki_a d, profesijas_a p
    where d.prof_id = p.prof_ID and d.vards = 'Amy' and d.uzvards = 'Pierce';
