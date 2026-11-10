-- Shree Radhe Enterprises Ledger — Supabase schema
-- Run this once in your Supabase project's SQL Editor (Dashboard → SQL Editor → New query → paste → Run).

-- Users table (Supabase Auth) already exists as auth.users
-- Profiles table to store role per user
create table if not exists profiles (
  id uuid references auth.users not null primary key,
  name text,  -- delivery‑partner display name
  role text not null default 'viewer' -- allowed values: admin, editor, delivery_partner, viewer
  id uuid references auth.users not null primary key,
  role text not null default 'viewer' -- allowed values: admin, editor, delivery_partner, viewer
);

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

-- Row Level Security for profiles
alter table profiles enable row level security;

-- Profiles policies
create policy "allow read profiles" on profiles for select using (true);
create policy "allow write profiles" on profiles for all using (auth.role() = 'admin' or auth.role() = 'editor');

alter table bills enable row level security;
alter table visits enable row level security;

-- Policies ---------------------------------------------------------------
-- Everyone (including anon) can read all rows
create policy "allow read for all" on bills for select using (true);
create policy "allow read for all" on visits for select using (true);

-- Only admins or editors can write (insert, update, delete)
create policy "allow write for admins" on bills for all using (auth.role() = 'admin' or auth.role() = 'editor');
create policy "allow write for admins" on visits for all using (auth.role() = 'admin' or auth.role() = 'editor');
