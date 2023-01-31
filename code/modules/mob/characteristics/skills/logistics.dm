/datum/characteristic_skill/logistics
	abstract_type = /datum/characteristic_skill/logistics
	category = "Logistics"

/**
 * Salvage: mining, etc
 *
 * Implementation status: not started
 */
/datum/characteristic_skill/logistics/salvage
	id = "salvage"
	name = "Salvage"
	desc = "How experienced you are with salvaging and mining. Each level provides additional boosts to mining equipment speed and efficiency."
	desc_untrained = "Hitting rocks is unskilled labor, and you are the unskilled labor."
	desc_novice = "You have been mining, or salvagingfor a while. Kinetic weaponry and other tooling now have less recoil."
	desc_trained = "You are a trained miner. Drills and other equipment you set gain a small speed boost, if configured by you."
	desc_experienced = "You're a space salvager. Some EVA skill boosts apply to you as well. You gain very slightly higher ore yields while mining."
	desc_professional = "They said robots can replace you, but clearly, they were wrong. Kinetic tooling can now be used by you with almost no one-handing penalties, and you can use some equipment meant for two people by yourself efficiently."
	cost_novice = SKILLCOST_INCREMENT_MINOR
	cost_trained = SKILLCOST_INCREMENT_MINOR
	cost_experienced = SKILLCOST_INCREMENT_MAJOR
	cost_professional = SKILLCOST_INCREMENT_MAJOR

/**
 * Logistics: cargo, etc
 *
 * Implementation status: not started
 */
/datum/characteristic_skill/logistics/cargo
	id = "cargo"
	name = "Logistics"
	desc = "How experienced you are running logistics, deck supply, etc."
	desc_untrained = "Surely pushing crates and signing off on orders is easy. Right? Right?!"
	desc_novice = "You've been doing logistics for a while. Crates can now be moved at full speed."
	desc_trained = "You have been trained in logistics. Crates can now fit more when you pack them. Price scanners and other scanners may now be used at range."
	desc_experienced = "You're a master at running a shipyard, or logistics deck. You now automatically negate certain penalties for not labelling crates when exporting. Work mechas now move and operates faster for you. You can intuit the prices of most objects at a glance."
	cost_novice = SKILLCOST_INCREMENT_MODERATE
	cost_trained = SKILLCOST_INCREMENT_MODERATE
	cost_experienced = SKILLCOST_INCREMENT_MAJOR
