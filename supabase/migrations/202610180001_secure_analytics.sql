-- Secure shared analytics. Apply this in Supabase Dashboard > SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.recommendation_events (
  id uuid primary key default gen_random_uuid(),
  video_id text not null check (char_length(video_id) between 1 and 120),
  video_title text not null check (char_length(video_title) between 1 and 300),
  function_area text not null check (char_length(function_area) between 1 and 120),
  task text not null check (char_length(task) between 1 and 240),
  tool text not null check (char_length(tool) between 1 and 120),
  event_type text not null check (event_type in ('shown','selected','show_more')),
  created_at timestamptz not null default now()
);

create index if not exists recommendation_events_created_at_idx on public.recommendation_events(created_at desc);
create index if not exists recommendation_events_video_id_idx on public.recommendation_events(video_id);
create index if not exists recommendation_events_area_idx on public.recommendation_events(function_area,event_type);

alter table public.admin_users enable row level security;
alter table public.recommendation_events enable row level security;

drop policy if exists "Admins can read own allowlist row" on public.admin_users;
create policy "Admins can read own allowlist row" on public.admin_users
  for select to authenticated using (user_id = (select auth.uid()));

drop policy if exists "Anyone can record recommendation events" on public.recommendation_events;
create policy "Anyone can record recommendation events" on public.recommendation_events
  for insert to anon, authenticated with check (
    char_length(video_id) between 1 and 120 and
    char_length(video_title) between 1 and 300 and
    char_length(function_area) between 1 and 120 and
    char_length(task) between 1 and 240 and
    char_length(tool) between 1 and 120 and
    event_type in ('shown','selected','show_more')
  );

drop policy if exists "Only allowlisted admins can read analytics" on public.recommendation_events;
create policy "Only allowlisted admins can read analytics" on public.recommendation_events
  for select to authenticated using (
    exists (select 1 from public.admin_users au where au.user_id = (select auth.uid()))
  );

revoke all on public.admin_users from anon, authenticated;
grant select on public.admin_users to authenticated;
revoke all on public.recommendation_events from anon, authenticated;
grant insert on public.recommendation_events to anon, authenticated;
grant select on public.recommendation_events to authenticated;

-- After creating your administrator under Authentication > Users, run:
-- insert into public.admin_users(user_id)
-- select id from auth.users where email = 'YOUR_ADMIN_EMAIL'
-- on conflict (user_id) do nothing;
-- Never put a service_role key in the browser.