//Procedures in this file: Putting items in body cavity. Implant removal. Items removal.

//////////////////////////////////////////////////////////////////
//					ITEM PLACEMENT SURGERY						//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/cavity
	priority = 1

/datum/surgery_step/cavity/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..()) return FALSE
	if(!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == (affected.encased ? 3 : 2) && !(affected.status & ORGAN_BLEEDING)

/datum/surgery_step/cavity/proc/get_max_wclass(obj/item/organ/external/affected)
	switch (affected.organ_tag)
		if (BP_HEAD)
			return WEIGHT_CLASS_TINY
		if (BP_TORSO)
			return WEIGHT_CLASS_NORMAL
		if (BP_GROIN)
			return WEIGHT_CLASS_SMALL
	return 0

/datum/surgery_step/cavity/proc/get_cavity(obj/item/organ/external/affected)
	switch (affected.organ_tag)
		if (BP_HEAD)
			return "cranial"
		if (BP_TORSO)
			return "thoracic"
		if (BP_GROIN)
			return "abdominal"
	return ""

/datum/surgery_step/cavity/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!</font>", \
	"<font color='red'>Your hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!</font>")
	affected.create_wound(WOUND_TYPE_CUT, 20)

///////////////////////////////////////////////////////////////
// Space Making Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/cavity/make_space
	step_name = "Prepare cavity"

	allowed_tools = list(
		/obj/item/surgical/surgicaldrill = 100,
		/obj/item/pen = 75,
		/obj/item/stack/rods = 50,
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/cavity/make_space/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && !affected.cavity

/datum/surgery_step/cavity/make_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts making some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].", \
	"You start making some space inside [target]'s [get_cavity(affected)] cavity with \the [tool]." )
	target.custom_pain("The pain in your chest is living hell!",1)
	affected.cavity = 1
	..()

/datum/surgery_step/cavity/make_space/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message("<font color=#4F49AF>[user] makes some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].</font>", \
	"<font color=#4F49AF>You make some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].</font>" )

///////////////////////////////////////////////////////////////
// Cavity Closing Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/cavity/close_space
	step_name = "Seal cavity"

	priority = 2
	allowed_tools = list(
		/obj/item/surgical/cautery = 100,
		/obj/item/clothing/mask/smokable/cigarette = 75,
		/obj/item/surgical/cautery_primitive = 70,
		/obj/item/flame/lighter = 50,
		/obj/item/weldingtool = 25,
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/cavity/close_space/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.cavity

/datum/surgery_step/cavity/close_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts mending [target]'s [get_cavity(affected)] cavity wall with \the [tool].", \
	"You start mending [target]'s [get_cavity(affected)] cavity wall with \the [tool]." )
	target.custom_pain("The pain in your chest is living hell!",1)
	affected.cavity = 0
	..()

/datum/surgery_step/cavity/close_space/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message("<font color=#4F49AF>[user] mends [target]'s [get_cavity(affected)] cavity walls with \the [tool].</font>", \
	"<font color=#4F49AF> You mend[target]'s [get_cavity(affected)] cavity walls with \the [tool].</font>" )

///////////////////////////////////////////////////////////////
// Item Implantation Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/cavity/place_item
	step_name = "Implant item"

	priority = 0
	allowed_tools = list(/obj/item = 100)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/cavity/place_item/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		//if(istype(user,/mob/living/silicon/robot))
			//return
		if(tool == null)
			return 0
		if(affected && affected.cavity)
			var/total_volume = tool.w_class
			for(var/obj/item/I in affected.implants)
				if(istype(I,/obj/item/implant))
					continue
				total_volume += I.w_class
			return total_volume <= get_max_wclass(affected)

/datum/surgery_step/cavity/place_item/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color=#4F49AF>[user] starts putting \the [tool] inside [target]'s [get_cavity(affected)] cavity.</font>", \
	"<font color=#4F49AF>You start putting \the [tool] inside [target]'s [get_cavity(affected)] cavity.</font>" ) //Nobody will probably ever see this, but I made these two blue. ~CK
	target.custom_pain("The pain in your chest is living hell!",1)
	..()

/datum/surgery_step/cavity/place_item/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)

	user.visible_message("<font color=#4F49AF>[user] puts \the [tool] inside [target]'s [get_cavity(affected)] cavity.</font>", \
	"<font color=#4F49AF>You put \the [tool] inside [target]'s [get_cavity(affected)] cavity.</font>" )
	if (tool.w_class > get_max_wclass(affected)/2 && prob(50) && (affected.robotic < ORGAN_ROBOT))
		to_chat(user, "<font color='red'> You tear some blood vessels trying to fit such a big object in this cavity.</font>")
		affected.create_specific_wound(/datum/wound/internal_bleeding, 10)
		affected.owner.custom_pain("You feel something rip in your [affected.name]!", 1)
	if(!user.transfer_item_to_loc(tool, affected))
		return
	affected.implants += tool
	if(istype(tool,/obj/item/nif))
		var/obj/item/nif/N = tool
		N.implant(target)
	affected.cavity = 0

