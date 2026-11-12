-- One row per current user, with lifetime activity.
with searches as (
    select user_id, count() as searches, countIf(succeeded) as successful_searches,
           min(created_at) as first_search_at, max(created_at) as last_search_at
    from {{ ref('base_searches') }}
    group by user_id
),
conversations as (
    select user_id, count() as conversations
    from {{ ref('base_conversations') }}
    where not is_deleted
    group by user_id
),
clicks as (
    select user_id, count() as clicks, sum(price_toman) as clicked_value_toman
    from {{ ref('base_clicks') }}
    group by user_id
)
select
    u.user_id,
    u.is_anonymous,
    u.is_active,
    u.date_joined,
    u.last_login,
    coalesce(s.searches, 0) as searches,
    coalesce(s.successful_searches, 0) as successful_searches,
    coalesce(c.conversations, 0) as conversations,
    coalesce(k.clicks, 0) as clicks,
    coalesce(k.clicked_value_toman, 0) as clicked_value_toman,
    s.first_search_at,
    s.last_search_at
from {{ ref('base_users') }} u
left join searches s on s.user_id = u.user_id
left join conversations c on c.user_id = u.user_id
left join clicks k on k.user_id = u.user_id
where not u.is_deleted
