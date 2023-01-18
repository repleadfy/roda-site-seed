select count(distinct s.id)
from sellers s
         join contracts c on c.company_id = s.company_id
         join plans p on p.id = c.plan_id
where end_plan_on is null
  and p.is_billable = 1
  and (c.billing_account_id is null or c.billing_account_id = s.billing_account_id);