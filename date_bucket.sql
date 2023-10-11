create or replace function date_bucket(arg_datepart text, arg_number integer, arg_date timestamptz, arg_origin timestamptz default 'epoch')
returns timestamptz language plpgsql immutable as
$$
declare 
	DPARTS_RX constant text[] := '{^days?$,^weeks?$,^months?$,^quarters?$,^years?$,^hours?$,^minutes?$,^seconds?$,^milliseconds?$}';
	DPARTS_LIST constant text :=   'day(s), week(s), month(s), quarter(s), year(s), hour(s), minute(s), second(s), millisecond(s)'; 
 begin 
	if not arg_datepart ~* any (DPARTS_RX) then 
		raise exception 'date_bucket: invalid date part "%"', arg_datepart 
		using hint = 'Valid date parts are '||DPARTS_LIST;
	end if;
	return date_bin(('1 '||arg_datepart)::interval * arg_number, arg_date, arg_origin);
end;
$$;