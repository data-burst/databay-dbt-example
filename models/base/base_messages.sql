-- One row per message; prompt and answer text are left out.
select
    id as message_id,
    conversation_id,
    category,
    created_at
from {{ databay.latest_rows(source('warehouse', 'messages')) }}
