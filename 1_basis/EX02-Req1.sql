column table_name format a15;

select user_tables.table_name "Table name", column_name "Column name", data_type "Column type"
from user_tab_cols
order by table_name, column_id;

-- column_id: creation order of the columns