/obj/item/vehicle_module/legacy/crisis_drone
	name = "crisis dronebay"
	desc = "A small shoulder-mounted dronebay containing a rapid response drone capable of moderately stabilizing a patient near the exosuit."
	icon_state = "mecha_dronebay"
	origin_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_BIO = 5, TECH_DATA = 4)
	range = MELEE|RANGED
	equip_cooldown = 3 SECONDS
	required_type = list(/obj/vehicle/sealed/mecha/medical)

	var/droid_state = "med_droid"

	var/beam_state = "medbeam"

	var/enabled = FALSE

	var/icon/drone_overlay

	var/max_distance = 3

	var/damcap = 60
	var/heal_dead = FALSE	// Does this device heal the dead?

	var/brute_heal = 0.5	// Amount of bruteloss healed.
	var/burn_heal = 0.5		// Amount of fireloss healed.
	var/tox_heal = 0.5		// Amount of toxloss healed.
	var/oxy_heal = 1		// Amount of oxyloss healed.
	var/rad_heal = 0		// Amount of radiation healed.
	var/clone_heal = 0	// Amount of cloneloss healed.
	var/hal_heal = 0.2	// Amount of halloss healed.
	var/bone_heal = 0	// Percent chance it will heal a broken bone. this does not mean 'make it not instantly re-break'.

	var/mob/living/Target = null
	var/datum/beam_legacy/MyBeam = null

	equip_type = EQUIP_HULL

/obj/item/vehicle_module/legacy/crisis_drone/Initialize(mapload)
	. = ..()
	drone_overlay = new(src.icon, icon_state = droid_state)

/obj/item/vehicle_module/legacy/crisis_drone/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/vehicle_module/legacy/crisis_drone/attach(obj/vehicle/sealed/mecha/M as obj)
	. = ..(M)
	if(chassis)
		START_PROCESSING(SSobj, src)

/obj/item/vehicle_module/legacy/crisis_drone/detach(atom/moveto=null)
	shut_down()
	. = ..(moveto)
	STOP_PROCESSING(SSobj, src)

/obj/item/vehicle_module/legacy/crisis_drone/critfail()
	. = ..()
	STOP_PROCESSING(SSobj, src)
	shut_down()
	if(chassis && chassis.occupant_legacy)
		to_chat(chassis.occupant_legacy, "<span class='notice'>\The [chassis] shudders as something jams!</span>")
		log_message("[src.name] has malfunctioned. Maintenance required.")

/obj/item/vehicle_module/legacy/crisis_drone/process()
	// Will continually try to find the nearest person above the threshold that is a valid target, and try to heal them.
	if(chassis && enabled && chassis.has_charge(energy_drain))
		var/mob/living/Targ = Target
		var/TargDamage = 0

		if(!valid_target(Target))
			Target = null

		if(Target)
			TargDamage = (Targ.getOxyLoss() + Targ.getFireLoss() + Targ.getBruteLoss() + Targ.getToxLoss())

		for(var/mob/living/Potential in viewers(max_distance, chassis))
			if(!valid_target(Potential))
				continue

			var/tallydamage = 0
			if(oxy_heal)
				tallydamage += Potential.getOxyLoss()
			if(burn_heal)
				tallydamage += Potential.getFireLoss()
			if(brute_heal)
				tallydamage += Potential.getBruteLoss()
			if(tox_heal)
				tallydamage += Potential.getToxLoss()
			if(hal_heal)
				tallydamage += Potential.getHalLoss()
			if(clone_heal)
				tallydamage += Potential.getCloneLoss()
			if(rad_heal)
				tallydamage += Potential.radiation / 5

			if(tallydamage > TargDamage)
				Target = Potential

		if(MyBeam && !valid_target(MyBeam.target))
			QDEL_NULL(MyBeam)

		if(Target)
			if(MyBeam && MyBeam.target != Target)
				QDEL_NULL(MyBeam)

			if(valid_target(Target))
				if(!MyBeam)
					MyBeam = chassis.Beam(Target,icon='icons/effects/beam.dmi',icon_state=beam_state,time=3 SECONDS,maxdistance=max_distance,beam_type = /obj/effect/ebeam)
				heal_target(Target)

	else
		shut_down()

