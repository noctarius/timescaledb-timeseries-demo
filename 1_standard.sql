drop table measurements cascade;

create table measurements (
    ts timestamptz not null,
    reading float not null
);

insert into measurements
select t.ts, random_between(10, 50) as reading
from generate_series(
    '2022-06-01' at time zone 'CET',
    '2022-08-31' at time zone 'CET',
    interval '10 second'
) t(ts);

create index on measurements (ts);

explain (analyze, verbose)
select * from measurements
where ts >= '2022-07-14' and ts < '2022-07-16';
