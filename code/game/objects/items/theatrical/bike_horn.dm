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
	throw_force = 3
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

/obj/item/bikehorn/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(world.time - last_use < cooldown)
		return
	last_use = world.time
	playsound(src, emit_sfx, emit_volume, emit_vary, emit_extra_range)
	add_fingerprint(user)

/obj/item/bikehorn/golden
	name = "golden bike horn"
	desc = "Golden? Clearly, it's made with bananium! Honk!"
	icon_state = "gold_horn"
	item_state = "gold_horn"

// forgive me lohikar for i have sinned
/obj/item/bikehorn/clicker
	name = "clicker"
	desc = "Used to train pets. Pets probably aren't allowed, but here we are."
	icon = 'icons/items/noisemaker.dmi'
	icon_state = "clicker"
	base_icon_state = "clicker"

	emit_sfx = /datum/soundbyte/effects/clicker_1
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
	var/image/frame_overlay = image(icon, base_icon_state)
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