/obj/item/vehicle_module/legacy/crisis_drone/proc/valid_target(var/mob/living/L)
	. = TRUE

	if(!L || !istype(L))
		return FALSE

	if(get_dist(L, src) > max_distance)
		return FALSE

	if(!(L in viewers(max_distance, chassis)))
		return FALSE

	if(!unique_patient_checks(L))
		return FALSE

	if(L.stat == DEAD && !heal_dead)
		return FALSE

	var/tallydamage = 0
	if(oxy_heal)
		tallydamage += L.getOxyLoss()
	if(burn_heal)
		tallydamage += L.getFireLoss()
	if(brute_heal)
		tallydamage += L.getBruteLoss()
	if(tox_heal)
		tallydamage += L.getToxLoss()
	if(hal_heal)
		tallydamage += L.getHalLoss()
	if(clone_heal)
		tallydamage += L.getCloneLoss()
	if(rad_heal)
		tallydamage += L.radiation / 5

	if(tallydamage < damcap)
		return FALSE

/obj/item/vehicle_module/legacy/crisis_drone/proc/shut_down()
	if(enabled)
		chassis.visible_message("<span class='notice'>\The [chassis]'s [src] buzzes as its drone returns to port.</span>")
		toggle_drone()
	if(!isnull(Target))
		Target = null
	if(MyBeam)
		QDEL_NULL(MyBeam)

/obj/item/vehicle_module/legacy/crisis_drone/proc/unique_patient_checks(var/mob/living/L)	// Anything special for subtypes. Does it only work on Robots? Fleshies? A species?
	. = TRUE

/obj/item/vehicle_module/legacy/crisis_drone/proc/heal_target(var/mob/living/L)	// We've done all our special checks, just get to fixing damage.
	chassis.use_power(energy_drain)
	if(istype(L))
		L.adjustBruteLoss(brute_heal * -1)
		L.adjustFireLoss(burn_heal * -1)
		L.adjustToxLoss(tox_heal * -1)
		L.adjustOxyLoss(oxy_heal * -1)
		L.adjustCloneLoss(clone_heal * -1)
		L.adjustHalLoss(hal_heal * -1)
		L.cure_radiation(rad_heal)

		if(ishuman(L) && bone_heal)
			var/mob/living/carbon/human/H = L

			if(H.bad_external_organs.len)
				for(var/obj/item/organ/external/E in H.bad_external_organs)
					if(prob(bone_heal))
						E.status &= ~ORGAN_BROKEN

/obj/item/vehicle_module/legacy/crisis_drone/proc/toggle_drone()
	if(chassis)
		enabled = !enabled
		if(enabled)
			set_ready_state(0)
			log_message("Activated.")
		else
			set_ready_state(1)
			log_message("Deactivated.")

/obj/item/vehicle_module/legacy/crisis_drone/add_equip_overlay(obj/vehicle/sealed/mecha/M as obj)
	..()
	if(enabled)
		M.add_overlay(drone_overlay)
	return

/obj/item/vehicle_module/legacy/crisis_drone/Topic(href, href_list)
	..()
	if(href_list["toggle_drone"])
		toggle_drone()
	return

/obj/item/vehicle_module/legacy/crisis_drone/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name] - <a href='?src=\ref[src];toggle_drone=1'>[enabled?"Dea":"A"]ctivate</a>"

/obj/item/vehicle_module/legacy/crisis_drone/rad
	name = "hazmat dronebay"
	desc = "A small shoulder-mounted dronebay containing a rapid response drone capable of purging a patient near the exosuit of radiation damage."
	icon_state = "mecha_dronebay_rad"

	droid_state = "rad_drone"
	beam_state = "g_beam"

	tox_heal = 0.5
	rad_heal = 25
	clone_heal = 0.2
	hal_heal = 0.2
