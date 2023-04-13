
/*
Remember to update _globalvars/traits.dm if you're adding/removing/renaming traits.
*/

//mob traits
#define TRAIT_BLIND 			"blind"
#define TRAIT_MUTE				"mute"

#define TRAIT_DEAF				"deaf"

///Tracks whether we're gonna be a baby alien's mummy.
#define TRAIT_XENO_HOST			"xeno_host"

/// cannot be pushed out of the way by mob movement
#define TRAIT_PUSHIMMUNE		"push_immunity"

#define TRAIT_ANTIMAGIC			"anti_magic"
#define TRAIT_HOLY				"holy"
#define TRAIT_AI_PAUSE_AUTOMATED_MOVEMENT "ai_pause_movement"

#define TRAIT_DISRUPTED			"disrupted"

/// CPR was done already; CPR is less effective
#define TRAIT_CPR_COOLDOWN "cpr_cooldown"
/// someone is already doing CPR on us
#define TRAIT_CPR_IN_PROGRESS "cpr_in_progress"
/// Something is currently preventing normal respiratory failure
#define TRAIT_MECHANICAL_VENTILATION "mechanical_ventilatin"
/// Something currently preventing normal circulatory failure
#define TRAIT_MECHANICAL_CIRCULATION "mechanical_circulation"
/// this organ (and all organs in it if applied on an external organ) is preserved
#define TRAIT_ORGAN_PRESERVED "organ_preserved"
/// preserve all organs in us
#define TRAIT_PRESERVE_ALL_ORGANS "preserve_organs"
