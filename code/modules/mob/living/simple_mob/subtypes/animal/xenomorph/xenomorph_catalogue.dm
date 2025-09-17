/datum/category_item/catalogue/fauna/feral_xenomorph
	name = "Feral Xenomorph"
	desc = "Xenomorphs are a widely recognized and rightfully feared scourge \
	across the Frontier. Some Xenomorph hives lose a connection to the greater \
	Hive structure, and become less coordinated, though no less dangerous. \
	Kill on sight."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/feral_xenomorph)

// Obtained by scanning all Xenomorphs.
/datum/category_item/catalogue/fauna/all_feral_xenomorphs
	name = "Collection - Feral Xenomorphs"
	desc = "You have scanned a large array of different types of Xenomorph, \
	and therefore you have been granted a large sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_SUPERHARD
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/feral_xenomorph/warrior,
		/datum/category_item/catalogue/fauna/feral_xenomorph/drone,
		/datum/category_item/catalogue/fauna/feral_xenomorph/spitter,
		/datum/category_item/catalogue/fauna/feral_xenomorph/vanguard,
		/datum/category_item/catalogue/fauna/feral_xenomorph/monarch,
		)

/datum/category_item/catalogue/fauna/feral_xenomorph/warrior
	name = "Feral Xenomorph - Warrior"
	desc = "Warriors serve as the primary combat caste within a Hive Structure, while having fewer numbers than the endless drone hordes, they are none-the-less extremely formidable. "
	value = CATALOGUER_REWARD_MEDIUM

/datum/category_item/catalogue/fauna/feral_xenomorph/drone
	name = "Feral Xenomorph - Drone"
	desc = "The adult form of the Xenomorph, the drone's iconic \
	morphology and biological traits make it easily identifiable across \
	the Frontier. Feared for its prowess, the Drone is a sign that an even \
	larger threat is present: a Xenomorph Hive. When their connection to the \
	Hive has been disrupted, Drones exhibit less construction activity and \
	revert to a defensive Kill on sight."
	value = CATALOGUER_REWARD_EASY

/datum/category_item/catalogue/fauna/feral_xenomorph/spitter
	name = "Feral Xenomorph - Spitter"
	desc = "Spitters serve as defensive units for the Hive. Possessing \
	a powerful neurotoxic venom, Spitters are able to spit this toxin at \
	range with alarming accuracy and control. Designed to repel assaults, \
	the Spitter serves the dual purpose of weakening aggressors so they may \
	be more easily collected to host future generations. When disconnected \
	from the Hive, Spitter behavior remains almost exactly the same. Kill \
	on sight."
	value = CATALOGUER_REWARD_MEDIUM

/datum/category_item/catalogue/fauna/feral_xenomorph/vanguard
	name = "Feral Xenomorph - Vanguard"
	desc = "The Xenomorph Vanguard is not often seen amongst \
	standard Xeno incursions. Spawned in large Hives to serve as \
	bodyguards to a Monarch, the Vanguard clade are powerful, and \
	nightmarishly effective in close combat. Spotting a Vanguard in \
	the field is often grounds to call for an immediate withdrawal and \
	orbital bombardment. On the rare occasions where Vanguard are \
	cut off from the greater Hive, they remain formidable foes and will \
	die to protect their Monarch. Kill on sight."
	value = CATALOGUER_REWARD_MEDIUM

/datum/category_item/catalogue/fauna/feral_xenomorph/monarch
	name = "Feral Xenomorph - Monarch"
	desc = "When a Drone reaches a certain level of maturity, she may \
	evolve into a Monarch, if there is no functioning Hive nearby. The Monarch \
	is erroneously considered the ultimate end point of Xenomorph evolution. \
	The Monarch is responsible for laying eggs, which will spawn more Facehuggers, \
	and therefore eventually more Xenomorphs. As such, she bears a significant \
	strategic value to the Hive, and will be defended ferociously. Monarchs are \
	imbued with substantial psionic power which lets them direct their Hive, but \
	when they are cut off from the larger Xenomorph Hivemind, they may experience \
	a form of shock which reverts them into a Drone's mindstate. Kill on sight. "
	value = CATALOGUER_REWARD_SUPERHARD
