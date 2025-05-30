
/obj/machinery/porta_turret/stationary
	ailock = TRUE
	lethal = TRUE
	installation = /obj/item/gun/projectile/energy/laser

/obj/machinery/porta_turret/stationary/syndie // Generic turrets for POIs that need to not shoot their buddies.
	req_one_access = list(ACCESS_FACTION_SYNDICATE)
	enabled = TRUE
	check_all = TRUE
	faction = "syndicate" // Make sure this equals the faction that the mobs in the POI have or they will fight each other.

/obj/machinery/porta_turret/ai_defense
	name = "defense turret"
	desc = "This variant appears to be much more durable."
	req_one_access = list(ACCESS_SPECIAL_SILICONS) // Just in case.
	installation = /obj/item/gun/projectile/energy/xray // For the armor pen.
	integrity = 250 // Since lasers do 40 each.
	integrity_max = 250

/obj/machinery/porta_turret/ai_defense/emp_act(severity)
	if(prob(33)) // One in three chance to resist an EMP.  This is significant if an AoE EMP is involved against multiple turrets.
		return
	..()

/datum/category_item/catalogue/anomalous/precursor_a/alien_turret
	name = "Precursor Alpha Object - Turrets"
	desc = "An autonomous defense turret created by unknown ancient aliens. It utilizes an \
	integrated laser projector to harm, firing a cyan beam at the target. The signal processing \
	of this mechanism appears to be radically different to conventional electronics used by modern \
	technology, which appears to be much less susceptible to external electromagnetic influences.\
	<br><br>\
	This makes the turret be very resistant to the effects of an EM pulse. It is unknown if whatever \
	species that built the turret had intended for it to have that quality, or if it was an incidental \
	quirk of how they designed their electronics."
	value = CATALOGUER_REWARD_MEDIUM

/obj/machinery/porta_turret/alien // The kind used on the UFO submap.
	name = "interior anti-boarding turret"
	desc = "A very tough looking turret made by alien hands."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_turret)
	icon_state = "turret_cover_alien"
	req_one_access = list(ACCESS_FACTION_ALIEN)
	installation = /obj/item/gun/projectile/energy/alien
	enabled = TRUE
	lethal = TRUE
	ailock = TRUE
	check_all = TRUE
	integrity = 250 // Similar to the AI turrets.
	integrity_max = 250
	turret_type = "alien"

/obj/machinery/porta_turret/alien/emp_act(severity) // This is overrided to give an EMP resistance as well as avoid scambling the turret settings.
	if(prob(75)) // Superior alien technology, I guess.
		return
	enabled = FALSE
	spawn(rand(1 MINUTE, 2 MINUTES))
		if(!enabled)
			enabled = TRUE

/obj/machinery/porta_turret/alien/destroyed // Turrets that are already dead, to act as a warning of what the rest of the submap contains.
	name = "broken interior anti-boarding turret"
	desc = "A very tough looking turret made by alien hands. This one looks destroyed, thankfully."
	icon_state = "destroyed_target_prism_alien"
	machine_stat = BROKEN
	can_salvage = FALSE // So you need to actually kill a turret to get the alien gun.

/obj/machinery/porta_turret/industrial
	name = "industrial turret"
	desc = "This variant appears to be much more rugged."
	req_one_access = list(ACCESS_COMMAND_BRIDGE)
	icon_state = "turret_cover_industrial"
	installation = /obj/item/gun/projectile/energy/phasegun
	integrity = 200
	integrity_max = 200
	turret_type = "industrial"

/obj/machinery/porta_turret/industrial/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	. = ..()
	if(enabled)
		if(!attacked && !emagged)
			attacked = TRUE
			spawn()
				sleep(6 SECONDS)
				attacked = FALSE

/obj/machinery/porta_turret/industrial/attack_generic(mob/living/L, damage)
	return ..(L, damage * 0.8)

/obj/machinery/porta_turret/industrial/teleport_defense
	name = "defense turret"
	desc = "This variant appears to be much more durable, with a rugged outer coating."
	req_one_access = list(ACCESS_COMMAND_BRIDGE)
	installation = /obj/item/gun/projectile/energy/gun/burst
	integrity = 250
	integrity_max = 250

/obj/machinery/porta_turret/poi	//These are always angry
	enabled = TRUE
	lethal = TRUE
	ailock = TRUE
	check_all = TRUE
	can_salvage = FALSE	// So you can't just twoshot a turret and get a fancy gun

/obj/machinery/porta_turret/crescent
	req_one_access = list(ACCESS_CENTCOM_ERT)
	enabled = FALSE
	ailock = TRUE
	check_synth = FALSE
	check_access = TRUE
	check_arrest = TRUE
	check_records = TRUE
	check_weapons = TRUE
	check_anomalies = TRUE
	check_all = FALSE
	check_down = TRUE
