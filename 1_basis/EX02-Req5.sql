-- Do not use a rownum >= A_NUMBER, otherwise everything will be hiddeN

-- step 1
select object_name, owner, created, status, rownum rn
from all_objects
where object_type = 'VIEW'
and object_name like 'APEX_%W%' escape '@'
order by object_name

-- step 2
select *
from (
    -- We need to rename the rownum, otherwise this will be the rownum of
    -- the parent request that will be called. We want the rownum from the
    -- nested request.
    select object_name, owner, created, status, rownum rn
    from all_objects
    where object_type = 'VIEW'
    and object_name like 'APEX_%W%' escape '@'
    order by object_name
)
where rn between 5 and 12;

-- optimized, because the added column called 'rn' will be added for the X rows be have