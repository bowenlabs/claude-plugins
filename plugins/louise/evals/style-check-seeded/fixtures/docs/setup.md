# Setting Up The Database

Before you start, please make sure the migrations have been applied by the deploy script.

## Running The Migrations

Simply run the migration script. It's easy — it takes a few seconds:

```sh
corepack pnpm exec wrangler d1 migrations apply DB --local
```

The token is stored by the script in `.dev.vars`. Obviously, you should never commit that file.

After the migration, the new page appears in the admin as Setup — Acme Coffee Co. admin. If it doesn't, email support@acmecoffee.com or call 555-123-4567.

To read more about migrations, click [here](https://developers.cloudflare.com/d1/reference/migrations/).
