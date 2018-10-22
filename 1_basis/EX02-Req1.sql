select user_tables.table_name "Table name", column_name "Column name", data_type "Column type"
from user_tables, user_tab_columns
where user_tables.table_name = user_tab_columns.table_name;