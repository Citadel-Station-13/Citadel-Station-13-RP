//*                                            Runlevels                                          *//
//*             Must be powers of 2. Runlevels should be in order of progression.                 *//
//*             Only subsystem with a runlevel matching the MC's will be ticked.                  *//
//* The first runlevel (value '1') will be the default runlevel when the MC is first initialized. *//

/// "Initialize Only" - Used for subsystems that should never be fired (Should also have SS_NO_FIRE set).
#define RUNLEVEL_INIT     0
/// Initial runlevel before setup.  Returns to here if setup fails.
#define RUNLEVEL_LOBBY    1
/// While the gamemode setup is running.  I.E gameticker.setup()
#define RUNLEVEL_SETUP    2
/// After successful game ticker setup, while the round is running.
#define RUNLEVEL_GAME     4
/// When round completes but before reboot.
#define RUNLEVEL_POSTGAME 8

/// default runlevels for most subsystems
#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)
/// all valid runlevels - subsystems with this will run all the time after their MC init stage.
#define RUNLEVELS_ALL (RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)

var/global/list/runlevel_flags = list(RUNLEVEL_LOBBY, RUNLEVEL_SETUP, RUNLEVEL_GAME, RUNLEVEL_POSTGAME)
/// Convert from the runlevel bitfield constants to index in runlevel_flags list.
#define RUNLEVEL_FLAG_TO_INDEX(flag) (log(2, flag) + 1)

DEFINE_BITFIELD(runlevels, list(
	BITFIELD(RUNLEVEL_INIT),
	BITFIELD(RUNLEVEL_LOBBY),
	BITFIELD(RUNLEVEL_SETUP),
	BITFIELD(RUNLEVEL_GAME),
	BITFIELD(RUNLEVEL_POSTGAME),
))
