
/*
 * Modifiers applied by Medical sources.
 */

/datum/modifier/bloodpump
	name = "external blood pumping"
	desc = "Your blood flows thanks to the wonderful power of science."

	on_created_text = "<span class='notice'>You feel alive.</span>"
	on_expired_text = "<span class='notice'>You feel.. less alive.</span>"
	stacks = MODIFIER_STACK_EXTEND

	pulse_set_level = PULSE_NORM

/datum/modifier/bloodpump/check_if_valid()
	..()
	if(holder.stat == DEAD)
		src.expire()

/datum/modifier/bloodpump_corpse
	name = "forced blood pumping"
	desc = "Your blood flows thanks to the wonderful power of science."

	on_created_text = "<span class='notice'>You feel alive.</span>"
	on_expired_text = "<span class='notice'>You feel.. less alive.</span>"
	stacks = MODIFIER_STACK_EXTEND

	pulse_set_level = PULSE_SLOW

/datum/modifier/bloodpump/corpse/check_if_valid()
	..()
	if(holder.stat != DEAD)
		src.expire()

/*
 * Modifiers caused by chemicals or organs specifically.
 */

/datum/modifier/cryogelled
	name = "cryogelled"
	desc = "Your body begins to freeze."
	mob_overlay_state = "chilled"

	on_created_text = "<span class='danger'>You feel like you're going to freeze! It's hard to move.</span>"
	on_expired_text = "<span class='warning'>You feel somewhat warmer and more mobile now.</span>"
	stacks = MODIFIER_STACK_ALLOWED

	slowdown = 0.1
	evasion = -5
	attack_speed_percent = 1.1
	disable_duration_percent = 1.05

/datum/modifier/resurrection_sickness
	name = "resurrection sickness"
	desc = "You feel rather weak, having been resurrected not so long ago."

	on_created_text = "<span class='warning'><font size='3'>You feel weakend.</font></span>"
	on_expired_text = "<span class='notice'><font size='3'>You feel your strength returning to you.</font></span>"

	outgoing_melee_damage_percent = 0.75	// 10% less melee damage.
	disable_duration_percent = 1.15			// Stuns last 15% longer.
	slowdown = 0.15							// Slower.
	evasion = -20							// 05% easier to hit.
