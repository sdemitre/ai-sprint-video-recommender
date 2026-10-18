# Sprint AI — Video Learning Hub

A responsive AI-training video finder with a built-in **90-entry mock catalog**. Recommendations are filtered by function area, task, tool, and keyword. The website does not load data from Google Sheets and does not include a public admin login or analytics dashboard.

## Run it

This is a static page; no Node.js build step is required.

1. Clone or download the repository.
2. (Optional) Copy `config.example.js` to `config.js` and add your Supabase project URL and publishable/anon key if you want to record usage events.
3. (Optional) In the Supabase SQL Editor, run `supabase/migrations/202610180001_secure_analytics.sql` to set up the analytics table and policies.
4. Serve the folder with any static server, or use the VS Code Live Server extension. For example, run `python3 -m http.server 8000` and open http://localhost:8000.

The video finder works with mock data without Supabase configuration. If Supabase is not configured, usage events are simply not recorded.

## What's included

- 90 mock catalog entries generated from 10 function areas, 3 tasks per area, and 3 AI tools per area.
- Function area, task, tool, and keyword filters; no skill-level filter.
- Responsive recommendation cards and a show-more control.
- Watch buttons open YouTube search results for the selected tool and task. These are mock recommendations, not individually verified video links.
- Optional usage-event collection for recommendation views, show-more actions, and video-selection clicks.
- No Google Sheets dependency and no public admin page, admin login, or analytics dashboard.

## Accessing private analytics (optional)

If Supabase is configured:

1. Sign in to your own account at https://supabase.com/dashboard.
2. Open the project used by this site.
3. Open **Table Editor → recommendation_events** to inspect recorded events, or use **SQL Editor** for grouped summaries and exports.

The website uses only the Supabase publishable/anon key. Database Row Level Security (RLS) should allow anonymous visitors to insert constrained event records without allowing them to read, update, or delete analytics.

## Security notes

- Never put a Supabase `service_role` key, database password, or personal access token in `config.js` or any browser-delivered file.
- `config.js` is ignored by Git; do not commit real secrets.
- Events are interaction counts, not unique-user counts. No visitor names or email addresses are collected.
- Before high-traffic production use, consider routing event writes through a Supabase Edge Function with rate limits and bot controls.

## Deploy

Deploy the static files to a static host. Only add `config.js` if optional Supabase analytics are needed. Apply the SQL migration to the correct Supabase project before expecting event tracking. Do not deploy private keys or account passwords.
