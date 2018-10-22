set termout off
--set sqlformat default
-- /!\ feedback must be set to on when debugging/developping,
-- otherwise error messages aren't displayed either.
set feedback off
set trimspool on
set newpage none
set linesize 9999
set pagesize 0
set verify off

spool EX03-PurgeCurrentSchema.sql

select 'drop table ' || object_name || ' cascade constraints;'
from user_objects
where object_type = 'table';

spool off

@EX03-PurgeCurrentSchema.sql

spool EX03-PurgeCurrentSchema.sql append

select 'drop table ' || object_type || ' ' || object_name || ';'
from user_objects
where status = 'invalid';

spool off
@EX03-PurgeCurrentSchema.sql 