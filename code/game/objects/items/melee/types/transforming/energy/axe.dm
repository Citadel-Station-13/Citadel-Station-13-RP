
/obj/item/melee/transforming/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "energy_axe"
	base_icon_state = "energy_axe"
	damage_force = 20
	throw_force = 10
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4)
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	can_cleave = TRUE

	active_damage_force = 60
	active_throw_force = 35
	active_weight_class = WEIGHT_CLASS_HUGE
	active_damage_type = DAMAGE_TYPE_SEARING

/obj/item/melee/transforming/energy/axe/on_activate(datum/event_args/actor/actor, silent)
	. = ..()
	actor.chat_feedback(
		SPAN_WARNING("You energize \the [src]."),
		target = src,
	)

/obj/item/melee/transforming/energy/axe/on_deactivate(datum/event_args/actor/actor, silent)
	. = ..()
	actor.chat_feedback(
		SPAN_WARNING("You de-energize \the [src]."),
		target = src,
	)

/obj/item/melee/transforming/energy/axe/charge
	name = "charge axe"
	desc = "An energised axe."
	active_damage_force = 30
	active_throw_force = 20
	damage_tier = 4
	damage_force = 15
	use_cell = TRUE
	hitcost = 120

/obj/item/melee/transforming/energy/axe/charge/loaded/Initialize(mapload)
	. = ..()
	bcell = new/obj/item/cell/device/weapon(src)
