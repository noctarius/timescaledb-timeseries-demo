drop materialized view if exists measurements_avg_1h;
drop materialized view if exists measurements_avg_15min;

create materialized view measurements_avg_15min
    with (timescaledb.continuous) as
select
    time_bucket('15 minutes', ts) as bucket,
    avg(reading) as reading,
    sum(reading) as sum_reading,
    count(reading) as count_reading
from measurements
group by 1
order by 1;

create materialized view measurements_avg_1h
    with (timescaledb.continuous) as
select
    time_bucket('60 minutes', bucket) as bucket,
    sum(sum_reading) / sum(count_reading) as reading
from measurements_avg_15min
group by 1
order by 1;


