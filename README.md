## Citadel Station 13 - RP Server

[![Build Status](https://travis-ci.org/Citadel-Station-13/Citadel-Station-13-RP.png)](https://travis-ci.org/Citadel-Station-13/Citadel-Station-13-RP)
[![Percentage of issues still open](https://isitmaintained.com/badge/open/Citadel-Station-13/Citadel-Station-13-RP.svg)](https://isitmaintained.com/project/Citadel-Station-13/Citadel-Station-13-RP "Percentage of issues still open")
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/Citadel-Station-13/Citadel-Station-13-RP.svg)](https://isitmaintained.com/project/Citadel-Station-13/Citadel-Station-13-RP "Average time to resolve an issue")

[![forthebadge](http://forthebadge.com/images/badges/60-percent-of-the-time-works-every-time.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/compatibility-club-penguin.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/no-ragrets.svg)](http://forthebadge.com) [![forinfinityandbyond](https://user-images.githubusercontent.com/5211576/29499758-4efff304-85e6-11e7-8267-62919c3688a9.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

**Upstream Information**
* **Code:** <https://github.com/VOREStation/VOREStation>

**Citadel Station RP Information**
* **Website:** <http://citadel-station.net>
* **Code:** <https://github.com/Citadel-Station-13/Citadel-Station-13-RP>
* **Wiki:** <https://citadel-station.net/wiki/index.php?title=Main_Page>
* **Forums:** <http://citadel-station.net/forum>
* **Ban Appeals:** <http://citadel-station.net/forum/forumdisplay.php?fid=8>
* **Discord:**  <https://discord.gg/E6SQuhz>

Going to make a Pull Request? Make sure you read the [CONTRIBUTING.md](.github/CONTRIBUTING.md) first!

Citadel Station 13 - RP was originally a fork of VOREStation, which separated on 01/25/2019. VOREStation is a fork of the Polaris code branch, itself a fork of the Baystation12 code branch, for the game Space Station 13.

## DOWNLOADING

There are a number of ways to download the source code. Some are described here.

Option 1: The more complicated and easier to update method is using git.
You'll need to download git or some client from [here](http://git-scm.com/).
When that's installed, right click in any folder and click on "Git Bash".
When that opens, type in:

```
git clone https://github.com/Citadel-Station-13/Citadel-Station-13-RP.git
```

(hint: hold down ctrl and press insert to paste into git bash)
This will take a while to download, but it provides an easier method for updating.

Option 2: Download the source code as a zip by clicking the ZIP button in the
code tab of <https://github.com/Citadel-Station-13/Citadel-Station-13-RP>
(note: this will use a lot of bandwidth if you wish to update and is a lot of
hassle if you want to make any changes at all, so it's not recommended.)

## INSTALLATION

First-time installation should be fairly straightforward. First, you'll need
BYOND installed. You can get it from <https://secure.byond.com/download>. Once you've done
that, extract the game files to wherever you want to keep them. This is a
sourcecode-only release, so the next step is to compile the server files.
Open vorestation.dme by double-clicking it, open the Build menu, and click
compile. This'll take a little while, and if everything's done right you'll get
a message like this:

```
saving vorestation.dmb (DEBUG mode)
vorestation.dmb - 0 errors, 0 warnings
```

If you see any errors or warnings, something has gone wrong - possibly a corrupt
download or the files extracted wrong. If problems persist, ask for assistance on IRC.

Once that's done, open up the config folder. You'll want to edit config.txt to
set the probabilities for different gamemodes in Secret and to set your server
location so that all your players don't get disconnected at the end of each
round. It's recommended you don't turn on the gamemodes with probability 0,
except Extended, as they have various issues and aren't currently being tested,
so they may have unknown and bizarre bugs.

You'll also want to edit config/admins.txt to remove the default admins and add
your own. "Host" is the highest level of access, and probably the one
you'll want to use for now. You can set up your own ranks and find out more in
config/admin_ranks.txt

The format is

```
byondkey = Rank
```

where the BYOND key must be in lowercase and the admin rank must be properly
capitalised. There are a bunch more admin ranks, but these two should be
enough for most servers, assuming you have trustworthy admins.

Finally, to start the server, run Dream Daemon and enter the path to your
compiled vorestation.dmb file. Make sure to set the port to the one you
specified in the config.txt, and set the Security box to 'Safe'. Then press GO
and the server should start up and be ready to join. It is also recommended that
you set up the SQL backend (see below).

## UPDATING

To update an existing installation, first back up your /config and /data folders
as these store your server configuration, player preferences and banlist.

Then, extract the new files (preferably into a clean directory, but updating in
place should work fine), copy your /config and /data folders back into the new
install, overwriting when prompted except if we've specified otherwise, and
recompile the game.  Once you start the server up again, you should be running
the new version.

If you used the git method, you simply need to type this in to git bash:
```
git pull
```
When you have done this, you'll need to recompile the code, but then it should work fine.

## Configuration

For a basic setup, simply copy every file from config/example to config.

## SQL Setup

The SQL backend for the library and stats tracking requires a MySQL server.
Your server details go in /config/dbconfig.txt, and the SQL schema is in /SQL/tgstation_schema.sql.
More detailed setup instructions arecoming soon, for now ask in our Discord.

## CONTRIBUTING

Please see [CONTRIBUTING.md](.github/CONTRIBUTING.md)

## LICENSE

The code for VOREStation is licensed under the [GNU AGPL v3](http://www.gnu.org/licenses/agpl-3.0.html).

All code with a git authorship date after `1420675200 +0000` (2015/01/08 00:00) is assumed to be licensed under [GNU AGPL v3](http://www.gnu.org/licenses/agpl-3.0.html).

All code with a git authorship date before `1420675200 +0000` (2015/01/08 00:00) are licensed under the [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
If you wish to license under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html) please make this clear in the commit message and any added files.

If you wish to develop and host this codebase in a closed source manner you may use all code prior to `1420675200 +0000` (2015/01/08 00:00), which is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html). The major change here is that if you host a server using any code licensed under [GNU AGPL v3](http://www.gnu.org/licenses/agpl-3.0.html) you are required to provide full source code for your servers users as well including addons and modifications you have made.

See LICENSE, LICENSE-GPL3.txt and LICENSE-AGPL3.txt for more details.

tgui clientside is licensed as a subproject under the MIT license.
Font Awesome font files, used by tgui, are licensed under the SIL Open Font License v1.1
tgui assets are licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
