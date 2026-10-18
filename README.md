# Sprint AI — Video Learning Hub

A responsive public AI-training video finder with a Supabase-protected admin analytics dashboard.

## Run it

This repository uses a simple static page so you do not need Node.js or a build step to preview it.

1. Download or clone the repository.
2. Copy \`config.example.js\` to \`config.js\`.
3. Create a project at https://supabase.com/dashboard.
4. In Supabase **Project Settings → API**, copy the Project URL and publishable/anon key into \`config.js\`.
5. In Supabase **SQL Editor**, run \`supabase/migrations/202610180001_secure_analytics.sql\`.
6. In Supabase **Authentication → Users**, create the admin user with an email and a strong password. If only one administrator is needed, disable public sign-ups in Auth settings.
7. In SQL Editor, allowlist that Auth user by running the following after replacing the email:
   \`\`\`sql
   insert into public.admin_users (user_id)
   select id from auth.users where email = 'YOUR_ADMIN_EMAIL'
   on conflict (user_id) do nothing;
   \`\`\`
8. Set \`adminEmail\` in \`config.js\` to that same email and set the chosen \`adminUsername\`.
9. Serve the folder with any static server, or use the VS Code Live Server extension. For example, if Python is installed, run \`python3 -m http.server 8000\` and open http://localhost:8000.

## What's included

- Public video finder with function area, task, tool, and keyword filters.
- 90 mock catalogue entries generated from 10 function areas × 3 tasks × 3 tool variants.
- Watch buttons open YouTube search results for the chosen tool and task. The entries are mock recommendations, not individually verified videos.
- Admin dashboard: selection counts, category usage, popular videos, never-selected videos, recent events, and CSV export.
- Shared analytics stored in Supabase. No visitor names or emails are collected.

## Security notes

- The username is a convenience login identifier. Supabase Auth verifies the password.
- **Database authorization is enforced by Row Level Security (RLS)**. Only authenticated accounts whose Auth UUID is in \`admin_users\` can read analytics. Hiding the admin page is not the security boundary.
- Anonymous visitors can insert constrained event records, but cannot read, update, or delete analytics.
- The browser key is the publishable/anon key, which is designed for client use when RLS is correctly configured. Never expose the Supabase \`service_role\` key, a database password, or a personal access token.
- The insert policy constrains event fields but does not implement robust anti-abuse rate limiting. Before high-traffic production use, route writes through a Supabase Edge Function with rate limits and bot controls.
- Analytics are event counts, not unique-user counts.
- \`config.js\` contains project identifiers and the admin email/username only; the password is entered at login and is never stored in the repository.

## Deploy

Deploy the static files to a static host. Add \`config.js\` as a deployed static file with your project URL, publishable key, admin username, and admin email. Configure allowed Auth redirect URLs for your deployed domain in Supabase. Apply the SQL migration to the correct project before using the admin screen.