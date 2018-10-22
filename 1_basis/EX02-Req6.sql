select distinct owner,
case when length(owner) = 10 then owner
     when length(owner) > 10 then substr(owner, 0, 10)
     else lpad(owner, 10, '*')
end "Owner"
from all_objects
order by length(owner) desc;