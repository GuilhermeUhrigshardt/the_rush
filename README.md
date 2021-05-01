# theRush

Web application built with Elixir, Phoenix, LiveView and PostgreSQL to be used as part of the selective process for the Elixir Developer role at theScore.

## Requirements
The application was developed using:
* Elixir 1.11.2
* PostgreSQL 12.6
* npm 6.14.4

## Starting the application

The database is configured to use PostgreSQL's default username, password (both 'postgres'), database and hostname. If you wish to use other values, they can be changed at lines 5 - 8 of [`config/dev.exs`](/config/dev.exs).

Before creating the database, you may include additional JSON files to [`priv/repo/seeds`](priv/repo/seeds) folder. The [`rushing.json`](priv/repo/seeds/rushing.json) file is already there, but if you want to load more data, feel free to include other files (it must contain the same structure).

After this is done, run the following commands:
```shell
mix deps.get # fetch required dependencies
mix ecto.setup # create the database, run the migrations and feed it
mix phx.server # starts the local server
```

Finally, to use the application, open a browser and navigate to http://localhost:4000/
