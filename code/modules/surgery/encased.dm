//Procedures in this file: Generic ribcage opening steps, Removing alien embryo, Fixing internal organs.
//////////////////////////////////////////////////////////////////
//				GENERIC	RIBCAGE SURGERY							//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/open_encased
	priority = 2
	can_infect = 1
	blood_level = 1

/datum/surgery_step/open_encased/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..()) return FALSE
	if (!hasorgans(target))
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && !(affected.robotic >= ORGAN_ROBOT) && affected.encased && affected.open >= 2

///////////////////////////////////////////////////////////////
// Rib Sawing Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/open_encased/saw
	step_name = "Saw bones"

	allowed_tools = list(
		/obj/item/surgical/circular_saw = 100, \
		/obj/item/surgical/saw_bronze = 75, \
		/obj/item/material/knife/machete/hatchet = 75,	\
		/obj/item/surgical/saw_primitive = 60
	)

	min_duration = 50
	max_duration = 70

/datum/surgery_step/open_encased/saw/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected && affected.open == 2

/datum/surgery_step/open_encased/saw/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("[user] begins to cut through [target]'s [affected.encased] with \the [tool].", \
	"You begin to cut through [target]'s [affected.encased] with \the [tool].")
	target.custom_pain("Something hurts horribly in your [affected.name]!", 60)
	..()

/datum/surgery_step/open_encased/saw/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("<font color=#4F49AF>[user] has cut [target]'s [affected.encased] open with \the [tool].</font>", \
	"<font color=#4F49AF>You have cut [target]'s [affected.encased] open with \the [tool].</font>")
	affected.open = 2.5

/datum/surgery_step/open_encased/saw/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("<font color='red'>[user]'s hand slips, cracking [target]'s [affected.encased] with \the [tool]!</font>" , \
	"<font color='red'>Your hand slips, cracking [target]'s [affected.encased] with \the [tool]!</font>" )

	affected.create_wound(WOUND_TYPE_CUT, 20)
	affected.fracture()

///////////////////////////////////////////////////////////////
// Rib Opening Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/open_encased/retract
	step_name = "Retract bones"

	allowed_tools = list(
		/obj/item/surgical/retractor = 100,
		/obj/item/surgical/retractor_primitive = 75
	)

	allowed_procs = list(IS_CROWBAR = 75)

	min_duration = 30
	max_duration = 40

/datum/surgery_step/open_encased/retract/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected && affected.open == 2.5

/datum/surgery_step/open_encased/retract/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "[user] starts to force open the [affected.encased] in [target]'s [affected.name] with \the [tool]."
	var/self_msg = "You start to force open the [affected.encased] in [target]'s [affected.name] with \the [tool]."
	user.visible_message(msg, self_msg)
	target.custom_pain("Something hurts horribly in your [affected.name]!", 40)
	..()

/datum/surgery_step/open_encased/retract/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "<font color=#4F49AF>[user] forces open [target]'s [affected.encased] with \the [tool].</font>"
	var/self_msg = "<font color=#4F49AF>You force open [target]'s [affected.encased] with \the [tool].</font>"
	user.visible_message(msg, self_msg)

	affected.open = 3

/datum/surgery_step/open_encased/retract/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "<font color='red'>[user]'s hand slips, cracking [target]'s [affected.encased]!</font>"
	var/self_msg = "<font color='red'>Your hand slips, cracking [target]'s  [affected.encased]!</font>"
	user.visible_message(msg, self_msg)

	affected.create_wound(WOUND_TYPE_BRUISE, 20)
	affected.fracture()

///////////////////////////////////////////////////////////////
// Rib Closing Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/open_encased/close
	step_name = "Close bones"

	allowed_tools = list(
		/obj/item/surgical/retractor = 100,
		/obj/item/surgical/retractor_primitive = 75
	)

	allowed_procs = list(IS_CROWBAR = 75)

	min_duration = 20
	max_duration = 40

/datum/surgery_step/open_encased/close/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return (..() && affected && affected.open == 3)

/datum/surgery_step/open_encased/close/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "[user] starts bending [target]'s [affected.encased] back into place with \the [tool]."
	var/self_msg = "You start bending [target]'s [affected.encased] back into place with \the [tool]."
	user.visible_message(msg, self_msg)
	target.custom_pain("Something hurts horribly in your [affected.name]!", 100)
	..()

/datum/surgery_step/open_encased/close/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "<font color=#4F49AF>[user] bends [target]'s [affected.encased] back into place with \the [tool].</font>"
	var/self_msg = "<font color=#4F49AF>You bend [target]'s [affected.encased] back into place with \the [tool].</font>"
	user.visible_message(msg, self_msg)

	affected.open = 2.5

