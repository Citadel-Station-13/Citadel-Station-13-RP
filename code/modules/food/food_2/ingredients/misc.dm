/obj/item/reagent_containers/food/snacks/ingredient/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	filling_color = "#FDFFD1"
	volume = 10
	max_servings = 1

/obj/item/reagent_containers/food/snacks/ingredient/egg/Initialize(mapload)
	. = ..()
	reagents.add_reagent("egg", 3)

/obj/item/reagent_containers/food/snacks/ingredient/egg/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(istype(target,/obj/machinery/microwave))
		return ..()
	if(!((clickchain_flags & CLICKCHAIN_HAS_PROXIMITY) && target.is_open_container()))
		return
	to_chat(user, "You crack \the [src] into \the [target].")
	reagents.trans_to(target, reagents.total_volume)
	qdel(src)

/obj/item/reagent_containers/food/snacks/ingredient/egg/throw_impact(atom/hit_atom)
	. = ..()
	new/obj/effect/debris/cleanable/egg_smudge(src.loc)
	src.reagents.splash(hit_atom, reagents.total_volume)
	src.visible_message("<font color='red'>[src.name] has been squashed.</font>","<font color='red'>You hear a smack.</font>")
	qdel(src)

/obj/item/reagent_containers/food/snacks/ingredient/egg/attackby(obj/item/W as obj, mob/user as mob)
	if(istype( W, /obj/item/pen/crayon ))
		var/obj/item/pen/crayon/C = W
		var/clr = C.crayon_color_name

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(usr, "<font color=#4F49AF>The egg refuses to take on this color!</font>")
			return

		to_chat(usr, "<font color=#4F49AF>You color \the [src] [clr]</font>")
		icon_state = "egg-[clr]"
	else
		. = ..()

/obj/item/reagent_containers/food/snacks/ingredient/egg/randomized/Initialize(mapload)
	. = ..()
	var/randeggicon = pick("egg-blue","egg-green","egg-orange","egg-purple","egg-red","egg-yellow","egg-rainbow")
	icon_state = (randeggicon)

/obj/item/reagent_containers/food/snacks/ingredient/egg/blue
	icon_state = "egg-blue"

/obj/item/reagent_containers/food/snacks/ingredient/egg/green
	icon_state = "egg-green"

/obj/item/reagent_containers/food/snacks/ingredient/egg/mime
	icon_state = "egg-mime"

/obj/item/reagent_containers/food/snacks/ingredient/egg/orange
	icon_state = "egg-orange"

/obj/item/reagent_containers/food/snacks/ingredient/egg/purple
	icon_state = "egg-purple"

/obj/item/reagent_containers/food/snacks/ingredient/egg/rainbow
	icon_state = "egg-rainbow"

/obj/item/reagent_containers/food/snacks/ingredient/egg/red
	icon_state = "egg-red"

/obj/item/reagent_containers/food/snacks/ingredient/egg/yellow
	icon_state = "egg-yellow"
