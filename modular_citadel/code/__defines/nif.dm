//Allows an NIF to do things it otherwise wouldn't, used as bitfield. Zeroes are disabled.
#define NIF_FORCE_DELETE			0
#define NIF_FORCE_INSTALL			1<<1
#define NIF_IGNORE_RESTRICTIONS		0<<2

//How many times the regular durability it costs to install a NIFSoft on a "bioadaptive" species.
#define NIF_BIOADAPTIVE_MULTIPLIER	1
