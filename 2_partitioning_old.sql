drop table measurements cascade;

create table measurements (
    ts timestamptz not null,
    reading float not null
);

create table measurements_month_1 ()
    inherits (measurements);
create table measurements_month_2 ()
    inherits (measurements);
create table measurements_month_3 ()
    inherits (measurements);

create or replace function measurement_insert_trigger()
returns trigger
language plpgsql as $$
begin
    if (NEW.ts >= date '2022-06-01' and
        NEW.ts < date '2022-07-01') then
        insert into measurements_month_1 values (NEW.*);
    elseif (NEW.ts >= date '2022-07-01' and
             NEW.ts < date '2022-08-01') then
        insert into measurements_month_2 values (NEW.*);
    elseif (NEW.ts >= date '2022-08-01' and
             NEW.ts < date '2022-09-01') then
        insert into measurements_month_3 values (NEW.*);
    else
        raise exception 'ts outside of valid range';
    end if;
    return null;
end;
$$;

create trigger insert_trigger
    before insert on measurements
    for each row execute function measurement_insert_trigger();

create index on measurements_month_1 (ts);
create index on measurements_month_2 (ts);
create index on measurements_month_3 (ts);

insert into measurements
select t.ts, random_between(10, 50) as reading
from generate_series(
    '2022-06-01' at time zone 'CET',
    '2022-08-31' at time zone 'CET',
    interval '10 second'
) t(ts);

explain (analyze, verbose)
select * from measurements
where ts >= '2022-07-14' and ts < '2022-07-16';

