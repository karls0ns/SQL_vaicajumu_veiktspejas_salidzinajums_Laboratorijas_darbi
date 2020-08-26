CREATE INDEX darb_i
ON A_Darbinieki(PROF_ID);

drop index darb_i;

CREATE INDEX prof_i
ON A_Profesijas(PROF_ID);

drop index prof_i;
    

-- 100%
select *
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id;

select /*+ index(p prof_i) */ *
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id;
    
select /*+ index(d darb_i) */ *
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id;
    
select /*+ index(p prof_i) index(d darb_i) */ *
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id;

-- 7%
Select *
    from A_darbinieki d , A_profesijas p 
    where p.prof_id = d.prof_id and 
          p.alga <= 600;
          
select /*+ index(p prof_i) */ *
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id;
    
select /*+ index(d darb_i) */ *
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id;

select /*+ index(p prof_i) index(d darb_i) */ *
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id;
    
-- 1%         
select *
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id and
          p.profesija like 'Developer%' and
          d.dzimums = 'Vîrietis';
          
select /*+ index(p prof_i) */ *
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id and
          p.profesija like 'Developer%' and
          d.dzimums = 'Vîrietis';
          
select /*+ index(d darb_i) */ *
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id and
          p.profesija like 'Developer%' and
          d.dzimums = 'Vîrietis';
          
select /*+ index(p prof_i) index(d darb_i) */ *
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id and
          p.profesija like 'Developer%' and
          d.dzimums = 'Vîrietis';
          
-- 0.1%
select * 
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id and           
          d.uzvards = 'Adler';
          
select /*+ index(p prof_i) */ * 
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id and           
          d.uzvards = 'Adler'; 
          
select /*+ index(d darb_i) */ * 
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id and           
          d.uzvards = 'Adler';

select /*+ index(p prof_i) index(d darb_i) */ * 
    from A_profesijas p, A_darbinieki d
    where p.prof_id = d.prof_id and           
          d.uzvards = 'Adler';
          