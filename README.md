# freeCodeCamp World Cup Database

PostgreSQL schema, data importer, and reporting queries for the freeCodeCamp Relational Databases certification project.

## Files

- `worldcup.sql` recreates the `worldcup` database and its tables and data.
- `insert_data.sh` imports the game data from `games.csv` into `teams` and `games`.
- `queries.sh` runs the project statistics and reports.

## Run

Restore the database with `psql -U postgres < worldcup.sql`, then run `./queries.sh` as the `freecodecamp` PostgreSQL user. `insert_data.sh` is included to rebuild the data from the course-provided `games.csv`.

The project scripts passed the freeCodeCamp CodeRoad checks; `queries.sh` also matched `expected_output.txt` exactly.
