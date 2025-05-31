//? attack_type bitfield - bitfield for check, but pass only one in at a time.

#define ATTACK_TYPE_NONE (0)
/// damage source is /datum/event_args/actor/clickchain
#define ATTACK_TYPE_MELEE (1<<0)
/// damage source is /obj/projectile
#define ATTACK_TYPE_PROJECTILE (1<<1)
/// damage source is /datum/thrownthing
#define ATTACK_TYPE_THROWN (1<<2)
/// damage source is /datum/event_args/actor/clickchain
#define ATTACK_TYPE_TOUCH (1<<4)
/// a damage instance created by a block / parry frame transmuting damage and passing it to the user
#define ATTACK_TYPE_DEFENSIVE_PASSTHROUGH (1<<5)
