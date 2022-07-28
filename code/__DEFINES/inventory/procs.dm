// flags for inventory ops
/// force
#define INV_OP_FORCE				(1<<0)
/// components that intercept to relocate should refrain - usually used with force
#define INV_OP_SHOULD_NOT_INTERCEPT	(1<<1)
/// no sound
#define INV_OP_SUPPRESS_SOUND		(1<<2)
/// no warnings
#define INV_OP_SUPPRESS_WARNING		(1<<3)
/// do not run logic like checking if you should drop something when something's unequipped
#define INV_OP_NO_LOGIC				(1<<4)
/// do not updatei cons
#define INV_OP_NO_UPDATE_ICONS		(1<<5)
/// hint: we are directly dropping to ground/off omb
#define INV_OP_DROPPING				(1<<6)
/// hint: we are re-equipping between slots
#define INV_OP_REEQUIPPING			(1<<7)
/// hint: we are doing this during outfit equip, antag creation, or otherwise roundstart operatoins
#define INV_OP_CREATION				(1<<8)
/// hint: we are chained through by an accessory's parent
#define INV_OP_IS_ACCESSORY			(1<<9)
/// no sound, warnings, etc, entirely
#define INV_OP_SILENT				(INV_OP_SUPPRESS_SOUND | INV_OP_SUPPRESS_WARNING)
