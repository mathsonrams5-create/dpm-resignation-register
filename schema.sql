-- ============================================================
-- DPM Resignation Register — Database Setup
-- Run this once inside Supabase: Project > SQL Editor > New query
-- ============================================================

-- 1. Create the table that holds each resignation record
create table if not exists resignations (
  id                    uuid primary key default gen_random_uuid(),
  full_name             text not null,
  employee_file_number  text,
  position_title        text,
  department            text,
  employment_province   text,
  resignation_date      date,
  effective_date        date,
  electorate_contesting text,
  electorate_province   text,
  party_affiliation     text,
  status                text default 'Pending Verification',
  remarks               text,
  recorded_by           text,
  created_at            timestamptz default now()
);

-- 2. Turn on Row Level Security — with this ON, nobody can read or
--    write data until an explicit policy below allows it.
alter table resignations enable row level security;

-- 3. Only logged-in (authenticated) DPM staff can view records.
--    There is no public sign-up, so "authenticated" effectively
--    means "an account you created manually in the Supabase dashboard".
create policy "Staff can view records"
on resignations for select
using ( auth.role() = 'authenticated' );

-- 4. Only logged-in staff can add new records.
create policy "Staff can insert records"
on resignations for insert
with check ( auth.role() = 'authenticated' );

-- 5. Only logged-in staff can update records (e.g. change status).
create policy "Staff can update records"
on resignations for update
using ( auth.role() = 'authenticated' );

-- Note: there is deliberately no delete policy. If you need to
-- correct a mistaken entry, update its status/remarks instead of
-- deleting it, so there's always an audit trail.
