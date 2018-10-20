create role sgbd2g_role not identified;
grant alter session to sgbd2g_role;
grant create session to sgbd2g_role;
grant create table to sgbd2g_role;
grant create procedure to sgbd2g_role;
grant create sequence to sgbd2g_role;
grant create trigger to sgbd2g_role;
grant create type to sgbd2g_role;
grant create view to sgbd2g_role;
grant execute on sys.owa_opt_lock to sgbd2g_role;
grant execute on sys.dbms_lock to sgbd2g_role;

create user kata identified by oracle default tablespace users account unlock;
alter user kata quota unlimited on users;
grant sgbd2g_role to kata;

create user sakila identified by oracle default tablespace users account unlock;
alter user sakila quota unlimited on users;
grant sgbd2g_role to sakila;
