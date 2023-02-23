/* Pens!
 * Contains:
 *		Pens
 *		Sleepy Pens
 *		Parapens
 *		Crayons
 *		Markers
 *		Ritual Chalk
 *		Charcoal
 */


/*
 * Pens
 */
/obj/item/pen
	desc = "It's a normal black ink pen."
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	slot_flags = SLOT_BELT | SLOT_EARS
	throw_force = 0
	w_class = ITEMSIZE_TINY
	throw_speed = 7
	throw_range = 15
	matter = list(MAT_STEEL = 10)
	var/colour = "black"	//what colour the ink is!
	pressure_resistance = 2
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/pen/attack_self(var/mob/user)
	if(user.next_move > world.time)
		return
	user.setClickCooldown(1 SECOND)
	to_chat(user, "<span class='notice'>Click.</span>")
	playsound(src, 'sound/items/penclick.ogg', 50, 1)

/obj/item/pen/blue
	desc = "It's a normal blue ink pen."
	icon_state = "pen_blue"
	colour = "blue"

/obj/item/pen/red
	desc = "It's a normal red ink pen."
	icon_state = "pen_red"
	colour = "red"

/obj/item/pen/fountain
	desc = "A well made fountain pen."
	icon_state = "pen_fountain"

/obj/item/pen/multi
	desc = "It's a pen with multiple colors of ink!"
	var/selectedColor = 1
	var/colors = list("black","blue","red")

/obj/item/pen/AltClick(mob/user)
	to_chat(user, "<span class='notice'>Click.</span>")
	playsound(src, 'sound/items/penclick.ogg', 50, 1)
	return

/obj/item/pen/multi/attack_self(mob/user)
	if(++selectedColor > 3)
		selectedColor = 1

	colour = colors[selectedColor]

	if(colour == "black")
		icon_state = "pen"
	else
		icon_state = "pen_[colour]"

	to_chat(user, "<span class='notice'>Changed color to '[colour].'</span>")

/obj/item/pen/click
	name = "clicker pen"

