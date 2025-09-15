# Dev Database Setup Tool

Requires Python 3.12+

Sets up a database for use in development, automatically downloading a portable version of MariaDB and Flyway as needed.

Only works on windows right now, if you're on linux you should know how to set up a database.

## What this is not for.

This is **not** for developing the database.

This sounds counterintuitive, but this script pretty much just blindly runs migrations. If a migration fails, there's nothing it can do about it unless there's an undo migration (which is usually not the case).

## WARNING

**Do not, under any circumstances, use or attempt to modify this tool to run in production.**

If you do, and you get breached / bad things happen, I will not provide any help or condolences. This is purely a dev tool. **It is the responsibility of the server owner to set up a proper production database and to maintain it.**

## Defaults

* The default root password is set to `password`.
* The default database is not secured at all.

## License

This entire folder is under the MIT license.

The bootstrap system used to run Python, however, is under AGPL, as it's from /tg/.
