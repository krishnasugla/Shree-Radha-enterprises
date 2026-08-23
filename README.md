# Shree Radhe Enterprises — Ledger

A standalone web app: one HTML file, a Postgres database on Supabase, hosted
as a static site. No server to run or maintain.

## 1. Create the Supabase project

1. Go to https://supabase.com → sign in → **New project**.
2. Pick any name/region, set a database password (save it somewhere — you
   won't need it for this app, but Supabase requires one).
3. Wait ~2 minutes for the project to finish provisioning.

## 2. Create the tables

1. In your Supabase project, open **SQL Editor** (left sidebar) → **New query**.
2. Paste the entire contents of `supabase_schema.sql` (included alongside
   this file) and click **Run**.
3. Confirm it worked: **Table Editor** in the sidebar should now show two
   tables, `bills` and `visits`.

## 3. Get your API credentials

1. In Supabase: **Project Settings** (gear icon) → **API**.
2. Copy the **Project URL** (looks like `https://xxxxxxxx.supabase.co`).
3. Copy the **anon public** key (a long string starting with `eyJ...`) —
   NOT the `service_role` key, that one must never go in client-side code.

## 4. Connect the app to your database

1. Open `Shree_Radhe_Ledger.html` in any text editor.
2. Find these two lines near the top of the `<script>` block:
```js
   const SUPABASE_URL = 'YOUR_SUPABASE_PROJECT_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_PUBLIC_KEY';
```
3. Replace the placeholder text with your actual Project URL and anon key
   from step 3, keeping the quotes. Save the file.

## 5. Push to GitHub

```bash
git init
git add Shree_Radhe_Ledger.html README.md supabase_schema.sql
git commit -m "Ledger app"
git branch -M main
git remote add origin https://github.com/<your-username>/<your-repo>.git
git push -u origin main
```
(Create the empty repo on GitHub first via **New repository** — don't
initialize it with a README there, to avoid a merge conflict with this one.)

## 6. Deploy it

Any static host works since this is a single HTML file. Two easy options:

**Vercel** (recommended, free)
1. Go to https://vercel.com → sign in with GitHub → **Add New → Project**.
2. Select your repo → **Deploy**. No build settings needed.
3. Vercel gives you a live URL (`your-project.vercel.app`) in under a minute.

**GitHub Pages** (also free, no separate account needed)
1. In your GitHub repo: **Settings → Pages**.
2. Under **Build and deployment**, set Source to **Deploy from a branch**,
   branch `main`, folder `/ (root)`. Save.
3. GitHub gives you a URL like `your-username.github.io/your-repo`.

Either way — once deployed, share that URL with whoever needs to use the
ledger. Everyone who opens it reads and writes the same Supabase database,
so it stays in sync across devices and people.

## Notes on how this works

- **No login system.** Anyone with the page URL can use it. If you need to
  restrict who can access it, that's a real feature to add (Supabase Auth),
  not a setting to flip — say the word if you need that.
- **The anon key is public by design** — it's meant to sit in client-side
  code. What keeps your data safe is the Row Level Security policy in
  `supabase_schema.sql`, not keeping the key secret. Don't ever put the
  `service_role` key in this file; that one bypasses RLS entirely.
- **Every edit saves straight to Supabase**, per row, ~400ms after you stop
  typing. There's no offline mode — if the internet drops, edits won't
  save silently; you'll see "Save failed" in the top-right status pill.
- To update the live site later, edit the HTML file, commit, and push —
  Vercel/GitHub Pages redeploy automatically on every push to `main`.
