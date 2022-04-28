/mob/living
	see_invisible = SEE_INVISIBLE_LIVING

	//* Health and life related vars *//
	/// Maximum health that should be possible.  Avoid adjusting this if you can, and instead use modifiers datums.
	var/maxHealth = 100
	/// A mob's health
	var/health = 100

	/// A mob's "class", e.g. human, mechanical, animal, etc. Used for certain projectile effects. See __defines/mob.dm for available classes.
	var/mob_class = null

	/// A list of all status effects the mob has
	var/list/status_effects

	//* Damage related vars *// NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	/// Brutal damage caused by brute force. (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	var/bruteloss = 0.0
	/// Oxygen depravation damage. (no air in lungs)
	var/oxyloss = 0.0
	/// Toxic damage caused by being poisoned or radiated.
	var/toxloss = 0.0
	/// Burn damage caused by being way too hot, too cold or burnt.
	var/fireloss = 0.0
	/// Damage caused by being cloned or ejected from the cloner early. slimes also deal cloneloss damage to victims.
	var/cloneloss = 0
	/// Damage caused by someone hitting you in the head with a bible or being infected with brainrot.
	var/brainloss = 0
	/// Hallucination damage. 'Fake' damage obtained through hallucinating or the holodeck. Sleeping should cause it to wear off.
	var/halloss = 0

	/// Directly affects how long a mob will hallucinate for
	var/hallucination = 0
	/// A list of hallucinated people that try to attack the mob. See /obj/effect/fake_attacker in hallucinations.dm
	var/list/atom/hallucinations = list()

	/// Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.
	var/last_special = 0
	var/base_attack_cooldown = DEFAULT_ATTACK_COOLDOWN

	var/t_phoron = null
	var/t_oxygen = null
	var/t_sl_gas = null
	var/t_n2 = null

	var/now_pushing = null
	var/mob_bump_flag = 0
	var/mob_swap_flags = 0
	var/mob_push_flags = 0
	var/mob_always_swap = 0

	var/mob/living/cameraFollow = null
	var/list/datum/action/actions = list()

	/// Time of death
	var/tod = null
	var/update_slimes = 1
	/// Can't talk. Value goes down every life proc.
	var/silent = null
	/// The "Are we on fire?" var
	var/on_fire = FALSE
	var/fire_stacks = 0

	/// This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.
	var/failed_last_breath = 0
	var/lastpuke = 0

	/// Makes attacks harder to land. Negative numbers increase hit chance.
	var/evasion = 0
	/// If true, the mob runs extremely fast and cannot be slowed.
	var/force_max_speed = FALSE

	/// Overlay used for darksight eye adjustments
	var/image/dsoverlay = null

	/// If they're glowing!
	var/glow_toggle = FALSE
	/// The range that they're glowing at!
	var/glow_range = 2
	/// The intensity that they're glowing at!
	var/glow_intensity = null
	/// The color they're glowing!
	var/glow_color = "#FFFFFF"

	var/see_invisible_default = SEE_INVISIBLE_LIVING

	/// Not specific, because a Nest may be the prop nest, or blob factory in this case.
	var/nest
	/// FALSE if the mob shouldn't be making dirt on the ground when it walks
	var/makes_dirt = TRUE
	/// If the mob's view has been relocated to somewhere else, like via a camera or with binocs
	var/looking_elsewhere = FALSE
	/// Used for buildmode AI control stuff.
	var/image/selected_image = null

	//Pending Refactor, as per Kev.
	//var/mobility_flags = MOBILITY_FLAGS_DEFAULT

	// TODO: execute iamcrystalclear for making this var
	var/last_blood_warn = -INFINITY
