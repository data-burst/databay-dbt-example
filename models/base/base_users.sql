-- Current users, without credentials or contact details.
select
    id as user_id,
    is_anonymous,
    is_active,
    is_staff,
    date_joined,
    last_login,
    deleted_at is not null as is_deleted
from {{ databay.latest_rows(source('warehouse', 'users')) }}
