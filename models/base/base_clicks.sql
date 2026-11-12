select
    id as click_id,
    user_id,
    provider,
    category,
    price_toman,
    created_at
from {{ databay.latest_rows(source('warehouse', 'clicks')) }}
