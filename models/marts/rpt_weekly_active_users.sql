-- Weekly active users (searched or sent a message) and new sign-ups.
with search_weeks as (
    select toMonday(created_at) as week, user_id
    from {{ ref('base_searches') }}
),
message_weeks as (
    select toMonday(m.created_at) as week, c.user_id as user_id
    from {{ ref('base_messages') }} m
    inner join {{ ref('base_conversations') }} c on c.conversation_id = m.conversation_id
),
active as (
    select week, uniqExact(user_id) as active_users
    from (
        select week, user_id from search_weeks
        union all
        select week, user_id from message_weeks
    )
    group by week
),
joined as (
    select toMonday(date_joined) as week, count() as new_users
    from {{ ref('dim_users') }}
    group by week
)
select
    a.week as week,
    a.active_users as active_users,
    coalesce(j.new_users, 0) as new_users
from active a
left join joined j on j.week = a.week
order by week
