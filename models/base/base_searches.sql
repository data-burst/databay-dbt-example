-- One row per search; the prompt text is left out.
select
    id as search_id,
    user_id,
    session_id,
    category,
    ok as succeeded,
    result_count,
    created_at
from {{ databay.latest_rows(source('warehouse', 'query_logs')) }}
