////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/pill
	name = "pill"
	desc = "A pill."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "pill"
	base_icon_state = "pill"
	item_state = "pill"
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'
	rad_flags = RAD_NO_CONTAMINATE
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR

	possible_transfer_amounts = null
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_EARS
	volume = 60

	/// When set, we allow automatic naming on init.
	var/rename_with_volume = FALSE

/obj/item/reagent_containers/pill/Initialize(mapload)
	randomize_pixel_offsets()
	. = ..()
	if(!icon_state)
		icon_state = "pill[rand(1,20)]"
	if(reagents.total_volume && rename_with_volume)
		name += " ([reagents.total_volume]u)"

/obj/item/reagent_containers/pill/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	if(. != NONE)
		return
	randomize_pixel_offsets()

// todo: generic /obj/item pixel randomization
// todo: randomization must be called **before** ..() on initialize.
/obj/item/reagent_containers/pill/proc/randomize_pixel_offsets()
	set_pixel_offsets(rand(-10, 10), rand(-10, 10))

/obj/item/reagent_containers/pill/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(target == user)
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = target
			if(!H.check_has_mouth())
				to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
				return CLICKCHAIN_DO_NOT_PROPAGATE
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(!user.attempt_void_item_for_installation(src))
				return CLICKCHAIN_DO_NOT_PROPAGATE

			to_chat(target, "<span class='notice'>You swallow \the [src].</span>")
			if(reagents.total_volume)
				reagents.trans_to_mob(target, reagents.total_volume, CHEM_INGEST)
			qdel(src)
			return CLICKCHAIN_DO_NOT_PROPAGATE

	else if(istype(target, /mob/living/carbon/human))

		var/mob/living/carbon/human/H = target
		if(!H.check_has_mouth())
			to_chat(user, "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!")
			return CLICKCHAIN_DO_NOT_PROPAGATE
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
			return CLICKCHAIN_DO_NOT_PROPAGATE

		user.visible_message("<span class='warning'>[user] attempts to force [target] to swallow \the [src].</span>")

		user.setClickCooldownLegacy(user.get_attack_speed_legacy(src))
		if(!do_mob(user, target))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(!user.attempt_void_item_for_installation(src))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		user.visible_message("<span class='warning'>[user] forces [target] to swallow \the [src].</span>")
		var/contained = reagentlist()
		add_attack_logs(user,target,"Fed a pill containing [contained]")
		if(reagents && reagents.total_volume)
			reagents.trans_to_mob(target, reagents.total_volume, CHEM_INGEST)
		qdel(src)
		return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/reagent_containers/pill/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)) return

	if(target.is_open_container() && target.reagents)
		if(!target.reagents.total_volume)
			to_chat(user, "<span class='notice'>[target] is empty. Can't dissolve \the [src].</span>")
			return
		to_chat(user, "<span class='notice'>You dissolve \the [src] in [target].</span>")

		add_attack_logs(user,null,"Spiked [target.name] with a pill containing [reagentlist()]")

		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in viewers(2, user))
			O.show_message("<span class='warning'>[user] puts something in \the [target].</span>", 1)

		qdel(src)

	return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/reagent_containers/pill/antitox
	name = "Dylovene (25u)"
	desc = "Neutralizes many common toxins."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/antitox/Initialize(mapload)
	. = ..()
	reagents.add_reagent("anti_toxin", 25)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/tox
	name = "Toxins pill"
	desc = "Highly toxic."
	icon_state = "pill4"

/obj/item/reagent_containers/pill/tox/Initialize(mapload)
	. = ..()
	reagents.add_reagent("toxin", 50)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/cyanide
	name = "Strange pill"
	desc = "It's marked 'KCN'. Smells vaguely of almonds."
	icon_state = "pill9"

/obj/item/reagent_containers/pill/cyanide/Initialize(mapload)
	. = ..()
	reagents.add_reagent("cyanide", 50)


/obj/item/reagent_containers/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pillA"

/obj/item/reagent_containers/pill/adminordrazine/Initialize(mapload)
	. = ..()
	reagents.add_reagent("adminordrazine", 5)


