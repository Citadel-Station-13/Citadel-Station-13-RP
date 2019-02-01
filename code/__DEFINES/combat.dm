//We will round to this value in damage calculations.
#define DAMAGE_PRECISION 0.1

//bullet_act() return values
#define BULLET_ACT_HIT				"HIT"		//It's a successful hit, whatever that means in the context of the thing it's hitting.
#define BULLET_ACT_BLOCK			"BLOCK"		//It's a blocked hit, whatever that means in the context of the thing it's hitting.
#define BULLET_ACT_MISS				"MISS"		//Automatic miss
#define BULLET_ACT_FORCE_PIERCE		"PIERCE"	//It pierces through the object regardless of the bullet being piercing by default.
#define BULLET_ACT_TURF				"TURF"		//It hit us but it should hit something on the same turf too. Usually used for turfs.

//Gun silencing
#define PROJECTILE_SILENCE_NONE			0	//No silencing
#define PROJECTILE_SILENCE_NORMAL			1	//Silences firing message
#define PROJECTILE_SILENCE_FULL			2	//For abstract projectiles, shows no messages whatsoever
