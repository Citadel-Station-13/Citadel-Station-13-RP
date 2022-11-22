/*
 * Screwdriver
 */
/obj/item/tool/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwwy with this."
	icon = 'icons/obj/tools.dmi'
	icon_state = "screwdriver"
	item_state = "screwdriver"
	slot_flags = SLOT_BELT | SLOT_EARS
	tool_behaviour = TOOL_SCREWDRIVER
	force = 6
	w_class = ITEMSIZE_TINY
	throw_force = 5
	throw_speed = 3
	throw_range = 5
	hitsound = 'sound/weapons/bladeslice.ogg'
	tool_sound = 'sound/items/screwdriver.ogg'
	drop_sound = 'sound/items/drop/screwdriver.ogg'
	pickup_sound = 'sound/items/pickup/screwdriver.ogg'
	matter = list(MAT_STEEL = 75)
	attack_verb = list("stabbed")
	sharp  = 1
	tool_speed = 1
	var/random_color = TRUE

/obj/item/tool/screwdriver/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	user.visible_message(pick("<span class='danger'>\The [user] is stabbing the [src.name] into [TU.his] temple! It looks like [TU.hes] trying to commit suicide.</span>", \
						"<span class='danger'>\The [user] is stabbing the [src.name] into [TU.his] heart! It looks like [TU.hes] trying to commit suicide.</span>"))
	return(BRUTELOSS)

/obj/item/tool/screwdriver/Initialize(mapload)
	. = ..()
	if(random_color)
		switch(pick("red","blue","purple","brown","green","cyan","yellow"))
			if ("red")
				icon_state = "screwdriver2"
				item_state = "screwdriver"
			if ("blue")
				icon_state = "screwdriver"
				item_state = "screwdriver_blue"
			if ("purple")
				icon_state = "screwdriver3"
				item_state = "screwdriver_purple"
			if ("brown")
				icon_state = "screwdriver4"
				item_state = "screwdriver_brown"
			if ("green")
				icon_state = "screwdriver5"
				item_state = "screwdriver_green"
			if ("cyan")
				icon_state = "screwdriver6"
				item_state = "screwdriver_cyan"
			if ("yellow")
				icon_state = "screwdriver7"
				item_state = "screwdriver_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)

/obj/item/tool/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M) || user.a_intent == "help")
		return ..()
	if(user.zone_sel.selecting != O_EYES && user.zone_sel.selecting != BP_HEAD)
		return ..()
	if((MUTATION_CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)

/obj/item/tool/screwdriver/bone
	name = "primitive screwdriver"
	desc = "A whittled bone with a tapered point, used to remove screws, or stab."
	icon_state = "screwdriver_bone"
	random_color = FALSE
	tool_speed = 1.25

/obj/item/tool/screwdriver/brass
	name = "brass screwdriver"
	desc = "A screwdriver with a very sharp tip, that ensures fine deliberate adjustments."
	icon_state = "screwdriver_brass"
	tool_speed = 0.75
	random_color = FALSE

/datum/category_item/catalogue/anomalous/precursor_a/alien_screwdriver
	name = "Precursor Alpha Object - Hard Light Torgue Tool"
	desc = "This appears to be a tool, with a solid handle, and a thin hard light \
	shaft, with a tip at the end. On the handle appears to be two mechanisms that \
	causes the hard light section to spin at a high speed while held down, in a \
	similar fashion as an electric drill. One makes it spin clockwise, the other \
	counter-clockwise.\
	<br><br>\
	The hard light tip is able to shift its shape to a degree when pressed into \
	a solid receptacle. This allows it to be able to function on many kinds of \
	fastener, which includes the screws."
	value = CATALOGUER_REWARD_EASY

/obj/item/tool/screwdriver/alien
	name = "alien screwdriver"
	desc = "An ultrasonic screwdriver."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_screwdriver)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "screwdriver_a"
	item_state = "screwdriver_black"
	tool_sound = 'sound/items/pshoom.ogg'
	tool_speed = 0.1
	random_color = FALSE

/obj/item/tool/screwdriver/hybrid
	name = "strange screwdriver"
	desc = "A strange conglomerate of a screwdriver."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_screwdriver)
	icon_state = "hybscrewdriver"
	item_state = "screwdriver_black"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	slowdown = 0.1
	w_class = ITEMSIZE_NORMAL
	tool_sound = 'sound/effects/uncloak.ogg'
	tool_speed = 0.4
	random_color = FALSE
	reach = 2



/obj/item/tool/screwdriver/cyborg
	name = "powered screwdriver"
	desc = "An electrical screwdriver, designed to be both precise and quick."
	tool_sound = 'sound/items/drill_use.ogg'
	tool_speed = 0.5

/obj/item/tool/screwdriver/RIGset
	name = "integrated screwdriver"
	desc = "If you're seeing this, someone did a dum-dum."
	tool_sound = 'sound/items/drill_use.ogg'
	tool_speed = 0.7

/obj/item/tool/screwdriver/power
	name = "hand drill"
	desc = "A simple powered hand drill. It's fitted with a screw bit."
	icon_state = "drill_screw"
	item_state = "drill"
	matter = list(MAT_STEEL = 150, MAT_SILVER = 50)
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	slot_flags = SLOT_BELT
	force = 8
	w_class = ITEMSIZE_SMALL
	throw_force = 8
	throw_speed = 2
	throw_range = 3//it's heavier than a screw driver/wrench, so it does more damage, but can't be thrown as far
	attack_verb = list("drilled", "screwed", "jabbed", "whacked")
	hitsound = 'sound/items/drill_hit.ogg'
	tool_sound = 'sound/items/drill_use.ogg'
	tool_speed = 0.25
	random_color = FALSE
	var/obj/item/tool/wrench/power/counterpart = null

/obj/item/tool/screwdriver/power/Initialize(mapload, no_counterpart = TRUE)
	. = ..()
	if(!counterpart && no_counterpart)
		counterpart = new(src, FALSE)
		counterpart.counterpart = src

/obj/item/tool/screwdriver/power/Destroy()
	if(counterpart)
		counterpart.counterpart = null // So it can qdel cleanly.
		QDEL_NULL(counterpart)
	return ..()

/obj/item/tool/screwdriver/power/attack_self(mob/user)
	playsound(get_turf(user),'sound/items/change_drill.ogg',50,1)
	user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
	if(!user.put_in_active_hand(counterpart))
		counterpart.forceMove(get_turf(src))
	forceMove(counterpart)
	to_chat(user, "<span class='notice'>You attach the bolt driver bit to [src].</span>")
