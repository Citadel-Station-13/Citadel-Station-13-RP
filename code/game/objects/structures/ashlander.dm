//As part of the Phase 3 expansions, Ashlanders are receiving some dedicated structures.
//One of these is a functional forge where they can produce metal rods and lead sheets.
//Another is a bricklayer that will compress sandstone blocks for construction.
/obj/structure/ashlander
	name = "ashlander structure"
	desc = "Woah! You shouldn't be seeing me, outlander! Report me to the Buried Ones at once!"
	icon = 'icons/obj/lavaland.dmi'
	density = TRUE
	anchored = TRUE

/obj/structure/ashlander/production
	name = "abstract machine"
	desc = "You shouldn't be able to see this. Contact an admin."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "forge"
	var/list/ore_mapping = list()
	var/default_message = "..."
	var/list/insert_msg_override = list()

/obj/structure/ashlander/production/attackby(var/obj/item/I, mob/user)
	. = ..()
	var/msg = insert_msg_override[I.type] || default_message
	if(istype(I, /obj/item/ore))
		to_chat(user, "<span class='danger'>You pour the [I] into the [src]! [msg]</span>")
		attempt_consume()
	if(istype(I, /obj/item/storage/bag))
		var/obj/item/storage/bag/B = I
		var/inserted = 0
		for(I in B)
			if(attempt_consume(I, user))
				inserted++
		if(inserted)
			user.action_feedback(SPAN_NOTICE("You insert [inserted] units of material from [B] into [src]. [msg]"), src)
		else
			user.action_feedback(SPAN_WARNING("You fail to insert anything from [B] into [src]."), src)
	else if(attempt_consume(I, user))
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/**
 * Attempts to consume a piece of ore
 *
 * @params
 * * inserting - what they're trying to put into us
 * * user - optional: the user doing it
 *
 * @return TRUE / FALSE based on success / failure.
 */

/obj/structure/ashlander/production/proc/attempt_consume(obj/item/ore/O, mob/user)
	if (!istype(O))
		return FALSE

    /// Ensure the ore is able to be put in if it's being held / in inventory
	if(!isnull(user) && user.is_holding(O) && !user.transfer_item_to_loc(O, src))
		user.action_feedback(SPAN_WARNING("[O] is stuck to your hand!"), src)
		return FALSE

	for (var/ty in ore_mapping)
		if (istype(O, ty))
			var/target_type = ore_mapping[ty]
			new target_type(get_turf(src))
			qdel(O)
			return TRUE

	return FALSE

/obj/structure/ashlander/production/forge
	name = "magma forge"
	desc = "A primitive forge of Scorian design. It is used primarily to convert iron and lead into more workable shapes."
	default_message = "It begins to melt in the crucible."
	ore_mapping = list(
		/obj/item/ore/lead = /obj/item/stack/material/lead,
        /obj/item/ore/copper = /obj/item/stack/material/copper,
		/obj/item/ore/iron = /obj/item/stack/rods,
		/obj/item/ore/glass = /obj/item/ore/slag
    )
	insert_msg_override = list(
		/obj/item/ore/iron = "It slowly feeds through the extruder."
	)

/obj/structure/ashlander/production/brickmaker
	name = "brick press"
	desc = "Scori have been observed using this device to compress sand and clay into hardened bricks."
	icon_state = "brickmaker"
	default_message = "It is slowly compacted by the press."
	ore_mapping = list(
		/obj/item/ore/glass = /obj/item/stack/material/sandstone
	)

/obj/structure/ashlander/production/brickmaker/attackby(obj/item/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/ore/glass))
		to_chat(user, "<span class='danger'>You pour the [O] into the [src]! After some work you compress it into a sturdy brick.</span>")
		qdel(O)
		var/turf/T = get_turf(src)
		new /obj/item/stack/material/sandstone(T)

