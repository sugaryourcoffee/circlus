create or replace function date_in_range(birthdate date, 
                                         start_date date, 
                                         end_date date)
  returns date as $$

declare
  base_date date := start_date;
  result date;
begin
  if (date_part('year', start_date) < date_part('year', end_date)) then
    if (date_part('month', birthdate) < date_part('month', start_date)) then
      base_date := end_date;
    end if;
  end if;

  select (
    date_trunc('year', base_date)
    + age(birthdate, '1900-01-01')
    - (extract(year from age(birthdate, '1900-01-01')) || ' years')::interval
  )::date into result;
  return result;
end;
$$ language plpgsql;

create or replace function date_is_in_range(birthdate date, 
                                            start_date date, 
                                            end_date date)
  returns boolean as $$

declare
  base_date date := start_date;
  result boolean;
begin
  if ((date_part('year', start_date) < date_part('year', end_date)) and
      (date_part('month', birthdate) < date_part('month', start_date))) then
    base_date := end_date;
  end if;

  select (
    date_trunc('year', base_date)
    + age(birthdate, '1900-01-01')
    - (extract(year from age(birthdate, '1900-01-01')) || ' years')::interval
  )::date between start_date and end_date into result;
  return result;
end;
$$ language plpgsql;

