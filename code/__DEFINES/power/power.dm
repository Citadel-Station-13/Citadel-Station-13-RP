//? Power channels for areas - Make sure these are in sync.

#define POWER_CHANNEL_EQUIP 1
#define POWER_CHANNEL_LIGHT 2
#define POWER_CHANNEL_ENVIR 3

#define POWER_CHANNEL_COUNT 3

#define POWER_BIT_EQUIP (1<<0)
#define POWER_BIT_LIGHT (1<<1)
#define POWER_BIT_ENVIR (1<<2)

#define POWER_BITS_ALL (POWER_CHANNEL_EQUIP | POWER_CHANNEL_LIGHT | POWER_CHANNEL_ENVIR)

/// length must equal POWER_CHANNEL_COUNT
GLOBAL_REAL_LIST(power_channel_names) = list(
	"Equipment",
	"Lighting",
	"Environmental",
)

/// length must equal POWER_CHANNEL_COUNT
GLOBAL_REAL_LIST(power_channel_bits) = list(
	POWER_BIT_EQUIP,
	POWER_BIT_LIGHT,
	POWER_BIT_ENVIR,
)

/// length must equal POWER_CHANNEL_COUNT
#define EMPTY_POWER_CHANNEL_LIST list(0, 0, 0)
