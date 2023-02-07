drop table measurements cascade;

create table measurements (
    ts timestamptz not null,
    reading float not null
) partition by range (ts);

create table measurements_month_1
    partition of measurements
    for values from ('2022-06-01') to ('2022-07-01');
create table measurements_month_2
    partition of measurements
    for values from ('2022-07-01') to ('2022-08-01');
create table measurements_month_3
    partition of measurements
    for values from ('2022-08-01') to ('2022-09-01');

create index on measurements (ts);

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

set enable_partition_pruning = off;