//This is a child of the Hydroponics seed extractor, and was originally in that file. But I've moved it here since it's an Ashlander "machine".
/obj/machinery/seed_extractor/press
	name = "primitive press"
	desc = "A hand crafted press and sieve designed to extract seeds from fruit."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "press"
	use_power = USE_POWER_OFF

//This is a child of the juicer/all-in-one grinder/reagent grinder. Just for some fun alchemy.

/obj/machinery/reagentgrinder/ashlander
	name = "basic alchemical station"
	desc = "A primitive assembly designed to hold a mortar and pestle."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "alchemy1"
	density = FALSE
	anchored = FALSE
	use_power = USE_POWER_OFF
	circuit = null
	no_panel = TRUE

/obj/machinery/reagentgrinder/ashlander/Initialize(mapload, newdir)
	. = ..()
	beaker = new /obj/item/reagent_containers/glass/stone(src)

/obj/machinery/reagentgrinder/ashlander/update_icon()
	icon_state = "alchemy"+num2text(!isnull(beaker))
	return

/obj/machinery/reagentgrinder/ashlander/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(beaker)
		if(default_deconstruction_screwdriver(user, O))
			return
		if(default_deconstruction_crowbar(user, O))
			return

	if (istype(O,/obj/item/reagent_containers/glass) || \
		istype(O,/obj/item/reagent_containers/food/drinks/glass2) || \
		istype(O,/obj/item/reagent_containers/food/drinks/shaker))

		if (beaker)
			return 1
		else
			if(!user.attempt_insert_item_for_installation(O, src))
				return
			beaker = O
			update_icon()
			updateUsrDialog()
			return 0

	if(holdingitems && holdingitems.len >= limit)
		to_chat(user, "The assembly cannot hold anymore items.")
		return 1

	if(!istype(O))
		return

	if(istype(O,/obj/item/storage/bag/plants))
		var/obj/item/storage/bag/plants/bag = O
		var/failed = 1
		for(var/obj/item/G in O.contents)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			bag.remove_from_storage(G, src)
			holdingitems += G
			if(holdingitems && holdingitems.len >= limit)
				break

		if(failed)
			to_chat(user, "Nothing in the plant bag is usable.")
			return 1

		if(!O.contents.len)
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")

		src.updateUsrDialog()
		return 0

	if(!sheet_reagents[O.type] && (!O.reagents || !O.reagents.total_volume))
		to_chat(user, "\The [O] is not suitable for reduction.")
		return 1
	if(!user.attempt_insert_item_for_installation(O, src))
		return

	holdingitems += O
	src.updateUsrDialog()
	return 0

