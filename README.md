## Citadel Station 13 RP

[![Build Status](https://github.com/Citadel-Station-13/Citadel-Station-13-RP/workflows/CI%20Suite/badge.svg)](https://github.com/Citadel-Station-13/Citadel-Station-13-RP/actions?query=workflow%3A%22CI+Suite%22)
[![Percentage of issues still open](https://isitmaintained.com/badge/open/Citadel-Station-13/Citadel-Station-13-RP.svg)](https://isitmaintained.com/project/Citadel-Station-13/Citadel-Station-13-RP "Percentage of issues still open")
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/Citadel-Station-13/Citadel-Station-13-RP.svg)](https://isitmaintained.com/project/Citadel-Station-13/Citadel-Station-13-RP "Average time to resolve an issue")

[![forthebadge](http://forthebadge.com/images/badges/60-percent-of-the-time-works-every-time.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/compatibility-club-penguin.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/no-ragrets.svg)](http://forthebadge.com) [![forinfinityandbyond](https://user-images.githubusercontent.com/5211576/29499758-4efff304-85e6-11e7-8267-62919c3688a9.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

* **Website:** <http://citadel-station.net>
* **Code:** <https://github.com/Citadel-Station-13/Citadel-Station-13-RP>
* **Wiki:** <https://citadel-station.net/wiki/index.php?title=Main_Page>
* **Forums:** <http://citadel-station.net/forum>
* **Ban Appeals:** <http://citadel-station.net/forum/forumdisplay.php?fid=8>
* **Discord:**  <https://discord.gg/citadelstation>

This is the codebase for the CitadelRP flavoured fork of SpaceStation 13.

Citadel Station 13 RP, also known as CitadelRP was originally a fork of VOREStation, which separated on 01/25/2019.

## DOWNLOADING
[Downloading](.github/guides/DOWNLOADING.md)

## :exclamation: How to compile :exclamation:

On **May 9, 2022** we have changed the way to compile the codebase.

**The quick way**. Find `bin/server.cmd` in this folder and double click it to automatically build and host the server on port 1337.

**The long way**. Find `bin/build.cmd` in this folder, and double click it to initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile. If it closes, it means it has finished its job. You can then [setup the server](.github/RUNNING_A_SERVER.md) normally by opening `tgstation.dmb` in DreamDaemon.

**Building CitadelRP in DreamMaker directly is now deprecated and might produce errors**, such as `'tgui.bundle.js': cannot find file`.

**[How to compile in VSCode and other build options](tools/build/README.md).**

## Contributors
[Guides for Contributors](.github/CONTRIBUTING.md)

[CitadelRP HACKMD account](https://hackmd.io/@CitadelStation13RP)

## SQL Setup

The SQL backend for the library and stats tracking requires a MySQL server.
Your server details go in /config/legacy/dbconfig.txt, and the SQL schema is in /SQL/tgstation_schema.sql.
More detailed setup instructions arecoming soon, for now ask in our Discord.

## LICENSE

The code for VOREStation is licensed under the [GNU AGPL v3](http://www.gnu.org/licenses/agpl-3.0.html).

All code with a git authorship date after `1420675200 +0000` (2015/01/08 00:00) is assumed to be licensed under [GNU AGPL v3](http://www.gnu.org/licenses/agpl-3.0.html).

All code with a git authorship date before `1420675200 +0000` (2015/01/08 00:00) are licensed under the [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
If you wish to license under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html) please make this clear in the commit message and any added files.

If you wish to develop and host this codebase in a closed source manner you may use all code prior to `1420675200 +0000` (2015/01/08 00:00), which is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html). The major change here is that if you host a server using any code licensed under [GNU AGPL v3](http://www.gnu.org/licenses/agpl-3.0.html) you are required to provide full source code for your servers users as well including addons and modifications you have made.

See LICENSE, LICENSE-GPL3.txt and LICENSE-AGPL3.txt for more details.

The TGS DMAPI API is licensed as a subproject under the MIT license.

See the footer of [code/__DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) and [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE) for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
