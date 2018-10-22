-- to be run on dbms2_sakila schema
--select index_name "Index name", index_type "Index type", table_name "Table name", (case when uniqueness like 'unique' then 'Yes' else 'No' end) "Uniqueness" from user_indexes;
--describe user_indexes;
--select uniqueness  from user_indexes;
--select index_name "Index name", index_type "Index type", table_name "Table name", decode(uniqueness, 'unique' , 'Yes', 'No') "Uniqueness" from user_indexes;

column table_name format a30;

select
index_name "Index name",
index_type "Index type",
table_name "Table name",
decode(uniqueness, 'UNIQUE', 'YES', 'NO') "Unicity",
coalesce(to_char(last_analyzed, 'DAY, MON/DD/YYYY'), '***') "Last analysis"
from user_indexes
-- We specify an @ as escape secuqne because the underscore will be interpreted as whatever char we have
where index_name not like 'SYS@_%' escape '@'
order by last_analyzed;

-- decode is like a case on 32 case
--decode(expression, value1, then1, value2, then2, ..., elsevalue)