/obj/machinery/reagentgrinder/ashlander/grind()

	// Sanity check.
	if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return

	playsound(src, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
	inuse = 1

	// Reset the machine.
	spawn(60)
		inuse = 0

	// Process.
	for (var/obj/item/O in holdingitems)

		var/remaining_volume = beaker.reagents.maximum_volume - beaker.reagents.total_volume
		if(remaining_volume <= 0)
			break

		if(sheet_reagents[O.type])
			var/obj/item/stack/stack = O
			if(istype(stack))
				var/list/sheet_components = sheet_reagents[stack.type]
				var/amount_to_take = max(0,min(stack.amount,round(remaining_volume/REAGENTS_PER_SHEET)))
				if(amount_to_take)
					stack.use(amount_to_take)
					if(QDELETED(stack))
						holdingitems -= stack
					if(islist(sheet_components))
						amount_to_take = (amount_to_take/(sheet_components.len))
						for(var/i in sheet_components)
							beaker.reagents.add_reagent(i, (amount_to_take*REAGENTS_PER_SHEET))
					else
						beaker.reagents.add_reagent(sheet_components, (amount_to_take*REAGENTS_PER_SHEET))
					continue

		if(O.reagents)
			O.reagents.trans_to_obj(beaker, min(O.reagents.total_volume, remaining_volume))
			if(O.reagents.total_volume == 0)
				holdingitems -= O
				qdel(O)
			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

//Calcinator
//"A very basic implement that burns things down into ash. Pretty simple. Almost a waste to create it."
//The above is the note I wrote for this when I started. Obviously now it's gigantic.
/obj/structure/ashlander/calcinator
	name = "calcinator"
	desc = "This carved basin is used in alchemy to reduce an item down to ashes, thereby releasing its inner properties."
	icon_state = "calcinator1"
	var/obj/item/reagent_containers/beaker

/obj/structure/ashlander/calcinator/Initialize(mapload, newdir)
	. = ..()
	beaker = new /obj/item/reagent_containers/glass/stone(src)

/obj/structure/ashlander/calcinator/update_icon()
	icon_state = "calcinator"+num2text(!isnull(beaker))
	return

/obj/structure/ashlander/calcinator/attackby(obj/item/I as obj, mob/user as mob)
	if(!istype(I))
		return
	if (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
		return
	if(istype(I,/obj/item/reagent_containers/glass/stone))
		if(beaker)
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		else
			beaker = I
			update_icon()
			updateUsrDialog()
			return 0

	if(istype(I,/obj/item/stack/material/wood))
		if(!beaker)
			return
		else
			var/obj/item/stack/material/wood/W = I
			if(W.get_amount() < 1)
				return
			else if(do_after(user, 10))
				W.use(1)
				user.visible_message("<span class='notice'>[user] feeds \the [W] into \the [src].</span>","<span class='notice'>You reduce \the [W] using \the [src].</span>")
				playsound(loc, 'sound/weapons/gun_flamethrower3.ogg', 50, 1)
				beaker.reagents.add_reagent("ash", 10)

	if(istype(I,/obj/item/stack/material/bone))
		if(!beaker)
			return
		else
			var/obj/item/stack/material/bone/W = I
			if(W.get_amount() < 1)
				return
			else if(do_after(user, 10))
				W.use(1)
				user.visible_message("<span class='notice'>[user] feeds \the [W] into \the [src].</span>","<span class='notice'>You reduce \the [W] using \the [src].</span>")
				playsound(loc, 'sound/weapons/gun_flamethrower3.ogg', 50, 1)
				beaker.reagents.add_reagent("ash", 10)

	src.updateUsrDialog()
	return 0

/obj/structure/ashlander/calcinator/attack_hand(mob/user, list/params)
	interact(user)

/obj/structure/ashlander/calcinator/AltClick(mob/user)
	. = ..()
	if(user.incapacitated() || !Adjacent(user))
		return
	replace_beaker(user)

/obj/structure/ashlander/calcinator/interact(mob/user)
	if(user.incapacitated())
		return
	if(beaker)
		replace_beaker(user)

/obj/structure/ashlander/calcinator/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(!user)
		return FALSE
	if(beaker)
		if(!user.incapacitated() && Adjacent(user) && !isrobot(user))
			user.put_in_hands(beaker)
		else
			beaker.forceMove(drop_location())
		beaker = null
	if(new_beaker)
		beaker = new_beaker
	update_icon()
	return TRUE

//Ashies gotta eat.
/obj/machinery/appliance/cooker/grill/spit
	name = "cooking spit"
	desc = "Primitive structures such as these have been used to cook raw meat for as long as the benefits of such a practice have been known."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "spitgrill_off"
	food_color = "#630905"
	on_icon = "spitgrill_on"
	off_icon = "spitgrill_off"
	max_contents = 1
	container_type = /obj/item/reagent_containers/cooking_container/grill/spit
	use_power = USE_POWER_OFF
	var/lit = 0

/obj/machinery/appliance/cooker/grill/spit/attempt_toggle_power(mob/user)
	if (!isliving(user))
		return

	if (!user.IsAdvancedToolUser())
		to_chat(user, "You lack the dexterity to do that!")
		return

	if (user.stat || user.restrained() || user.incapacitated())
		return

	if (!Adjacent(user) && !issilicon(user))
		to_chat(user, "You can't reach [src] from here.")
		return

	if (!lit) //It's not lit.
		machine_stat &= ~POWEROFF
		lit = 1
		user.visible_message("[user] ignites the flame beneath the [src].", "You ignite the flame under the [src].")

	else //Its on, turn it off.
		lit = 0
		user.visible_message("[user] douses the flame of the [src].", "You douse the flame.")

	playsound(src, 'sound/weapons/gun_flamethrower2.ogg', 40, 1)
	update_icon()

/obj/machinery/appliance/cooker/grill/spit/update_icon()
	. = ..()
	if(lit)
		set_light(3, 2, "#FF9933")
		icon_state = "[on_icon]"
	else
		set_light(0)
		icon_state = "[off_icon]"

/obj/structure/ashlander/statue
	name = "religious statue"
	desc = "This statue depicts the Mother, one of the Buried Ones. It has been carved from one giant piece of elderstone. It seems to glow faintly, and the distant ring of the chiming stone fills the air around it. The Mother can be seen standing proudly, one arm outstretched. Floating above her open hand somehow is a small, polished sphere of pure elderstone."
	icon_state = "mother_statue"

/obj/structure/ashlander/statue/Initialize(mapload)
	. = ..()
	set_light(3, 2, "#9463bb")

/obj/structure/ashlander/statue/attack_hand(mob/user, list/params)
	var/choice = tgui_alert(user, "Do you wish to pray to the statue?", "Interact With the Statue", list("Yes", "No"))
	if(choice != "Yes")
		return
	else
		user.visible_message("[user] prays before the [src].", "You pray before the [src].")
		Bless()

/obj/structure/ashlander/statue/proc/Bless(mob/user)
	var/mob/living/carbon/human/H = usr
	if(!H.faction == "lavaland")
		to_chat(user, "<span class='danger'>You feel as if an eye briefly regards you, and then turns away.</span>")
	else
		H.add_modifier(/datum/modifier/ashlander_blessing, 15 MINUTES)

/datum/modifier/ashlander_blessing
	name = "The Mother's Blessing"
	desc = "You feel as if a higher power is protecting you."
	stacks = MODIFIER_STACK_FORBID
	pain_immunity = TRUE
	incoming_tox_damage_percent = 0.25
	incoming_fire_damage_percent = 0.75
	evasion = 5
	on_created_text = "<span class='notice'>You feel safe and content. There is a sense that someone is watching over you.</span>"
	on_expired_text = "<span class='notice'>The feeling that you are being protected fades, but the sense of contentment lingers.</span>"

//Ashlander Cryo
/obj/machinery/cryopod/robot/door/travel/ashlander
	name = "Warrens Passage"
	desc = "A mildly obscured passage down into the deep warrens of Surt-nar-Cthardamz."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "golicryo_0"
	base_icon_state = "golicryo_0"
	occupied_icon_state = "golicryo_1"
	announce_channel = "Mercenary"
	on_store_message = "has descended into the Dark Below."
	on_store_name = "The Mother"
	on_enter_visible_message = "begins descending into the"
	on_enter_occupant_message = "The goliath hide cloak flutters behind you as you begin to walk down the hand-carved stairs."
	on_store_visible_message_1 = "echoes with fading footsteps"
	on_store_visible_message_2 = "to the dark below."

//Ashlander Chem Master
/obj/machinery/chem_master/ashlander
	name = "advanced alchemical station"
	desc = "A finely carved bone cabinet designed to hold stone mortars for precise mixing and alchemical work."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "ashchem0"
	base_icon_state = "ashchem"
	use_power = USE_POWER_OFF
	//primi = TRUE

/obj/machinery/chem_master/ashlander/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemPrimi", name)
		ui.open()
