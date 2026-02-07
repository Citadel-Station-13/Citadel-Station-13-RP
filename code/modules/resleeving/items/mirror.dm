/**
 * Mirrors. These are a bit weird; they're supposed to be what holds people's
 * minds, ICly, if they die, as to allow them to have a mostly-continuous resurrection if
 * their brain is destroyed.
 *
 * Code-wise, this is a fucking nightmare. Oh boy.
 */
/obj/item/organ/internal/mirror
	name = "mirror"
	desc = "A small, implanted disk that stores a copy of one's consciousness."
	catalogue_data = /datum/category_item/catalogue/technology/resleeving
	icon = 'icons/obj/mirror.dmi'
	icon_state = "mirror_implant_f"
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	item_flags = ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD
	organ_tag = ORGAN_TAG_MIRROR
	parent_organ = BP_TORSO

	/// The 'real mind' of.. us.
	/// * Cannot be erased without admin intervention; usually set on implant.
	/// * This ensures you cannot overwrite a mirror by putting it in someone else.
	var/datum/mind_ref/owner_mind_ref

	var/datum/resleeving_body_backup/recorded_body
	var/datum/resleeving_mind_backup/recorded_mind

	var/last_auto_backup
	var/auto_backup_interval = 3 MINUTES

	var/state = null

	/// empty, no one's backed up
	var/const/STATE_EMPTY = "Empty"
	/// bound but not inside owner / not actively backing up
	var/const/STATE_BOUND = "bound"
	/// inside owner, backed up
	var/const/STATE_ACTIVE = "active"
	/// inside conflicting owner
	var/const/STATE_MISMATCH = "mismatch"

	// TODO: is there a way to hook death but before say, gibbing, so we back up before they die?

/obj/item/organ/internal/mirror/New()
	state = STATE_EMPTY
	..()

/obj/item/organ/internal/mirror/update_icon(updates)
	. = ..()
	if(owner_mind_ref)
		icon_state = "mirror_implant_f"
	else
		icon_state = "mirror_implant"

/obj/item/organ/internal/mirror/replaced(mob/living/carbon/human/target, obj/item/organ/external/affected)
	. = ..()
	try_backup_process()
	last_auto_backup = world.time

/obj/item/organ/internal/mirror/removed(mob/living/user, ignore_vital)
	..()
	state = owner_mind_ref ? STATE_BOUND : STATE_EMPTY

/obj/item/organ/internal/mirror/tick_life(dt)
	..()
	if(last_auto_backup > world.time - auto_backup_interval)
		last_auto_backup = world.time
		try_backup_process()

// TODO: if they are logged out, don't toss the messages
/obj/item/organ/internal/mirror/proc/try_backup_process()
	if(!owner?.mind)
		// in the future we shouldn't hard-require mind ref, but for now, we do
		return
	var/datum/mind/target = owner.mind
	// check that mind matches
	if(owner_mind_ref)
		var/datum/mind/locked = owner_mind_ref.resolve()
		if(target != locked)
			if(state != STATE_MISMATCH)
				state = STATE_MISMATCH
				to_chat(owner, SPAN_BOLDDANGER("You feel a harsh buzz from something implanted at the base of your neck. Your mirror has rejected your consciousness as foreign."))
		else
			if(state != STATE_ACTIVE)
				state = STATE_ACTIVE
				to_chat(owner, SPAN_NOTICE("You feel a faint click from something implanted at the base of your neck. Your mirror has reactivated upon detecting your consciousness."))
	else
		// bind
		owner_mind_ref = target.get_mind_ref()
		state = STATE_ACTIVE
		to_chat(owner, SPAN_NOTICE("You feel a series of clicks from something implanted at the base of your neck. Your mirror is attuning to your consciousness and performing an initial backup."))

	if(state != STATE_ACTIVE)
		return

	recorded_body = new(target)
	recorded_mind = new(target)

/obj/item/organ/internal/mirror/update_icon_state()
	if(owner_mind_ref && recorded_body && recorded_mind)
		icon_state = "mirror_implant"
	else
		icon_state = "mirror_implant_f"
	return ..()

/**
 * Standard mirror data for export to compatible TGUI interfaces.
 * * Struct path: 'interfaces/common/Resleeving.tsx'
 */
/obj/item/organ/internal/mirror/proc/ui_serialize()
	return list(
		"activated" = !!owner_mind_ref,
		"bodyRecord" = recorded_body?.ui_serialize(),
		"mindRecord" = recorded_body?.ui_serialize(),
	)
