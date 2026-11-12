-- One row per session that searched: how long it lasted and what it led to.
with searches as (
    select
        session_id,
        any(user_id) as user_id,
        min(created_at) as started_at,
        max(created_at) as ended_at,
        count() as searches,
        countIf(succeeded) as successful_searches,
        uniqExact(category) as categories
    from {{ ref('base_searches') }}
    group by session_id
),
conversations as (
    select session_id, count() as conversations
    from {{ ref('base_conversations') }}
    group by session_id
)
select
    s.session_id,
    s.user_id,
    s.started_at,
    s.ended_at,
    dateDiff('second', s.started_at, s.ended_at) as duration_seconds,
    s.searches,
    s.successful_searches,
    s.categories,
    coalesce(c.conversations, 0) as conversations
from searches s
left join conversations c on c.session_id = s.session_id
