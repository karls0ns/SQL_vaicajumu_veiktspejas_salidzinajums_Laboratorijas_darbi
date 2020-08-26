select /*+USE_NL(p d) +*/
    d.vards, d.uzvards, d.e_pasts, p.profesija, p.nodarbinatiba, p.alga 
    from darbinieki d, profesijas p
    where d.prof_ID = p.prof_ID ;
    
select /*+USE_NL(d p) +*/
    d.vards, d.uzvards, d.e_pasts, p.profesija, p.nodarbinatiba, p.alga 
    from darbinieki d, profesijas p
    where d.prof_ID = p.prof_ID ;
    
select /*+USE_HASH(p d) +*/
    d.vards, d.uzvards, d.e_pasts, p.profesija, p.nodarbinatiba, p.alga 
    from darbinieki d, profesijas p
    where d.prof_ID = p.prof_ID ;

select /*+USE_HASH(d p) +*/
    d.vards, d.uzvards, d.e_pasts, p.profesija, p.nodarbinatiba, p.alga 
    from darbinieki d, profesijas p
    where d.prof_ID = p.prof_ID ;


select /*+ USE_MERGE(d p) +*/ 
    d.vards, d.uzvards, d.e_pasts, p.profesija, p.nodarbinatiba, p.alga 
    from darbinieki d, profesijas p
    where d.prof_ID = p.prof_ID ;
    

select /*+ USE_MERGE(p d) +*/
    d.vards, d.uzvards, d.e_pasts, p.profesija, p.nodarbinatiba, p.alga 
    from darbinieki d, profesijas p
    where d.prof_ID = p.prof_ID;