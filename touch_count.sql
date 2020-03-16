with 
    first_orders
        as 
            (
              select 
                  o.user_id
                , o.session_id
                , o.time as first_order_time
              from heap_orders o 
              where o.order_sequence = 1
            ), 
    session_tallies
        as 
            (
              select 
                    s.user_id
                  , s.session_id
                  , s.session_start_time
                  , o.first_order_time
              from heap_sessions s 
              join first_orders o 
                  on o.user_id = s.user_id
                      and s.session_start_time <= o.first_order_time
            )
            
select
      st.user_id 
    , count(*) "touch_count"
    , timestampdiff('D', min(st.session_start_time), max(st.first_order_time)) "time_to_order"
from session_tallies st
group by 1