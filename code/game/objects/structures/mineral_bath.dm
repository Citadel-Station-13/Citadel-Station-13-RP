/obj/structure/adherent_bath
	name = "mineral bath"
	desc = "A deep, narrow basin filled with a swirling, semi-opaque liquid."
	icon = 'icons/obj/machines/adherent.dmi'
	icon_state = "bath"
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	var/mob/living/occupant

/obj/structure/adherent_bath/Destroy()
	eject_occupant()
	. = ..()

/obj/structure/adherent_bath/return_air()
	var/datum/gas_mixture/venus = new(CELL_VOLUME)
	venus.adjust_multi(/datum/gas/nitrogen, MOLES_N2STANDARD, /datum/gas/oxygen, MOLES_O2STANDARD)
	venus.temperature = 490
	return venus

/obj/structure/adherent_bath/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/grab))
		var/obj/item/grab/G = thing
		if(enter_bath(G.affecting))
			qdel(G)
		return
	. = ..()

/obj/structure/adherent_bath/proc/enter_bath(var/mob/living/patient, var/mob/user)

	if(!istype(patient))
		return FALSE

	var/self_drop = (user == patient)

	if(!user.Adjacent(src) || !(self_drop || user.Adjacent(patient)))
		return FALSE

	if(occupant)
		to_chat(user, "<span class='warning'>\The [src] is occupied.</span>")
		return FALSE

	if(self_drop)
		user.visible_message("<span class='notice'>\The [user] begins climbing into \the [src].</span>")
	else
		user.visible_message("<span class='notice'>\The [user] begins pushing \the [patient] into \the [src].</span>")

	if(!do_after(user, 3 SECONDS, src))
		return FALSE

	if(!user.Adjacent(src) || !(self_drop || user.Adjacent(patient)))
		return FALSE

	if(occupant)
		to_chat(user, "<span class='warning'>\The [src] is occupied.</span>")
		return FALSE

	if(self_drop)
		user.visible_message("<span class='notice'>\The [user] climbs into \the [src].</span>")
	else
		user.visible_message("<span class='notice'>\The [user] pushes \the [patient] into \the [src].</span>")

	playsound(loc, 'sound/effects/slosh.ogg', 50, 1)
	patient.forceMove(src)
	occupant = patient
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/structure/adherent_bath/attack_hand(var/mob/user)
	eject_occupant()

/obj/structure/adherent_bath/proc/eject_occupant()
	if(!occupant)
		return
	occupant.dropInto(loc)
	occupant.update_perspective()
	playsound(src, 'sound/effects/slosh.ogg', 50, 1)
	occupant.regenerate_icons()
	occupant = null
	STOP_PROCESSING(SSobj, src)

/obj/structure/adherent_bath/MouseDrop_T(var/atom/movable/O, var/mob/user)
	enter_bath(O, user)

/obj/structure/adherent_bath/relaymove(var/mob/user)
	if(user == occupant)
		eject_occupant()

/obj/structure/adherent_bath/process(delta_time)
	if(!occupant)
		STOP_PROCESSING(SSobj, src)
		return

	if(occupant.loc != src)
		occupant = null
		STOP_PROCESSING(SSobj, src)
		return

	if(ishuman(occupant))

		var/mob/living/carbon/human/H = occupant
		//var/repaired_organ

		// Replace limbs for crystalline species.
		if((H.species.name == SPECIES_ADHERENT || H.species.name == SPECIES_GOLEM) && prob(30))
			if(!crystal_heal_damage(H))
				if(!crystal_restore_limbs(H))
					if(!crystal_heal_internal_organs(H))
						crystal_remove_shrapn(H)
						crystal_debrittle_crystals(H)
		//else//damage non adherent

/obj/structure/adherent_bath/proc/crystal_restore_limbs(mob/living/carbon/human/patient)
	for(var/limb_type in patient.species.has_limbs)
		var/obj/item/organ/external/E = patient.organs_by_name[limb_type]
		if(E && !E.is_usable())// && !(E.limb_flags))
			E.removed()
			qdel(E)
			E = null
		if(!E)
			var/list/organ_data = patient.species.has_limbs[limb_type]
			var/limb_path = organ_data["path"]
			var/obj/item/organ/O = new limb_path(patient)
			organ_data["descriptor"] = O.name
			patient.species.post_organ_rejuvenate(O, patient)
			O.status = 0
			to_chat(occupant, "<span class='notice'>You feel your [O.name] reform in the crystal bath.</span>")
			patient.update_icons()
			return TRUE//return true to end the healing chain for this process call

/obj/structure/adherent_bath/proc/crystal_heal_internal_organs(mob/living/carbon/human/patient)
	for(var/thing in patient.internal_organs)
		var/obj/item/organ/internal/I = thing
		if(BP_IS_CRYSTAL(I) && I.damage)
			I.heal_damage_a(rand(3,5))
			to_chat(patient, "<span class='notice'>The mineral-rich bath mends your [I.name].</span>")
			return TRUE

/obj/structure/adherent_bath/proc/crystal_heal_damage(mob/living/carbon/human/patient)
	if(patient.radiation > 0)
		patient.radiation = max(patient.radiation - rand(5, 15), 0)
	for(var/thing in patient.organs)
		var/obj/item/organ/external/E = thing
		if(BP_IS_CRYSTAL(E))
			if(E.brute_dam || E.burn_dam)
				E.heal_damage(rand(3,5), rand(3,5), robo_repair = 1)
				if(E.brute_dam <= 0)
					E.status &= ~ORGAN_BROKEN
					E.status &= ~ORGAN_BLEEDING
				to_chat(patient, "<span class='notice'>The mineral-rich bath mends your [E.name].</span>")
				return TRUE

/obj/structure/adherent_bath/proc/crystal_remove_shrapn(mob/living/carbon/human/patient)
	for(var/thing in patient.organs)
		var/obj/item/organ/external/E = thing
		if(BP_IS_CRYSTAL(E))
			for(var/obj/implanted_object in E.implants)
				if(!istype(implanted_object,/obj/item/implant) && !istype(implanted_object,/obj/item/organ/internal/augment) && prob(25))	// We don't want to remove REAL implants. Just shrapnel etc.
					E.implants -= implanted_object
					to_chat(patient, "<span class='notice'>The mineral-rich bath dissolves the [implanted_object.name] in your [E.name].</span>")
					qdel(implanted_object)
					return TRUE


/obj/structure/adherent_bath/proc/crystal_debrittle_crystals(mob/living/carbon/human/patient)
	for(var/thing in patient.organs)
		if(istype(thing, /obj/item/organ))
			var/obj/item/organ/O = thing
			if(O.status & ORGAN_BRITTLE)
				if(prob(50))
					O.status &= (~ORGAN_BRITTLE)
					to_chat(patient, "<span class='notice'>The mineral-rich bath strengthens your [O] makeing it less brittle.</span>")
					return TRUE

/* TODO: Add variants that heal robots, but make them brittle
check if shrapnel removal works
if(prob(50))//The mineral rich bath soaked into you to dissolve the implanted object, higher chance to become brittle
	if(!BP_IS_CRYSTAL(E) && !BP_IS_BRITTLE(E))
		to_chat(patient, "<span class='warning'>It feels a bit brittle, though...</span>")
		E.status |= ORGAN_BRITTLE

*/


