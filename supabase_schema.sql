-- Shree Radhe Enterprises Ledger — Supabase schema
-- Run this once in your Supabase project's SQL Editor (Dashboard → SQL Editor → New query → paste → Run).

create table if not exists bills (
  id                  text primary key,
  company             text,
  date                date,
  bill_no             text,
  retailer            text,
  total_amount        numeric not null default 0,
  delivery_date       date,
  area                text,
  sales_person        text,
  delivery_partner    text,
  delivery_status     text,
  amount_at_delivery  numeric,
  comments            text,
  discount            numeric,
  next_visit_planned  date,
  created_at          timestamptz not null default now()
);

create table if not exists visits (
  id           text primary key,
  bill_id      text not null references bills(id) on delete cascade,
  date         date,
  assigned_to  text,
  status       text,
  amount       numeric not null default 0,
  notes        text,
  created_at   timestamptz not null default now()
);

create index if not exists visits_bill_id_idx on visits(bill_id);
create index if not exists bills_delivery_date_idx on bills(delivery_date);
create index if not exists bills_delivery_status_idx on bills(delivery_status);

-- Row Level Security -----------------------------------------------------
-- Supabase enables RLS by default on new tables, which blocks ALL access
-- until you add a policy. This app has no login system — everyone who has
-- the page URL uses the same anon key baked into the HTML. These policies
-- grant that anon key full read/write access, which matches how the app
-- works today. This is NOT the same as public security: anyone who gets
-- your Supabase URL + anon key (visible in the page's source) can read or
-- write this data directly, bypassing the UI entirely. Fine for an
-- internal tool on an unlisted URL; not fine if this needs to resist a
-- determined outsider. If that ever matters, add Supabase Auth and scope
-- these policies to authenticated users instead of anon.

alter table bills enable row level security;
alter table visits enable row level security;

create policy "anon full access to bills" on bills
  for all using (true) with check (true);

create policy "anon full access to visits" on visits
  for all using (true) with check (true);