//////////////////////////////////////////////////////////////////
//					IMPLANT/ITEM REMOVAL SURGERY
//////////////////////////////////////////////////////////////////

/obj/item/proc/surgically_remove(mob/living/carbon/human/target, obj/item/organ/external/chest/removing_from)
	removing_from.implants -= src

	target.update_hud_sec_implants()

	loc = get_turf(target)
	add_blood(target)
	update_icon()

/datum/surgery_step/cavity/implant_removal
	step_name = "Remove implant"

	allowed_tools = list(
		/obj/item/surgical/hemostat = 100,	\
		/obj/item/surgical/hemostat_primitive = 50, \
		/obj/item/material/kitchen/utensil/fork = 20
	)

	allowed_procs = list(IS_WIRECUTTER = 75)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/cavity/implant_removal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return FALSE
	if(affected.organ_tag == BP_HEAD)
		var/obj/item/organ/internal/brain/sponge = target.internal_organs_by_name["brain"]
		return ..() && (!sponge || !sponge.damage)
	else
		return ..()

/datum/surgery_step/cavity/implant_removal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color=#4F49AF>[user] starts poking around inside [target]'s [affected.name] with \the [tool].</font>", \
	"<font color=#4F49AF>You start poking around inside [target]'s [affected.name] with \the [tool].</font>" )
	target.custom_pain("The pain in your [affected.name] is living hell!",1)
	..()

/datum/surgery_step/cavity/implant_removal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)

	if (affected.implants.len)

		var/obj/item/obj = input("What do you want to extract?") in affected.implants

		user.visible_message("<font color=#4F49AF>[user] takes something out of incision on [target]'s [affected.name] with \the [tool]!</font>", \
		"<font color=#4F49AF>You take [obj] out of incision on [target]'s [affected.name]s with \the [tool]!</font>" )

		obj.surgically_remove(target, affected)

		if(istype(tool, /obj/item/nif))
			var/obj/item/nif/N = tool
			N.unimplant(target)

	else
		user.visible_message("<font color=#4F49AF>[user] could not find anything inside [target]'s [affected.name], and pulls \the [tool] out.</font>", \
		"<font color=#4F49AF>You could not find anything inside [target]'s [affected.name].</font>" )

/datum/surgery_step/cavity/implant_removal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	..()
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	if (affected.implants.len)
		var/fail_prob = 10
		fail_prob += 100 - tool_quality(tool)
		if (prob(fail_prob))
			var/obj/item/implant/imp = affected.implants[1]
			user.visible_message("<font color='red'> Something beeps inside [target]'s [affected.name]!</font>")
			playsound(imp.loc, 'sound/items/countdown.ogg', 75, 1, -3)
			spawn(25)
				imp.activate()
