-- Removal happens in reverse order of creating tables below.
drop table dbms2_kata.trainers cascade constraints purge;
drop table dbms2_kata.clubs cascade constraints purge;
drop table dbms2_kata.members cascade constraints purge;
drop table dbms2_kata.competitions cascade constraints purge;
drop table dbms2_kata.judges cascade constraints purge;
drop table dbms2_kata.evaluations cascade constraints purge;
drop table dbms2_kata.participations cascade constraints purge;
drop table dbms2_kata.katas cascade constraints purge;

-- When constraints are created along side tables, parent tables must be
-- created before child tables.
create table dbms2_kata.clubs (
    id number,
    name varchar(30)
        -- Do not use check is not null as it has a performance penalty
        -- src.: https://www.youtube.com/watch?v=Ai8mzYDCxCA
        constraint clubs$name$nn not null,
    address varchar2(40)
        constraint clubs$address$nn not null,
    postal_code number
        constraint clubs$postal_code$nn not null,
    location varchar2(30)
        constraint clubs$location$nn not null,
    phone_number varchar2(20),
    
    -- For ease of reading, and in order to be named, we are placing our
    -- constraints as table contraints (also called out-of-line).
    -- This is not valid when using NOT NULL constraints. NOT NULL
    -- constraints have another meaning when used on tables instead of columns.
    --
    -- Primary key = not null + unique + index creation
    --
    -- No need to specify NOT NULL for primary key, this is implicit.
    -- src.: https://stackoverflow.com/a/13665422/3514658
    constraint clubs$id$pk primary key (id)
);

create table dbms2_kata.trainers (
    id number,
    lastname varchar2(30)
        constraint trainers$lastname$nn not null,
    firstname varchar2(30)
        constraint trainers$firstname$nn not null,
    competition_level number(2),
    address varchar2(60)
        constraint trainers$address$nn not null,
    postal_code number(4)
        constraint trainers$postal_code$nn not null,
    city varchar2(20)
        constraint trainers$city$nn not null,
    club number
        constraint trainers$club$nn not null,

    constraint trainers$id$pk primary key (id),
    constraint trainers$lastname$un unique (lastname),
    constraint trainers$firstname$un unique (firstname),
    constraint trainers$city$un unique (city),
    constraint trainers$club$fk foreign key (club) references dbms2_kata.clubs(id),
    constraint trainers$competition_level$ck check (competition_level between 1 and 15),
    constraint trainers$id$ck check ((postal_code is null) or (postal_code is not null and substr(id, 1, 4) = postal_code))
);

create table dbms2_kata.members (
    license number(6),
    lastname varchar2(30)
        constraint members$lastname$nn not null,
    firstname varchar2(30)
        constraint members$firstname$nn not null,
    birthdate date,
    address varchar2(50),
    postal_code number(4),
    city varchar2(30),
    gender char(1),
    club number
        constraint members$club$nn not null,
 
    constraint members$license$pk primary key (license),
    constraint members$lastname$un unique (lastname, firstname, city),
    constraint members$club$fk foreign key (club) references dbms2_kata.clubs(id),
    -- When trunc is used without second argument, it truncates a number to
    -- remove the decimal part.
    -- We get the last day of the current year in order to determine whether
    -- the member will get at least its 6th birthday on current year
    -- src.: https://stackoverflow.com/a/3015539/3514658
    -- Check constraint cannot contain sysdate. Have to use a trigger instead.
    --constraint members$birthdate$ck check (trunc(months_between(sysdate, birthdate) / 12) >= 6),
    constraint members$gender$ck check (gender in ('N', 'F', 'I')),
    -- The all 3 address fields must be filled or
    -- they can be facultative if we don't know the address (as a wholistic).
    -- Would have been simpler to define a dedicated address table.
    -- Maybe a subject for the "functional dependence" database concept?
    constraint members$address$ck check ((address is null and postal_code is null and city is null) or (address is not null and postal_code is not null and city is not null))
);

create table dbms2_kata.katas (
    kata nvarchar2(20),
    name varchar2(30)
        constraint katas$name$nn not null,
    variant varchar2(15),
    
    constraint katas$kata$pk primary key (kata),
    constraint katas$name_variant$un unique (name, variant),
    constraint katas$variant$ck check (variant in ('shodan', 'nidan', 'sandan', 'yondan', 'godan'))
);

