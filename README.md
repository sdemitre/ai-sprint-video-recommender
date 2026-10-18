# Sprint AI — Video Learning Hub

A responsive public AI-training video finder with private usage analytics managed directly in the project owner's Supabase Dashboard. The website does not include an admin login or analytics dashboard.

## Run it

This is a static page; no Node.js build step is required.

1. Download or clone the repository.
2. Copy `config.example.js` to `config.js`.
3. Create a project at https://supabase.com/dashboard.
4. In Supabase **Project Settings → API**, copy the Project URL and publishable/anon key into `config.js`.
5. In Supabase **SQL Editor**, run `supabase/migrations/202610180001_secure_analytics.sql`.
6. Serve the folder with any static server, or use the VS Code Live Server extension. For example, run `python3 -m http.server 8000` and open http://localhost:8000.

If Supabase is not configured, the finder still works, but usage events will not be recorded. The live Google Sheet is fetched by the browser; if it is private or not shared for viewing, the site falls back to demo recommendations.

## What's included

- Public video finder with function area, task, tool, and keyword filters.\n- Live catalog fetch from spreadsheet ID `19oEtn6wLq_2Svr_axMuFb9H0llNcqdR7Fsxcn3VOa6w` using the first tab's CSV export.\n- Expected column headers (case-insensitive): `Title`/`Video Title`, `URL`/`Video URL`, `Function Area`, `Task`/`Goal`, `Tool`/`AI Tool`, `Description`, and `Duration`. Title or URL is required; missing optional fields receive defaults.
- Loads the live video catalog from the linked Google Sheet's first tab as CSV, with a demo catalog fallback if the sheet cannot be fetched. The sheet must be viewable to the website without signing in (or published to web as CSV).
- Watch buttons open YouTube search results for the chosen tool and task. The entries are mock recommendations, not individually verified videos.
- Usage-event collection for recommendation views, show-more actions, and video-selection clicks.
- No public admin page, admin login form, or analytics dashboard.

## Accessing your private analytics

1. Sign in to your own account at https://supabase.com/dashboard.
2. Open the project used by this site.
3. Open **Table Editor → recommendation_events** to inspect recorded events, or use **SQL Editor** for grouped summaries and exports.
4. Treat your Supabase account credentials as private and enable strong account security.

The website's public key is only the Supabase publishable/anon key. Database Row Level Security (RLS) allows anonymous visitors to insert constrained event records but does not allow them to read, update, or delete analytics. Your project-owner access in Supabase is separate from the public website.

## Security notes

- Never put a Supabase `service_role` key, database password, or personal access token in `config.js` or any browser-delivered file.
- `config.js` is ignored by Git; do not commit real secrets.
- The insert policy validates event field lengths and allowed event types but does not implement robust anti-abuse rate limiting. Before high-traffic production use, route writes through a Supabase Edge Function with rate limits and bot controls.
- Events are interaction counts, not unique-user counts. No visitor names or email addresses are collected.
- The SQL migration retains an allowlisted authenticated-read policy as an additional restriction, but the public website does not expose a way to sign in or read analytics.

## Deploy

Deploy the static files to a static host. Add `config.js` to the deployed static site with your project URL and publishable/anon key. Apply the SQL migration to the correct Supabase project before expecting event tracking. Do not deploy private keys or account passwords.
