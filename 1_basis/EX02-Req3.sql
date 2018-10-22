select to_char(systimestamp, 'yyyy-mm-dd hh:mm:ss') "System date" from dual;
select to_char(cast(systimestamp at time zone 'PST' as date), 'yyyy-mm-dd hh:mm:ss') "USA west coast (Pacific time)" from dual;
select to_char(cast(systimestamp at time zone 'UTC' as date), 'yyyy-mm-dd hh:mm:ss') "UTC" from dual;
select to_char(cast(systimestamp at time zone 'CET' as date), 'yyyy-mm-dd hh:mm:ss') "CET" from dual;
select to_char(cast(systimestamp at time zone 'Etc/GMT+8' as date), 'yyyy-mm-dd hh:mm:ss') "Malaysia" from dual;
select to_char(cast(systimestamp at time zone 'Etc/GMT+8' as date), 'yyyy-mm-dd hh:mm:ss') "Malaysia" from dual;


--select
--systimestamp "Local Time",
--systimestamp at time zone 'Americ/Los_Angeles' "West Coast Time",
--systimestamp at time zone 'Americ/Los_Angeles' "West Coast Time"
--from dual;
-- time zone names
-- https://docs.oracle.com/cd/B19306_01/server.102/b14225/applocaledata.htm#i637736
--SELECT tzname, tzabbrev FROM V$TIMEZONE_NAMES;