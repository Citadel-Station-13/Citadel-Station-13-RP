/obj/item/picket_sign
	icon_state = "picket"
	name = "blank picket sign"
	desc = "It's blank."
	damage_force = 5
	w_class = WEIGHT_CLASS_BULKY
	attack_verb = list("bashed","smacked")

	var/label = ""
	var/last_wave = 0

/obj/item/picket_sign/cyborg
	name = "metallic nano-sign"
	desc = "A high tech picket sign used by silicons that can reprogram its surface at will. Probably hurts to get hit by, too."
	damage_force = 13

/obj/item/picket_sign/proc/retext(mob/user)
	var/txt = stripped_input(user, "What would you like to write on the sign?", "Sign Label", null , 30)
	if(txt)
		label = txt
		name = "[label] sign"
		desc =	"It reads: [label]"

/obj/item/picket_sign/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/pen/crayon))
		retext(user)
	else
		return ..()

/obj/item/picket_sign/attack_self(mob/user, datum/event_args/clickchain/e_args)
	. = ..()
	if(.)
		return
	if( last_wave + 20 < world.time )
		last_wave = world.time
		if(label)
			user.visible_message("<span class='warning'>[user] waves around \the \"[label]\" sign.</span>")
		else
			user.visible_message("<span class='warning'>[user] waves around blank sign.</span>")
