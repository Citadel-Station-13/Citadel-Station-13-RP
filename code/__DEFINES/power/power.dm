//? Power channels for areas - Make sure these are in sync.

#define POWER_CHANNEL_EQUIP 1
#define POWER_CHANNEL_LIGHT 2
#define POWER_CHANNEL_ENVIR 3

#define POWER_CHANNELS_ALL (POWER_CHANNEL_EQUIP | POWER_CHANNEL_LIGHT | POWER_CHANNEL_ENVIR)

#define POWER_BIT_EQUIP (1<<0)
#define POWER_BIT_LIGHT (1<<1)
#define POWER_BIT_ENVIR (1<<2)

#define POWER_CHANNEL_COUNT 3

GLOBAL_REAL_LIST(power_channel_names) = list(
	"Equipment",
	"Lighting",
	"Environmental",
)
