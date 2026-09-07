# DPM Resignation Register — 2027 National General Election

An internal, staff-only tool for the Department of Personnel Management to
record public servants who resign to contest the 2027 National General
Election. Only logged-in DPM officers can view or add records — there is
no public sign-up and no public viewing.

This guide assumes you have never done this before. Follow it in order.

---

## Part 1 — Set up the live database (Supabase)

1. Go to **https://supabase.com** and click **Start your project**. Sign up
   (you can use your email or GitHub account).
2. Click **New project**. Give it a name like `dpm-resignation-register`,
   set a database password (save it somewhere safe), choose a region close
   to PNG (e.g. Singapore), and click **Create new project**. Wait ~2
   minutes while it provisions.
3. Once it's ready, go to the **SQL Editor** tab (left sidebar) and click
   **New query**. Open `schema.sql` from this folder, copy its entire
   contents, paste it into the editor, and click **Run**. This creates the
   `resignations` table and locks it down to logged-in staff only.
4. Go to **Settings > API** (left sidebar, gear icon). You'll see:
   - **Project URL** — looks like `https://xxxxx.supabase.co`
   - **anon public** key — a long string starting with `eyJ...`
   Copy both. You'll need them in Part 3.
5. Go to **Authentication > Users** and click **Add user > Create new
   user**. Add yourself first, with your real email and a password. Leave
   "Auto Confirm User" checked. This is your first staff login — repeat
   this step later for each authorized DPM officer. There is no public
   sign-up page, so this manual step is the only way anyone gets an
   account.

## Part 2 — Create the GitHub repository

1. Go to **https://github.com** and sign in (or sign up if you don't have
   an account).
2. Click the **+** icon (top right) > **New repository**.
3. Name it `dpm-resignation-register`, keep it **Public** (GitHub Pages'
   free tier requires a public repo — the *page* being public is fine,
   because the data itself is still locked behind staff login), and click
   **Create repository**.

## Part 3 — Connect the app to your database

1. Open `index.html` from this folder in any text editor (Notepad,
   VS Code, etc.).
2. Near the top, find these two lines:
   ```js
   const SUPABASE_URL = "PASTE_YOUR_SUPABASE_PROJECT_URL_HERE";
   const SUPABASE_ANON_KEY = "PASTE_YOUR_SUPABASE_ANON_KEY_HERE";
   ```
3. Replace the two placeholder strings with the Project URL and anon
   public key you copied in Part 1, step 4. Keep the quotation marks.
4. Save the file.

> The anon key is *meant* to be visible in a public webpage — it only
> lets someone talk to your database, and the Row Level Security
> policies from `schema.sql` are what actually decide whether they're
> allowed to see or change anything. Never paste your database
> **password** or **service role key** anywhere in this file.

## Part 4 — Upload the code to GitHub

On the GitHub repository page you created in Part 2, click
**uploading an existing file**, then drag in `index.html`,
`schema.sql`, and this `README.md`. Click **Commit changes**.

(If you're comfortable with the command line instead, from inside this
folder:)
```bash
git init
git add .
git commit -m "Initial version of resignation register"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/dpm-resignation-register.git
git push -u origin main
```

## Part 5 — Turn on GitHub Pages (go live)

1. In your repository, click **Settings** (top menu).
2. In the left sidebar, click **Pages**.
3. Under **Build and deployment > Source**, choose **Deploy from a
   branch**.
4. Under **Branch**, choose **main** and folder **/ (root)**, then
   **Save**.
5. Wait 1–2 minutes, then refresh the page. GitHub will show your live
   URL, something like:
   `https://YOUR-USERNAME.github.io/dpm-resignation-register/`

## Part 6 — Test it

1. Open the live URL.
2. Log in with the staff account you created in Part 1, step 5.
3. Add a test record, confirm it appears in the table below.
4. Log out and back in to confirm the login works as expected.
5. Once confirmed, go back to Supabase **Authentication > Users** and add
   an account for each real DPM officer who needs access. Delete the test
   record from the table once you're satisfied it works (edit its status
   to "Confirmed Resigned" or similar instead if you'd rather keep the
   audit trail).

---

## Making changes later

Any time you want to change the form fields, colours, or behaviour, edit
`index.html`, then upload the new version to GitHub the same way (or
`git add . && git commit -m "..." && git push`). GitHub Pages updates
automatically within a minute or two of a new push.

## A note on scope

This build is an **internal DPM tracking tool** — login required, no
public search. If DPM later needs this to feed into or align with the
PNG Electoral Commission's own candidate-nomination records (per the
Organic Law on National and Local-level Government Elections resignation
requirements), that's a separate integration/legal question worth raising
with your Reforms & Policy Branch leadership before any data is shared
outside DPM.
