// /obj/item/gun/var/magazine_type and /obj/item/ammo_box/var/magazine_type
#define SINGLE_CASING 	(1<<0)		//Can load single casings of the same caliber. Does nothing on ammo boxes.
#define SPEEDLOADER 	(1<<1)		//Compatible with speedloaders of the same caliber. Ammo boxes with this enabled can fill to guns with this enabled.
#define MAGAZINE 		(1<<2)		//Compatible with magazines of the same type (or any if null) and caliber. Ammo boxes with this enabled are considered a magazine. Defers to SPEEDLOADER.
#define INTERNAL_MAG	(1<<3)		//Denotes an ammo box as an INTERNAL MAGAZINE. For things like revolvers. Guns with this enabled won't let their internal magazine be ejected.

//Indicates an ammo casing isn't spent, rather just hasn't made its projectile yet.
#define PROJECTILE_UNINITIALIZED "UNINITIALIZED"

//Indiciates list is default compile time value - UNUSED, MIGHT BE USED FOR MORE COMPLEX LOGIC LATER.
#define MAGAZINE_USE_COMPILETIME

//Ammo flags
#define LIGHT_METAL					(1<<1)			//UNIMPLEMENTED - disables "heavy metal" shell bouncing effects from /tg/
#define NON_HARMFUL					(1<<2)			//is NOT a harmful ammo type
#define RANDOMSPREAD				(1<<3)			//spread is truly random rather than normalized

//Magazine ammo_left()
#define MAGAZINE_COUNT_ALL		0
#define MAGAZINE_COUNT_LIVE		1
#define MAGAZINE_COUNT_SPENT	2

//Magazine types
#define MAGAZINE_TYPE_DEFAULT "DEFAULT"

//gun/energy use_external_power
#define ENERGY_GUN_EXTERNAL_DIRECT		1		//Directly use external power
#define ENERGY_GUN_EXTERNAL_CHARGE		2		//Use external power to charge during processing/selfcharging.

//gun/energy show_cell_charge
#define ENERGY_GUN_SHOT_SHOTS			1		//show shots left on examine
#define ENERGY_GUN_SHOW_CHARGE			2		//cell charge

//Calibers
#define CALIBER_ENERGY				"ENERGY"		//energy "lens" virtual casings for energy weapons.
#define CALIBER_357					".357"




