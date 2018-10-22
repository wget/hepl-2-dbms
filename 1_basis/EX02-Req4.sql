-- to be run on dbms2_sakila schema
--select index_name "Index name", index_type "Index type", table_name "Table name", (case when uniqueness like 'unique' then 'Yes' else 'No' end) "Uniqueness" from user_indexes;
describe user_indexes;
--select uniqueness  from user_indexes;
--select index_name "Index name", index_type "Index type", table_name "Table name", decode(uniqueness, 'unique' , 'Yes', 'No') "Uniqueness" from user_indexes;