/datum/surgery_step/open_encased/close/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "<font color='red'>[user]'s hand slips, bending [target]'s [affected.encased] the wrong way!</font>"
	var/self_msg = "<font color='red'>Your hand slips, bending [target]'s [affected.encased] the wrong way!</font>"
	user.visible_message(msg, self_msg)

	affected.create_wound(WOUND_TYPE_BRUISE, 20)
	affected.fracture()

	/*if (prob(40)) //TODO: ORGAN REMOVAL UPDATE.
		user.visible_message("<font color='red'> A rib pierces the lung!</font>")
		target.rupture_lung()*/

///////////////////////////////////////////////////////////////
// Rib Mending Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/open_encased/mend
	step_name = "Mend bones"

	allowed_tools = list(
		/obj/item/surgical/bonegel = 100
	)

	allowed_procs = list(IS_SCREWDRIVER = 75)

	min_duration = 20
	max_duration = 40

/datum/surgery_step/open_encased/mend/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected && affected.open == 2.5

/datum/surgery_step/open_encased/mend/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "[user] starts applying \the [tool] to [target]'s [affected.encased]."
	var/self_msg = "You start applying \the [tool] to [target]'s [affected.encased]."
	user.visible_message(msg, self_msg)
	target.custom_pain("Something hurts horribly in your [affected.name]!", 100)
	..()

/datum/surgery_step/open_encased/mend/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "<font color=#4F49AF>[user] applied \the [tool] to [target]'s [affected.encased].</font>"
	var/self_msg = "<font color=#4F49AF>You applied \the [tool] to [target]'s [affected.encased].</font>"
	user.visible_message(msg, self_msg)

	affected.open = 2

///////////////////////////////////////////////////////////////
// Saw/Retractor/Gel Combi-open and close.
///////////////////////////////////////////////////////////////
/datum/surgery_step/open_encased/advancedsaw_open
	step_name = "Divert bones"

	allowed_tools = list(
		/obj/item/surgical/circular_saw/manager = 100
	)

	priority = 3

	min_duration = 60
	max_duration = 90

/datum/surgery_step/open_encased/advancedsaw_open/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected && affected.open >= 2 && affected.open < 3

/datum/surgery_step/open_encased/advancedsaw_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("[user] begins to open [target]'s [affected.encased] with \the [tool].", \
	"You begin to open [target]'s [affected.encased] with \the [tool].")
	target.custom_pain("Something hurts horribly in your [affected.name]!", 60)
	..()

/datum/surgery_step/open_encased/advancedsaw_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("<font color=#4F49AF>[user] has cut [target]'s [affected.encased] wide open with \the [tool].</font>", \
	"<font color=#4F49AF>You have cut [target]'s [affected.encased] wide open with \the [tool].</font>")
	affected.open = 3

/datum/surgery_step/open_encased/advancedsaw_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("<font color='red'>[user]'s hand slips, searing [target]'s [affected.encased] with \the [tool]!</font>" , \
	"<font color='red'>Your hand slips, searing [target]'s [affected.encased] with \the [tool]!</font>" )

	affected.create_wound(WOUND_TYPE_CUT, 20)
	affected.create_wound(WOUND_TYPE_BURN, 15)
	if(prob(affected.damage))
		affected.fracture()


/datum/surgery_step/open_encased/advancedsaw_mend
	step_name = "Seal bones"

	allowed_tools = list(
		/obj/item/surgical/circular_saw/manager = 100
	)

	priority = 3

	min_duration = 30
	max_duration = 60

/datum/surgery_step/open_encased/advancedsaw_mend/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return (..() && affected && affected.open == 3)

/datum/surgery_step/open_encased/advancedsaw_mend/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "[user] starts sealing \the [target]'s [affected.encased] with \the [tool]."
	var/self_msg = "You start sealing \the [target]'s [affected.encased] with \the [tool]."
	user.visible_message(msg, self_msg)
	target.custom_pain("Something hurts horribly in your [affected.name]!", 100)
	..()

/datum/surgery_step/open_encased/advancedsaw_mend/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "<font color=#4F49AF>[user] sealed \the [target]'s [affected.encased] with \the [tool].</font>"
	var/self_msg = "<font color=#4F49AF>You sealed \the [target]'s [affected.encased] with \the [tool].</font>"
	user.visible_message(msg, self_msg)

	affected.open = 2