/obj/item/reagent_containers/pill/stox
	name = "Soporific (15u)"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/stox/Initialize(mapload)
	. = ..()
	reagents.add_reagent("stoxin", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/kelotane
	name = "Kelotane (15u)"
	desc = "Used to treat burns."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/kelotane/Initialize(mapload)
	. = ..()
	reagents.add_reagent("kelotane", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/paracetamol
	name = "Paracetamol (15u)"
	desc = "Paracetamol! A painkiller for the ages. Chewables!"
	icon_state = "pill3"

/obj/item/reagent_containers/pill/paracetamol/Initialize(mapload)
	. = ..()
	reagents.add_reagent("paracetamol", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/tramadol
	name = "Tramadol (15u)"
	desc = "A simple painkiller."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/tramadol/Initialize(mapload)
	. = ..()
	reagents.add_reagent("tramadol", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/methylphenidate
	name = "Methylphenidate (15u)"
	desc = "Improves the ability to concentrate."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/methylphenidate/Initialize(mapload)
	. = ..()
	reagents.add_reagent("methylphenidate", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/citalopram
	name = "Citalopram (15u)"
	desc = "Mild anti-depressant."
	icon_state = "pill4"

/obj/item/reagent_containers/pill/citalopram/Initialize(mapload)
	. = ..()
	reagents.add_reagent("citalopram", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/dexalin
	name = "Dexalin (15u)"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/dexalin/Initialize(mapload)
	. = ..()
	reagents.add_reagent("dexalin", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/dexalin_plus
	name = "Dexalin Plus (15u)"
	desc = "Used to treat extreme oxygen deprivation."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/dexalin_plus/Initialize(mapload)
	. = ..()
	reagents.add_reagent("dexalinp", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/dermaline
	name = "Dermaline (15u)"
	desc = "Used to treat burn wounds."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/dermaline/Initialize(mapload)
	. = ..()
	reagents.add_reagent("dermaline", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/dylovene
	name = "Dylovene (15u)"
	desc = "A broad-spectrum anti-toxin."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/dylovene/Initialize(mapload)
	. = ..()
	reagents.add_reagent("anti_toxin", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/inaprovaline
	name = "Inaprovaline (30u)"
	desc = "Used to stabilize patients."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/inaprovaline/Initialize(mapload)
	. = ..()
	reagents.add_reagent("inaprovaline", 30)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/bicaridine
	name = "Bicaridine (20u)"
	desc = "Used to treat physical injuries."
	icon_state = "pill2"

/obj/item/reagent_containers/pill/bicaridine/Initialize(mapload)
	. = ..()
	reagents.add_reagent("bicaridine", 20)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/spaceacillin
	name = "Spaceacillin (10u)"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/spaceacillin/Initialize(mapload)
	. = ..()
	reagents.add_reagent("spaceacillin", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/carbon
	name = "Carbon (15u)"
	desc = "Used to neutralise chemicals in the stomach."
	icon_state = "pill3"

/obj/item/reagent_containers/pill/carbon/Initialize(mapload)
	. = ..()
	reagents.add_reagent("carbon", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/iron
	name = "Iron (15u)"
	desc = "Used to aid in blood regeneration after bleeding."
	icon_state = "pill1"

/obj/item/reagent_containers/pill/iron/Initialize(mapload)
	. = ..()
	reagents.add_reagent("iron", 15)
	color = reagents.get_color()

//Not-quite-medicine
/obj/item/reagent_containers/pill/happy
	name = "Happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill_happy"

/obj/item/reagent_containers/pill/happy/Initialize(mapload)
	. = ..()
	reagents.add_reagent("space_drugs", 15)
	reagents.add_reagent("sugar", 15)

/obj/item/reagent_containers/pill/zoom
	name = "Zoom pill"
	desc = "Zoooom!"
	icon_state = "pill4"

/obj/item/reagent_containers/pill/zoom/Initialize(mapload)
	. = ..()
	if(prob(50))
		reagents.add_reagent("mold", 2)	//Chance to be more dangerous
	reagents.add_reagent("expired_medicine", 5)
	reagents.add_reagent("stimm", 5)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/diet
	name = "diet pill"
	desc = "Guaranteed to get you slim!"
	icon_state = "pill4"

/obj/item/reagent_containers/pill/diet/Initialize(mapload)
	. = ..()
	reagents.add_reagent("lipozine", 15)
	color = reagents.get_color()

/obj/item/reagent_containers/pill/polonium
	name = "pill"
	desc = "A unlabeled pill, it seems slightly warm to the touch."
	icon_state = "yellow"

/obj/item/reagent_containers/pill/polonium/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/polonium, 5)

/obj/item/reagent_containers/pill/shredding_nanites
	name = "nanite release capsule"
	desc = "A small 'pill' full of nanites designed to be ingested. Its impossible to tell what they do while they remain in the container."
	icon_state = "pill_syndie"

/obj/item/reagent_containers/pill/shredding_nanites/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/nanite/shredding, 5)

/obj/item/reagent_containers/pill/neurophage_nanites
	name = "nanite release capsule"
	desc = "A small 'pill' full of nanites designed to be ingested. Its impossible to tell what they do while they remain in the container."
	icon_state = "pill_syndie"

/obj/item/reagent_containers/pill/neurophage_nanites/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/nanite/neurophage, 5)

/obj/item/reagent_containers/pill/irradiated_nanites
	name = "nanite release capsule"
	desc = "A small 'pill' full of nanites designed to be ingested. Its impossible to tell what they do while they remain in the container."
	icon_state = "pill_syndie"

/obj/item/reagent_containers/pill/irradiated_nanites/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/nanite/irradiated, 5)

/obj/item/reagent_containers/pill/heartkill_nanites
	name = "nanite release capsule"
	desc = "A small 'pill' full of nanites designed to be ingested. Its impossible to tell what they do while they remain in the container."
	icon_state = "pill_syndie"

/obj/item/reagent_containers/pill/heartkill_nanites/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/nanite/heartkill, 5)

/obj/item/reagent_containers/pill/healing_nanites
	name = "nanite release capsule"
	desc = "A small 'pill' full of nanites designed to be ingested. Its impossible to tell what they do while they remain in the container."
	icon_state = "pill_syndie"

/obj/item/reagent_containers/pill/healing_nanites/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/nanite/healing, 5)