/obj/item/pen/click/attack_self(mob/user as mob)
	if(user.a_intent == INTENT_HELP)
		user.visible_message("<span class='notice'><b>\The [user]</b> clicks [src] idly.</span>","<span class='notice'>You click [src] idly.</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 20, 1)
	else if (user.a_intent == INTENT_HARM)
		user.visible_message("<span class='warning'><b>\The [user]</b> clicks [src] angrily!</span>","<span class='warning'>You click [src] angrily!</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 20, 1)
	else if (user.a_intent == INTENT_GRAB)
		user.visible_message("<span class='warning'><b>\The [user]</b> spins [src] in their fingers!</span>","<span class='warning'>You spin [src] in your fingers!</span>")
	else
		user.visible_message("<span class='notice'><b>\The [user]</b> clicks [src] rhythmically.</span>","<span class='notice'>You click [src] rhythmically.</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 20, 1)

/obj/item/pen/invisible
	desc = "It's an invisble pen marker."
	icon_state = "pen"
	colour = "white"

/*
 * Reagent pens
 */

/obj/item/pen/reagent
	atom_flags = OPENCONTAINER
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/pen/reagent/Initialize(mapload)
	. = ..()
	create_reagents(30)

/obj/item/pen/reagent/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	. = ..()
	var/mob/living/L = target
	if(istype(L))
		return
	if(L.can_inject(user,1))
		if(reagents.total_volume)
			if(target.reagents)
				var/contained = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(target, 30, CHEM_BLOOD)
				add_attack_logs(user,target,"Injected with [src.name] containing [contained], trasferred [trans] units")

/*
 * Blade pens.
 */

/obj/item/pen/blade
	desc = "It's a normal black ink pen."
	description_antag = "This pen can be transformed into a dangerous melee and thrown assassination weapon with an Alt-Click.\
	When active, it cannot be caught safely."
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	slot_flags = SLOT_BELT | SLOT_EARS
	throw_force = 3
	w_class = ITEMSIZE_TINY
	throw_speed = 7
	throw_range = 15
	armor_penetration = 20

	var/active = 0
	var/active_embed_chance = 0
	var/active_force = 15
	var/active_throwforce = 30
	var/active_w_class = ITEMSIZE_NORMAL
	var/active_icon_state
	var/default_icon_state

/obj/item/pen/blade/Initialize(mapload)
	. = ..()
	active_icon_state = "[icon_state]-x"
	default_icon_state = icon_state

/obj/item/pen/blade/AltClick(mob/user)
	..()
	if(active)
		deactivate(user)
	else
		activate(user)

	to_chat(user, "<span class='notice'>You [active ? "de" : ""]activate \the [src]'s blade.</span>")

/obj/item/pen/blade/proc/activate(mob/living/user)
	if(active)
		return
	active = 1
	icon_state = active_icon_state
	embed_chance = active_embed_chance
	force = active_force
	throw_force = active_throwforce



	sharp = 1
	edge = 1
	w_class = active_w_class
	playsound(src, 'sound/weapons/saberon.ogg', 15, 1)
	damtype = SEARING
	item_flags |= ITEM_THROW_UNCATCHABLE

	attack_verb |= list(\
		"slashed",\
		"cut",\
		"shredded",\
		"stabbed"\
		)

/obj/item/pen/blade/proc/deactivate(mob/living/user)
	if(!active)
		return
	playsound(src, 'sound/weapons/saberoff.ogg', 15, 1)
	active = 0
	icon_state = default_icon_state
	embed_chance = initial(embed_chance)
	force = initial(force)
	throw_force = initial(throw_force)
	sharp = initial(sharp)
	edge = initial(edge)
	w_class = initial(w_class)
	damtype = BRUTE
	item_flags &= ~ITEM_THROW_UNCATCHABLE

/obj/item/pen/blade/blue
	desc = "It's a normal blue ink pen."
	icon_state = "pen_blue"
	colour = "blue"

/obj/item/pen/blade/red
	desc = "It's a normal red ink pen."
	icon_state = "pen_red"
	colour = "red"

/obj/item/pen/blade/fountain
	desc = "A well made fountain pen."
	icon_state = "pen_fountain"

/*
 * Sleepy Pens
 */
/obj/item/pen/reagent/sleepy
	desc = "It's a black ink pen with a sharp point and a carefully engraved \"Waffle Co.\""
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/pen/reagent/sleepy/Initialize(mapload)
	. = ..()
	reagents.add_reagent("chloralhydrate", 1)
	reagents.add_reagent("stoxin", 14)


/*
 * Parapens
 */
/obj/item/pen/reagent/paralysis
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/pen/reagent/paralysis/Initialize(mapload)
	. = ..()
	reagents.add_reagent("zombiepowder", 5)
	reagents.add_reagent("cryptobiolin", 10)

/*
 * Chameleon pen
 */
/obj/item/pen/chameleon
	var/signature = ""

/obj/item/pen/chameleon/attack_self(mob/user as mob)
	/*
	// Limit signatures to official crew members
	var/personnel_list[] = list()
	for(var/datum/data/record/t in data_core.locked) //Look in data core locked.
		personnel_list.Add(t.fields["name"])
	personnel_list.Add("Anonymous")

	var/new_signature = input("Enter new signature pattern.", "New Signature") as null|anything in personnel_list
	if(new_signature)
		signature = new_signature
	*/
	signature = sanitize(input("Enter new signature. Leave blank for 'Anonymous'", "New Signature", signature))

/obj/item/pen/proc/get_signature(var/mob/user)
	return (user && user.real_name) ? user.real_name : "Anonymous"

/obj/item/pen/chameleon/get_signature(var/mob/user)
	return signature ? signature : "Anonymous"

/obj/item/pen/chameleon/verb/set_colour()
	set name = "Change Pen Colour"
	set category = "Object"

	var/list/possible_colours = list ("Yellow", "Green", "Pink", "Blue", "Orange", "Cyan", "Red", "Invisible", "Black")
	var/selected_type = input("Pick new colour.", "Pen Colour", null, null) as null|anything in possible_colours

	if(selected_type)
		switch(selected_type)
			if("Yellow")
				colour = COLOR_YELLOW
			if("Green")
				colour = COLOR_LIME
			if("Pink")
				colour = COLOR_PINK
			if("Blue")
				colour = COLOR_BLUE
			if("Orange")
				colour = COLOR_ORANGE
			if("Cyan")
				colour = COLOR_CYAN
			if("Red")
				colour = COLOR_RED
			if("Invisible")
				colour = COLOR_WHITE
			else
				colour = COLOR_BLACK
		to_chat(usr, "<span class='info'>You select the [lowertext(selected_type)] ink container.</span>")


/*
 * Crayons
 */

/obj/item/pen/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = ITEMSIZE_TINY
	attack_verb = list("attacked", "coloured")
	colour = "#FF0000" //RGB
	var/shadeColour = "#220000" //RGB
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/pen/crayon/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	to_chat(viewers(user),"<font color='red'><b>[user] is jamming the [src.name] up [TU.his] nose and into [TU.his] brain. It looks like [TU.he] [TU.is] trying to commit suicide.</b></font>")
	return (BRUTELOSS|OXYLOSS)

/obj/item/pen/crayon/Initialize(mapload)
	. = ..()
	name = "[colourName] crayon"

/obj/item/pen/crayon/marker
	name = "marker"
	desc = "A chisel-tip permanent marker. Hopefully non-toxic."
	icon_state = "markerred"

/obj/item/pen/crayon/marker/Initialize(mapload)
	. = ..()
	name = "[colourName] marker"

/obj/item/pen/crayon/chalk
	name = "ritual chalk"
	desc = "A stick of blessed chalk, used in rituals."
	icon_state = "chalkwhite"

/obj/item/pen/crayon/chalk/Initialize(mapload)
	. = ..()
	name = "[colourName] chalk"

/obj/item/pen/crayon/chalk/attack_self()
	return

/obj/item/pen/charcoal
	name = "charcoal stick"
	desc = "Carefully burnt carbon, compacted and held together with a binding agent. One of the oldest common implements for writing across the galaxy."
	icon_state = "charcoal"
	matter = list(MAT_CARBON = 10)
