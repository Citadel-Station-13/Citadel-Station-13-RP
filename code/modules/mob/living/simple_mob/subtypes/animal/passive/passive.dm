// Passive mobs can't attack things, and will run away instead.
// They can also be displaced by all mobs.
/mob/living/simple_mob/animal/passive
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/passive
	mob_bump_flag = 0
	iff_factions = list(
		MOB_IFF_FACTION_NEUTRAL,
		MOB_IFF_FACTION_FARM_PET,
	)
