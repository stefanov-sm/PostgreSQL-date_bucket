-- Without protection. An advanced SQLi attack may succeed in certain circumstances
create or replace function date_bucket(dpart text, dpart_count integer, ts timestamptz, origin timestamptz default 'epoch')
returns timestamptz language sql immutable as
$body$
    select date_bin(('1 '||dpart)::interval * dpart_count, ts, origin);
$body$;

-- With protection, slower
create or replace function date_bucket(dpart text, dpart_count integer, ts timestamptz, origin timestamptz default 'epoch')
returns timestamptz language plpgsql immutable as
$body$
declare 
    DPARTS_RX constant text[] := '{^days?$,^weeks?$,^months?$,^quarters?$,^years?$,^hours?$,^minutes?$,^seconds?$,^milliseconds?$}';
    DPARTS_LIST constant text := 'Valid date parts are day(s), week(s), month(s), quarter(s), year(s), hour(s), minute(s), second(s), millisecond(s)'; 
begin 
    if not dpart ~* any (DPARTS_RX) then 
        raise exception 'date_bucket: invalid date part "%"', dpart using hint = DPARTS_LIST;
    end if;
    return date_bin(('1 '||dpart)::interval * dpart_count, ts, origin);
end;
$body$;
