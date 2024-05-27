/datum/armor/object
	abstract_type = /datum/armor/object

/datum/armor/object/default
	melee_deflect = 5
	melee_tier = ARMOR_BARELY_BEATS(MELEE_TIER_LIGHT)
	melee = 0.1

/datum/armor/object/light
	melee_deflect = 5
	melee_tier = ARMOR_BARELY_BEATS(MELEE_TIER_LIGHT)
	melee = 0.1

/datum/armor/object/medium
	melee_deflect = 10
	melee_tier = ARMOR_BARELY_BEATS(MELEE_TIER_MEDIUM)
	melee = 0.25

/datum/armor/object/heavy
	melee_deflect = 18
	melee_tier = ARMOR_BARELY_BEATS(MELEE_TIER_HEAVY)
	melee = 0.4
