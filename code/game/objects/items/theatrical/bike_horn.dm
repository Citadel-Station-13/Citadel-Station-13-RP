// todo: /bike_horn
/**
 * Generic path for 'use inhand to make sound'.
 * todo: /obj/item/noisemaker/bike_horn & /obj/item/noisemaker/clicker ?
 * todo: when we do that, put this as objects/items/noisemaker.dm
 */
/obj/item/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	damage_force = 0
	throw_force = 0
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_HOLSTER
	throw_speed = 3
	throw_range = 15
	attack_verb = list("HONKED")

	var/last_use

	/// can be a file, soundbyte path, anything get_sfx() accepts
	var/emit_sfx = 'sound/items/bikehorn.ogg'
	var/emit_volume = 50
	var/emit_vary = TRUE
	var/emit_extra_range

	var/cooldown = 2 SECONDS

/obj/item/bikehorn/on_attack_self(datum/event_args/actor/e_args)
	. = ..()
	if(.)
		return
	if(world.time - last_use < cooldown)
		return
	last_use = world.time
	if(e_args.performer.is_holding(src))
		add_fingerprint(e_args.performer)
	emit_sound(e_args)
	return TRUE

/obj/item/bikehorn/proc/emit_sound(datum/event_args/actor/actor)
	playsound(src, emit_sfx, emit_volume, emit_vary, emit_extra_range)

/obj/item/bikehorn/golden
	name = "golden bike horn"
	desc = "Golden? Clearly, it's made with bananium! Honk!"
	icon_state = "gold_horn"
	item_state = "gold_horn"

/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"

// forgive me lohikar for i have sinned
/obj/item/bikehorn/clicker
	name = "clicker"
	desc = "Used to train pets. Pets probably aren't allowed, but here we are."
	icon = 'icons/items/noisemaker.dmi'
	icon_state = "clicker"
	base_icon_state = "clicker"
	attack_verb = list("clicked")
	worn_render_flags = WORN_RENDER_INHAND_NO_RENDER // no inhands for now

	emit_sfx = /datum/soundbyte/clicker
	emit_volume = 75

	var/frame_color = "#ffffff"

/obj/item/bikehorn/clicker/Initialize(mapload, frame_color)
	if(frame_color)
		src.frame_color = frame_color
	update_icon()
	return ..()

/obj/item/bikehorn/clicker/update_icon()
	cut_overlays()
	. = ..()
	var/image/frame_overlay = image(icon, "[base_icon_state]-frame")
	frame_overlay.color = frame_color
	add_overlay(frame_overlay)

/obj/item/bikehorn/clicker/random

/obj/item/bikehorn/clicker/random/Initialize(mapload)
	frame_color = pick(
		"#ff0000",
		"#00ff00",
		"#0000ff",
		"#ffff00",
		"#00ffff",
		"#ff00ff",
		"#aa00ff",
		"#ff7700",
		"#222222",
		"#553a23",
	)
	return ..()
