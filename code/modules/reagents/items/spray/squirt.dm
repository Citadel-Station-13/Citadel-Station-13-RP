/obj/item/reagent_containers/spray/squirt
	name = "HydroBlaster 4000"
	desc = "A popular toy produced by Donk Co, the HydroBlaster 4000 is the latest in a long line of recreational pressurized water delivery systems."
	icon = 'icons/obj/toy.dmi'
	icon_state = "squirtgun"
	item_state = "squirtgun"
	w_class = WEIGHT_CLASS_NORMAL
	volume = 100
	var/pumped = TRUE
	materials_base = list(MAT_PLASTIC = 1500)

/obj/item/reagent_containers/spray/squirt/Initialize(mapload)
	. = ..()
	reagents.add_reagent("water", volume)

/obj/item/reagent_containers/spray/squirt/examine(mob/user, dist)
	. = ..()
	. += "The tank is [pumped ? "depressurized" : "pressurized"]."

/obj/item/reagent_containers/spray/squirt/attack_self(mob/user, datum/event_args/actor/actor)
	pumped = !pumped
	to_chat(usr, "<span class = 'notice'>You pump the handle [pumped ? "to depressurize" : "to pressurize"] the tank.</span>")

/obj/item/reagent_containers/spray/squirt/Spray_at(atom/A as mob|obj)
	if(pumped)
		to_chat(usr, "<span class = 'warning'>The tank has no pressure!</span>")
		return
	. = ..()

/obj/item/reagent_containers/spray/squirt/nt
	name = "HydroBlaster 4001"
	desc = "A popular toy produced by Donk Co, the HydroBlaster 4001 is modeled in Nanotrasen corporate colors. This is largely considered a sarcastic gesture."
	icon = 'icons/obj/toy.dmi'
	icon_state = "squirtgun_nt"
	item_state = "squirtgun_nt"
	w_class = WEIGHT_CLASS_NORMAL
	volume = 101
