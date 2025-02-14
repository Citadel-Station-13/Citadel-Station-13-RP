///do not do anything after firing. Manual action, like pump shotguns, or guns that want to define custom behaviour
#define HOLD_CASINGS	0
///drop spent casings on the ground after firing
#define EJECT_CASINGS	2
///cycle casings, like a revolver. Also works for multibarrelled guns
#define CYCLE_CASINGS	3
//Gun loading types
///The gun only accepts ammo_casings. ammo_magazines should never have this as their mag_type.
#define SINGLE_CASING 	1
///Transfers casings from the mag to the gun when used.
#define SPEEDLOADER 	2
///The magazine item itself goes inside the gun
#define MAGAZINE 		4

// safety states
/// no safeties are on this gun
#define GUN_NO_SAFETY				-1
/// safety off
#define GUN_SAFETY_OFF				0
/// safety on
#define GUN_SAFETY_ON				1
