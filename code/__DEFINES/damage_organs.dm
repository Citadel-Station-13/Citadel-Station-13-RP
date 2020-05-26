//aaa should this be in atmospherics.dm or here???
#define FIRE_DAMAGE_MODIFIER 0.0215 // Higher values result in more external fire damage to the skin. (default 0.0215)
#define  AIR_DAMAGE_MODIFIER 2.025  // More means less damage from hot air scalding lungs, less = more damage. (default 2.025)

// Organ defines.
#define ORGAN_CUT_AWAY   (1<<0)
#define ORGAN_BLEEDING   (1<<1)
#define ORGAN_BROKEN     (1<<2)
#define ORGAN_DESTROYED  (1<<3)
#define ORGAN_DEAD       (1<<4)
#define ORGAN_MUTATED    (1<<5)

#define DROPLIMB_EDGE 0
#define DROPLIMB_BLUNT 1
#define DROPLIMB_BURN 2

// Damage above this value must be repaired with surgery.
#define ROBOLIMB_REPAIR_CAP 30

#define ORGAN_FLESH    0 // Normal organic organs.
#define ORGAN_ASSISTED 1 // Like pacemakers, not robotic
#define ORGAN_ROBOT    2 // Fully robotic, no organic parts
#define ORGAN_LIFELIKE 3 // Robotic, made to appear organic
#define ORGAN_NANOFORM 4 // VOREStation Add - Fully nanoswarm organ

//Germs and infections.
#define GERM_LEVEL_AMBIENT  30 // Maximum germ level you can reach by standing still.		//CITADEL CHANGE - reduces this value from 110 to 30 to make infections harder to get
#define GERM_LEVEL_MOVE_CAP 110 // Maximum germ level you can reach by running around.	//CITADEL CHANGE - reduces this value from 200 to 110 to make infections harder to get

#define INFECTION_LEVEL_ONE   100
#define INFECTION_LEVEL_TWO   500
#define INFECTION_LEVEL_THREE 1000
#define INFECTION_LEVEL_MAX   1500
