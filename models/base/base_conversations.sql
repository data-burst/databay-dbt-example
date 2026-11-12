select
    id as conversation_id,
    user_id,
    session_id,
    created_at,
    deleted_at is not null as is_deleted
from {{ databay.latest_rows(source('warehouse', 'conversations')) }}
