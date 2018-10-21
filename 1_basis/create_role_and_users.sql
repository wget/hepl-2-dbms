create role dbms2_role not identified;
grant alter session to dbms2_role;
grant create session to dbms2_role;
grant create table to dbms2_role;
grant create procedure to dbms2_role;
grant create sequence to dbms2_role;
grant create trigger to dbms2_role;
grant create type to dbms2_role;
grant create view to dbms2_role;
grant execute on sys.owa_opt_lock to dbms2_role;
grant execute on sys.dbms_lock to dbms2_role;

create user dbms2_kata identified by oracle default tablespace users account unlock;
alter user dbms2_kata quota unlimited on users;
grant dbms2_role to dbms2_kata;

create user dbms2_sakila identified by oracle default tablespace users account unlock;
alter user dbms2_sakila quota unlimited on users;
grant dbms2_role to dbms2_sakila;
