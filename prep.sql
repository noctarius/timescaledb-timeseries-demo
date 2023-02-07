create function random_between(low integer, high integer) returns double precision
    strict
    language plpgsql
as
$$
begin
  return round((random() * (high - low + 1) + low)::numeric, 2)::float;
end;
$$;

alter function random_between(integer, integer) owner to tsdbadmin;