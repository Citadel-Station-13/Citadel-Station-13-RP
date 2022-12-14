/obj/item/radio/sleevecard
	canhear_range = 0

/obj/item/sleevecard
	name = "sleevecard"
	desc = "This Vey-Med upgraded pAI module has enough capacity to run a whole mind of human-level intelligence."
	catalogue_data = list(///datum/category_item/catalogue/information/organization/vey_med,
						/datum/category_item/catalogue/technology/resleeving)

	icon = 'icons/obj/pda.dmi'
	icon_state = "pai"
	item_state = "electronic"

	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_DATA = 2)
	show_messages = 0

	var/obj/item/radio/sleevecard/radio
	var/mob/living/silicon/infomorph/infomorph
	var/current_emotion = 1

	matter = list(MAT_STEEL = 4000, MAT_GLASS = 4000)

/obj/item/sleevecard/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/rig/rig = src.get_rig()
	if(istype(rig))
		rig.forced_move(direction, user)

/obj/item/sleevecard/Initialize(mapload)
	. = ..()
	add_overlay("pai-off")
	radio = new(src)

/obj/item/sleevecard/Destroy()
	if(!isnull(infomorph))
		infomorph.death(0)
		infomorph = null
	QDEL_NULL(radio)
	return ..()

/obj/item/sleevecard/attack_self(mob/user)
	add_fingerprint(user)

	if(!infomorph)
		to_chat(user,"<span class='warning'>\The [src] does not have a mind in it!</span>")
	else
		to_chat(user,"<span class='notice'>\The [src] displays the name '[infomorph]'.</span>")

//This is a 'hard' proc, it does no permission checking, do that on the computer
/obj/item/sleevecard/proc/sleeveInto(var/datum/transhuman/mind_record/MR)
	infomorph = new(src, src, MR.mindname)

	for(var/datum/language/L in MR.languages)
		infomorph.add_language(L.name)
	MR.mind_ref.active = 1 //Well, it's about to be.
	MR.mind_ref.transfer_to(infomorph) //Does mind+ckey+client.
	infomorph.ooc_notes = MR.mind_oocnotes
	infomorph.apply_vore_prefs() //Cheap hack for now to give them SOME bellies.

	//Don't set 'real_name' because then we get a nice (as sleevecard) thing.
	infomorph.name = "[initial(infomorph.name)] ([MR.mindname])"
	name = "[initial(name)] ([MR.mindname])"
	var/emoname = infomorph_emotions[1]
	setEmotion(infomorph_emotions[emoname])

	if(infomorph.client)
		return 1

	return 0

/obj/item/sleevecard/proc/removePersonality()
	if(infomorph)
		infomorph.death(0)

	turnOff()

/obj/item/sleevecard/proc/turnOff()
	if(infomorph)
		infomorph.close_up()
	cut_overlays()
	name = "[initial(name)]"

/obj/item/sleevecard/proc/setEmotion(emotion)
	if(infomorph && emotion)
		cut_overlays()
		add_overlay(emotion)
		current_emotion = emotion

/obj/item/sleevecard/emp_act(severity)
	for(var/mob/M in src)
		M.emp_act(severity)

/obj/item/sleevecard/legacy_ex_act(severity)
	if(infomorph)
		LEGACY_EX_ACT(infomorph, severity, null)
	else
		qdel(src)

/obj/item/sleevecard/see_emote(mob/living/M, text)
	if(infomorph && infomorph.client && !infomorph.canmove)
		var/rendered = "<span class='message'>[text]</span>"
		infomorph.show_message(rendered, 2)
	..()

/obj/item/sleevecard/show_message(msg, type, alt, alt_type)
	if(infomorph && infomorph.client)
		var/rendered = "<span class='message'>[msg]</span>"
		infomorph.show_message(rendered, type)
	..()
