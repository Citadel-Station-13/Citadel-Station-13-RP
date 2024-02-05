/obj/item/pen/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/modules/artwork/items/crayons.dmi'
	icon_state = "crayonred"
	w_class = ITEMSIZE_TINY
	attack_verb = list("attacked", "coloured")
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	pen_color = "#FF0000" //RGB

	/// color name
	var/crayon_color_name = "red"
	/// uses left; null for infinite
	var/remaining = 30
	/// time to draw graffiti
	var/debris_time = 5 SECONDS
	/// path to decal; must be a subtype of /obj/effect/debris/cleanable/crayon!
	var/debris_path = /obj/effect/debris/cleanable/crayon
	/// pickable colors
	var/list/crayon_pickable_colors
	/// can pick any color
	var/crayon_free_recolor = FALSE
	/// the reagents in us
	var/crayon_reagent_type = /datum/reagent/crayon_dust
	/// the reagents in us
	var/crayon_reagent_amount = 6

/obj/item/pen/crayon/Initialize(mapload)
	. = ..()
	if(!isnull(crayon_pickable_colors))
		crayon_pickable_colors = typelist(NAMEOF(src, crayon_pickable_colors), crayon_pickable_colors)
	create_reagents(crayon_reagent_amount)
	reagents.add_reagent(crayon_reagent_type, crayon_reagent_amount)

/obj/item/pen/crayon/update_name(updates)
	name = "[crayon_color_name] [initial(name)]"
	return ..()

/obj/item/pen/crayon/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Crayon")
		ui.open()

/obj/item/pen/crayon/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/item/pen/crayon/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/item/pen/crayon/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/spritesheet/crayons)

/obj/item/pen/crayon/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/item/pen/crayon/proc/make_graffiti(atom/target, datum/crayon_decal_meta/datapack, state)

/obj/item/pen/crayon/proc/color_entity(atom/target)

/obj/item/pen/crayon/proc/attempt_make_graffiti(atom/target, datum/event_args/actor/actor, datum/crayon_decal_meta/datapack, state)

/obj/item/pen/crayon/proc/attempt_color_entity(atom/target, datum/event_args/actor/actor)

/obj/item/pen/crayon/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return ..()
	#warn impl
	return ..()


/obj/item/pen/crayon/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("graffiti","rune","letter","arrow")
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				to_chat(user, "You start drawing a letter on the [target.name].")
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				to_chat(user, "You start drawing an arrow on the [target.name].")
		if(instant || do_after(user, 50))
			if(!user.Adjacent(target))
				return
			new /obj/effect/debris/cleanable/crayon(target,pen_color,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			log_game("[key_name(user)] drew [target], [pen_color], [shadeColour], [drawtype] with a crayon.")
			if(uses)
				uses--
				if(!uses)
					to_chat(user, "<span class='warning'>You used up your crayon!</span>")
					qdel(src)
	return

/obj/item/pen/crayon/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		to_chat(user, "You take a bite of the crayon and swallow it.")
		user.nutrition += 1
		user.reagents.add_reagent("crayon_dust",min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user,"<span class='warning'>You ate your crayon!</span>")
				qdel(src)
	else
		..()

/obj/item/pen/crayon/chalk/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/drawtype = input("Choose what you'd like to draw.") in list("graffiti","rune")
		switch(drawtype)
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
		if(instant || do_after(user, 50))
			if(!user.Adjacent(target))
				return
			new /obj/effect/debris/cleanable/crayon/chalk(target,pen_color,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the chalk is drawn on.
			log_game("[key_name(user)] drew [target], [pen_color], [shadeColour], [drawtype] with chalk.")
			if(uses)
				uses--
				if(!uses)
					to_chat(user, "<span class='warning'>You used up your chalk!</span>")
					qdel(src)
	return

/obj/item/pen/crayon/chalk/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		to_chat(user, "You take a bite of the chalk and swallow it.")
		user.nutrition += 1
		user.reagents.add_reagent("chalk_dust",min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user,"<span class='warning'>You ate your chalk!</span>")
				qdel(src)
	else
		..()

/obj/item/pen/crayon/red
	icon_state = "crayonred"
	pen_color = "#DA0000"
	crayon_color_name = "red"

/obj/item/pen/crayon/orange
	icon_state = "crayonorange"
	pen_color = "#FF9300"
	crayon_color_name = "orange"

/obj/item/pen/crayon/yellow
	icon_state = "crayonyellow"
	pen_color = "#FFF200"
	crayon_color_name = "yellow"

/obj/item/pen/crayon/green
	icon_state = "crayongreen"
	pen_color = "#A8E61D"
	crayon_color_name = "green"

/obj/item/pen/crayon/blue
	icon_state = "crayonblue"
	pen_color = "#00B7EF"
	crayon_color_name = "blue"

/obj/item/pen/crayon/purple
	icon_state = "crayonpurple"
	pen_color = "#DA00FF"
	crayon_color_name = "purple"

/obj/item/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	pen_color = "#FFFFFF"
	crayon_color_name = "mime"
	remaining = null
	crayon_pickable_colors = list(
		"#FFFFFF",
		"#000000",
	)

/obj/item/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	pen_color = "#FFF000"
	crayon_color_name = "rainbow"
	remaining = null
	crayon_free_recolor = TRUE
