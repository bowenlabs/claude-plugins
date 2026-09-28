# Setting Up The Database

Before you start, please make sure the migrations have been applied by the deploy script.

## Running The Migrations

Simply run the migration script. It's easy:

```sh
corepack pnpm exec wrangler d1 migrations apply DB --local
```

The token is stored by the script in `.dev.vars`. Obviously, you should never commit that file.

To read more about migrations, click [here](https://developers.cloudflare.com/d1/reference/migrations/).
