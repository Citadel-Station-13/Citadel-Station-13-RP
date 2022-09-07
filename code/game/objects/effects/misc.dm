//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'icons/obj/items.dmi'
	icon_state = "strangepresent"
	density = 1
	anchored = 0

// this is banned, use temporary-visual - kevinz000
/obj/effect/temporary_effect
	name = "self deleting effect"
	desc = "How are you examining what which cannot be seen?"
	icon = 'icons/effects/effects.dmi'
	invisibility = 0
	var/time_to_die = 10 SECONDS // Afer which, it will delete itself.

/obj/effect/temporary_effect/Initialize(mapload)
	. = ..()
	if(time_to_die)
		QDEL_IN(src, time_to_die)

// Shown really briefly when attacking with axes.
/obj/effect/temporary_effect/cleave_attack
	name = "cleaving attack"
	desc = "Something swinging really wide."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "cleave"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	time_to_die = 6
	alpha = 140
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = -32

/obj/effect/temporary_effect/cleave_attack/Initialize(mapload) // Makes the slash fade smoothly. When completely transparent it should qdel itself.
	. = ..()
	animate(src, alpha = 0, time = time_to_die - 1)

/obj/effect/temporary_effect/shuttle_landing
	name = "shuttle landing"
	desc = "You better move if you don't want to go splat!"
	icon_state = "shuttle_warning_still"
	time_to_die = 4.9 SECONDS

/obj/effect/temporary_effect/shuttle_landing/Initialize(mapload)
	flick("shuttle_warning", src) // flick() forces the animation to always begin at the start.
	. = ..()

// The manifestation of Zeus's might. Or just a really unlucky day.
// This is purely a visual effect, this isn't the part of the code that hurts things.
/obj/effect/temporary_effect/lightning_strike
	name = "lightning"
	desc = "How <i>shocked</i> you must be, to see this text. You must have <i>lightning</i> reflexes. \
	The humor in this description is just so <i>electrifying</i>."
	icon = 'icons/effects/96x256.dmi'
	icon_state = "lightning_strike"
	plane = ABOVE_LIGHTING_PLANE
	time_to_die = 1 SECOND
	pixel_x = -32

/obj/effect/temporary_effect/lightning_strike/Initialize(mapload)
	icon_state += "[rand(1,2)]" // To have two variants of lightning sprites.
	animate(src, alpha = 0, time = time_to_die - 1)
	. = ..()


//Makes a tile fully lit no matter what
/obj/effect/fullbright
	icon = 'icons/effects/alphacolors.dmi'
	icon_state = "white"
	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER
	blend_mode = BLEND_ADD

/obj/effect/dummy/lighting_obj
	name = "lighting fx obj"
	desc = "Tell a coder if you're seeing this."
	icon_state = "nothing"
	light_color = "#FFFFFF"
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/dummy/lighting_obj/Initialize(mapload, _color, _range, _power, _duration)
	. = ..()
	set_light(_range ? _range : light_range, _power ? _power : light_power, _color ? _color : light_color)
	if(_duration)
		QDEL_IN(src, _duration)

/obj/effect/dummy/lighting_obj/moblight
	name = "mob lighting fx"

/obj/effect/dummy/lighting_obj/moblight/Initialize(mapload, _color, _range, _power, _duration)
	. = ..()
	if(!ismob(loc))
		return INITIALIZE_HINT_QDEL

//Passive Horror Aura for Horrors and Abominations
/obj/effect/horror_aura
	name = "horror aura"
	desc = "An intrinsic aura emitted by all paranatural entities. Theorized to be some manner of bleed effect from the strain of existing in the material world."
	icon_state = "nothing"
	light_range = 0
	light_power = 0
	light_color = "#ff0000"

/obj/effect/horror_aura/process()
	for(var/mob/living/carbon/human/H in view(7,src))
		if(!iscultist(H) && !istype(H.head, /obj/item/clothing/head/helmet/para))
			H.hallucination = max(10 SECONDS)
		var/range_red //Utilizes the same EMP process as Cult EMP spells.
		var/turf/T = get_turf(src)
		if(T)
			T.hotspot_expose(700,125)
			empulse(src, (range_red - 3), (range_red - 2), (range_red - 1), range_red)
