class AddPostgresqlFunctionDateIsInRange < ActiveRecord::Migration
  def up
    execute %{
      CREATE FUNCTION date_is_in_range(birthdate date, 
                                       start_date date, 
                                       end_date date) RETURNS boolean
          LANGUAGE plpgsql
          AS $$

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
          - (extract(year from age(birthdate, '1900-01-01')) || ' years'
            )::interval
        )::date between start_date and end_date into result;
        return result;
      end;
      $$;
    }
  end

  def down
    execute %{
      drop function date_is_in_range(date, date, date);
    } 
  end
end