create table dbms2_kata.competitions (
    competition number,
    -- While possible to create a column named date with the use of quotes
    -- "date" date
    -- this is not recommended as this is a reserved word.
    -- src.: https://stackoverflow.com/a/1162391/3514658
    demo_date date
        constraint competitions$demo_date$nn not null,
    name varchar2(60)
        constraint competitions$name$nn not null,
    kata_demoed nvarchar2(20)
        constraint competitions$kata_demoed$nn not null,
    organizer number
        constraint competitions$organizer$nn not null,
    
    constraint competitions$competition$pk primary key (competition),
    constraint competitions$kata_demoed$fk foreign key (kata_demoed) references dbms2_kata.katas(kata),
    constraint competitions$organizer$fk foreign key (organizer) references dbms2_kata.clubs(id),
    -- modulo function
    -- src.: https://www.techonthenet.com/oracle/functions/mod.php
    constraint competitions$demo_date$chck check (mod(extract(month from demo_date), 2) = 0)
);

create table dbms2_kata.judges (
    trainer number,
    competition number,
    judge_number number(2),
    
    constraint judges$trainer_competition$pk primary key (trainer, competition),
    constraint judges$trainer$fk foreign key (trainer) references dbms2_kata.trainers(id),
    constraint judges$competition$fk foreign key (competition) references dbms2_kata.competitions(competition),
    constraint judges$judge_number$ck check (judge_number between 1 and 5)
);
comment on table dbms2_kata.judges is 'trainers judge/evaluate competitions';

create table dbms2_kata.evaluations (
    trainer number,
    competition number,
    license number(6),
    rating number(3,1),
    
    constraint evaluations$trainer_competition_license$pk primary key (trainer, competition, license),
    constraint evaluations$trainer$fk foreign key (trainer) references dbms2_kata.trainers(id),
    constraint evaluations$competition$fk foreign key (competition) references dbms2_kata.competitions(competition),
    constraint evaluations$license$fk foreign key (license) references dbms2_kata.members(license),
    constraint evaluations$rating$ck check (rating between 0 and 10)
);
comment on table dbms2_kata.evaluations is 'trainers judge/evaluate club members for a particular competition';

create table dbms2_kata.participations (
    license number,
    competition number,
    
    constraint participations$license_competition$pk primary key (license, competition),
    constraint participations$license$fk foreign key (license) references dbms2_kata.members(license),
    constraint participations$competition$fk foreign key (competition) references dbms2_kata.competitions(competition)
);
comment on table dbms2_kata.participations is 'members participate to competitions';

insert into dbms2_kata.katas values ('平安初段', 'Heian', 'shodan');
insert into dbms2_kata.katas values ('平安二段', 'Heian', 'nidan');
insert into dbms2_kata.katas values ('平安三段', 'Heian', 'sandan');
insert into dbms2_kata.katas values ('平安四段', 'Heian', 'yondan');
insert into dbms2_kata.katas values ('平安五段', 'Heian', 'godan');
insert into dbms2_kata.katas values ('披塞大', 'Bassai dai', null);
insert into dbms2_kata.katas values ('慈恩', 'Jion', null);
insert into dbms2_kata.katas values ('燕飛', 'Enpi', null);
insert into dbms2_kata.katas values ('観空大', 'Kanku dai', null);
insert into dbms2_kata.katas values ('半月', 'Hangetsu', null);
insert into dbms2_kata.katas values ('十手', 'Jitte', null);
insert into dbms2_kata.katas values ('岩鶴', 'Gankaku', null);
insert into dbms2_kata.katas values ('鉄騎初段', 'Tekki', 'shodan');
insert into dbms2_kata.katas values ('鉄騎二段', 'Tekki', 'nidan');
insert into dbms2_kata.katas values ('鉄騎三段', 'Tekki', 'sandan');
insert into dbms2_kata.katas values ('二十四步', 'Nijūshiho', null);
insert into dbms2_kata.katas values ('珍手', 'Chinte', null);
insert into dbms2_kata.katas values ('壯鎭', 'Sōchin', null);
insert into dbms2_kata.katas values ('明鏡', 'Meikyō/Rōhai', null);
insert into dbms2_kata.katas values ('雲手', 'Unsu', null);
insert into dbms2_kata.katas values ('披塞小', 'Bassai shō', null);
insert into dbms2_kata.katas values ('観空小', 'Kankū shō', null);
insert into dbms2_kata.katas values ('王冠', 'Wankan', null);
insert into dbms2_kata.katas values ('五十四歩小', 'Gojūshiho shō', null);
insert into dbms2_kata.katas values ('五十四歩大', 'Gojūshiho dai', null);
insert into dbms2_kata.katas values ('慈陰', 'Ji''in', null);

-- 'or replace' it not really needed since (above) we are dropping the
-- object (table) on which it is applied to.
create or replace trigger dbms2_kata.members$birthdate$check
before insert or update on dbms2_kata.members
for each row
begin
    if trunc(months_between(sysdate, :new.birthdate) / 12) < 6 then
        raise_application_error(-20000, 'Members must be at least 6 years old in the current year.');
    end if;
end;