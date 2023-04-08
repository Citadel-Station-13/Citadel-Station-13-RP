/**
 * The light item
 * Can be tube or bulb subtypes.
 * Will fit into empty /obj/machinery/light of the corresponding type.
 */
/obj/item/light
	icon = 'icons/obj/lighting.dmi'
	damage_force = 2
	throw_force = 5
	w_class = ITEMSIZE_TINY
	materials = list(MAT_STEEL = 60)
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

	/// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/status = 0
	/// number of times switched
	var/switchcount = 0
	/// true if rigged to explode
	var/rigged = 0
	var/broken_chance = 0

	///how much light it gives off
	var/brightness_range = 8
	var/brightness_power = 0.8
	var/brightness_color = LIGHT_COLOR_HALOGEN

	var/nightshift_range = 6
	var/nightshift_power = 0.4
	var/nightshift_color = LIGHT_COLOR_NIGHTSHIFT

/obj/item/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_icon_state = "ltube"
	item_state = "c_tube"
	materials = list(MAT_GLASS = 100)
	brightness_range = 8
	brightness_power = 0.8
	brightness_color = LIGHT_COLOR_HALOGEN

	nightshift_range = 6
	nightshift_power = 0.4

/obj/item/light/tube/large
	w_class = ITEMSIZE_SMALL
	name = "large light tube"
	brightness_range = 8
	brightness_power = 1

//! ## Colored Light Tubes

//! Standard Rainbow
/obj/item/light/tube/red
	color = LIGHT_COLOR_RED
	brightness_color = LIGHT_COLOR_RED

/obj/item/light/tube/orange
	color = LIGHT_COLOR_ORANGE
	brightness_color = LIGHT_COLOR_ORANGE

/obj/item/light/tube/yellow
	color = LIGHT_COLOR_YELLOW
	brightness_color = LIGHT_COLOR_YELLOW

/obj/item/light/tube/green
	color = LIGHT_COLOR_GREEN
	brightness_color = LIGHT_COLOR_GREEN

/obj/item/light/tube/blue
	color = LIGHT_COLOR_BLUE
	brightness_color = LIGHT_COLOR_BLUE

/obj/item/light/tube/purple
	color = LIGHT_COLOR_PURPLE
	brightness_color = LIGHT_COLOR_PURPLE

//! Neons
/obj/item/light/tube/neon_pink
	color = "#e00f8e"
	brightness_color = "#e00f8e"

/obj/item/light/tube/neon_blue
	color = "#0fa7e0"
	brightness_color = "#0fa7e0"

/obj/item/light/tube/neon_green
	color = "#91ff00"
	brightness_color = "#91ff00"

/obj/item/light/tube/neon_yellow
	color = "#fbff00"
	brightness_color = "#fbff00"

/obj/item/light/tube/neon_white
	color = "#ffffff"
	brightness_color = "#ffffff"

/obj/item/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_icon_state = "lbulb"
	item_state = "contvapour"
	materials = list(MAT_GLASS = 100)
	brightness_color = LIGHT_COLOR_TUNGSTEN

	brightness_range = 4

	nightshift_range = 4
	nightshift_power = 0.4

/obj/item/light/throw_impact(atom/hit_atom)
	..()
	shatter()

//! ## Colored Light Bulbs

//! Standard Rainbow
/obj/item/light/bulb/red
	color = "#da0205"
	brightness_color = "#da0205"

/obj/item/light/bulb/orange
	color = "#da7c02"
	brightness_color = "#da7c02"

/obj/item/light/bulb/yellow
	color = "#e0d100"
	brightness_color = "#e0d100"

/obj/item/light/bulb/green
	color = "#1db100"
	brightness_color = "#1db100"

/obj/item/light/bulb/blue
	color = "#0011ff"
	brightness_color = "#0011ff"

/obj/item/light/bulb/purple
	color = "#7902da"
	brightness_color = "#7902da"

//! Neons
/obj/item/light/bulb/neon_pink
	color = "#e00f8e"
	brightness_color = "#e00f8e"

/obj/item/light/bulb/neon_blue
	color = "#0fa7e0"
	brightness_color = "#0fa7e0"

/obj/item/light/bulb/neon_green
	color = "#91ff00"
	brightness_color = "#91ff00"

/obj/item/light/bulb/neon_yellow
	color = "#fbff00"
	brightness_color = "#fbff00"

/obj/item/light/bulb/neon_white
	color = "#ffffff"
	brightness_color = "#ffffff"

/obj/item/light/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "fbulb"
	base_icon_state = "fbulb"
	item_state = "egg4"
	materials = list(MAT_GLASS = 100)

/// Fairylights
/obj/item/light/bulb/fairy
	name = "fairy light bulb"
	desc = "A tiny replacement light bulb."
	icon_state = "fbulb"
	base_icon_state = "fbulb"
	materials = list(MAT_GLASS = 10)
	brightness_range = 5

// update the icon state and description of the light
/obj/item/light/update_icon()
	switch(status)
		if(LIGHT_OK)
			icon_state = base_icon_state
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "[base_icon_state]-burned"
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "[base_icon_state]-broken"
			desc = "A broken [name]."


/obj/item/light/Initialize(mapload, obj/machinery/light/fixture)
	. = ..()
	if(fixture)
		status = fixture.status
		rigged = fixture.rigged
		switchcount = fixture.switchcount
		fixture.transfer_fingerprints_to(src)

		//shouldn't be necessary to copy these unless someone varedits stuff, but just in case
		brightness_range = fixture.brightness_range
		brightness_power = fixture.brightness_power
		brightness_color = fixture.brightness_color
	update_icon()


// attack bulb/tube with object
// if a syringe, can inject phoron to make it explode
/obj/item/light/attackby(obj/item/I, mob/user)
	..()
	if(istype(I, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = I

		to_chat(user, "You inject the solution into the [src].")

		if(S.reagents.has_reagent("phoron", 5))

			log_admin("LOG: [user.name] ([user.ckey]) injected a light with phoron, rigging it to explode.")
			message_admins("LOG: [user.name] ([user.ckey]) injected a light with phoron, rigging it to explode.")

			rigged = 1

		S.reagents.clear_reagents()
	else
		..()
	return

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm
/obj/item/light/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != INTENT_HARM)
		return

	shatter()

/obj/item/light/proc/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		src.visible_message(
			SPAN_DANGER("[name] shatters."),
			SPAN_DANGER("You hear a small glass object shatter."),
			SPAN_DANGER("You hear a small glass object shatter."),
		)
		status = LIGHT_BROKEN
		damage_force = 5
		sharp = 1
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, TRUE)
		update_icon()


//? Used for some shuttles.
/obj/machinery/light/small/readylight
	brightness_range = 5
	brightness_power = 1
	brightness_color = "#DA0205"
	var/state = 0

/obj/machinery/light/small/readylight/proc/set_state(new_state)
	state = new_state
	if(state)
		brightness_color = "00FF00"
	else
		brightness_color = initial(brightness_color)
	update()
