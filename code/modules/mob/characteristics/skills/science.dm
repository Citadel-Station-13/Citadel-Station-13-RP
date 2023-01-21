/datum/characteristic_skill/science
	abstract_type = /datum/characteristic_skill/science
	category = "Research"

/**
 * R&D / Anomalies / Tech
 *
 * Implementation status: Not started
 */
/datum/characteristic_skill/science/devices
	id = "devices"
	name = "Complex Devices"
	desc = "Your ability to fabricate, utilize, maintain, and analyze complex machinery."
	#warn impl

/**
 * Robolimbs / Cyborgs / Cybernetics
 *
 * Implementation status: Not started
 */
/datum/characteristic_skill/science/robotics
	id = "robotics"
	name = "Robotics"
	desc = "Your ability to build and maintain prosthetics, synthetics, and robots in general. Each level gives slight increases in repair rate, as well as fabrication rate for related machinery."
	desc_untrained = "Building a robot for you is like trying to put together a replica model brick set with no manual. Or with a manual, in this case. No active bonuses."
	desc_novice = "You have had some experience with synthetics and related technologies. Repair efficiency is boosted as well as speed from here on out."
	desc_trained = "You are trained to assemble synthetics and robotic platforms with ease. Prosthetic surgeries can be safely done at this level without surgical suites, or skills. Surgeries will be automatically boosted from here on out regardless of surgery skill."
	desc_experienced = "You have spent a good deal of your life dealing with synthetics. Prosthetic surgeries are further tuned, and cybernetics you install start out optimized. You can now operate cyborg wiring panels without testing for wires. All parts you construct gain temporary bonuses."
	desc_professional = "You are a master roboticist. You can now overclock prosthetics and cybernetics to boost them for their user for hours, or even days at a time. Prosthetics surgeries are second nature to you, regardless of your anatomical knowledge."
	cost_novice = SKILLCOST_INCREMENT_MINOR
	cost_trained = SKILLCOST_INCREMENT_MINOR
	cost_experienced = SKILLCOST_INCREMENT_MAJOR
	cost_professional = SKILLCOST_INCREMENT_MAJOR

/**
 * Mechs / Rigsuits
 *
 * Implementation status: Not started
 */
/datum/characteristic_skill/science/mecha
	id = "mecha"
	name = "Mechatronics"
	desc = "Your ability to pilot and maintain exosuits, as well as powered hardsuits. Each level gives benefits to repair speed and efficiency (diminishing returns)."
	desc_untrained = "Piloting a mech is just like a really big hardsuit, right? What even is a hardsuit?"
	desc_novice = "You have had some practice with mechatronics. You can probably maintain one without a manual now. Hardsuit deployment speed, hardware installation speed, and mecha enter/exit speeds boosted."
	desc_trained = "You are a trained mechatronic engineer, or an experienced operator. Speeds further boosted. Mecha can now natively strafe at full speed with you at the helm (adds automatic face-cursor mode)."
	desc_experienced = "You spend a great deal of time working with powered suits. Mecha now suffer less movement cost and recoil with you at the helm. You can salvage more parts out of destroyed mecha."
	max_value = CHARACTER_SKILL_EXPERIENCED
	cost_novice = SKILLCOST_INCREMENT_MINOR
	cost_trained = SKILLCOST_INCREMENT_MODERATE
	cost_experienced = SKILLCOST_INCREMENT_MODERATE

/**
 * biology: xenobiology, genetics, nanoswarms, etc
 */
/datum/characteristic_skill/medical/biology
	id = "biotech"
	name = "Biotechnology"
	desc = "How well you understand biology, genetics, xeno-lifeform research, nanoswarms, and anything else relating to weird life sciences."

	#warn impl
