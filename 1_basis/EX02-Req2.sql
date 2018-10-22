-- date is a litteral date. We need to specify it as '2018-10-22' for example
select trunc(date '&1' - sysdate) days from dual;
-- This is discouraged as the conversion will be based on the NLS_DATE_FORMAT which is definded in the session.
-- or we need to specify it with
-- alter session set nls_date_format  = 'yyyy-mm-dd';
-- select trunc('&1' - sysdate) days from dual;
select trunc(to_date('2018-10-22', 'yyyy-mm-dd') - sysdate) days from dual;
select trunc(months_between(date '&1', sysdate) * 30) days from dual;
select numtodsinterval(date '&1' - sysdate, 'DAY') age from dual;

create or replace procedure days_remaining_v1(p_date in varchar2) as
    calc_date date;
    days number;
begin
    calc_date := to_date(p_date, 'YYYY-MM-DD');
    
    select trunc(round(calc_date - current_date)) into days
    from dual;
    
    if days < 0 then
        dbms_output.put_line('Specified date is past current date');
        return;
    end if;
    
    dbms_output.put_line('Days remaining (v1): ' || days);
end;
/

create or replace procedure days_remaining_v2(p_date in varchar2) as
    calc_date date;
    days number;
begin
    calc_date := to_date(p_date, 'YYYY-MM-DD');
    
    select round(calc_date, 'DD') - round(current_date, 'DD') into days
    from dual;
    
    if days < 0 then
        dbms_output.put_line('Specified date is past current date');
        return;
    end if;
    
    dbms_output.put_line('Days remaining (v2): ' || days);
end;
/

-- Shift start of year to March
-- https://stackoverflow.com/a/12863278/3514658

create or replace procedure days_remaining_v3(p_date in varchar2) as
    calc_date date;
    days number;
    months number;
    years number;
begin
    calc_date := to_date(p_date, 'YYYY-MM-DD');
    months := mod((months + 9), 12);
    years := years - months / 10;
    365 * y + y/4 - y/100 + y/400 + (m*306 + 5)/10 + ( d - 1 )
    
    select (400 * 365) + 100 + 1 - 4
    365 / 12 * months_between(current_date, calc_date)))
    into days
    from dual;
    
    if days < 0 then
        dbms_output.put_line('Specified date is past current date');
        return;
    end if;
    
    dbms_output.put_line('Days remaining (v1): ' || days);
end;
/

call days_remaining_v1('2020-12-17');
call days_remaining_v2('2020-12-17');
call days_remaining_v3('2020-12-17');