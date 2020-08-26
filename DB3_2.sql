create index Darb_Ind_a on darbinieki(darb_id, vards)
    global partition by hash (darb_id)
    partitions 4;

  
select d. darb_ID, d.vards 
    from darbinieki d 
    where darb_ID like '%111%';






