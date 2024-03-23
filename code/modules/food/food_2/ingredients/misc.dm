/obj/item/reagent_containers/food/snacks/ingredient/egg
	name = "egg"
	desc = "An egg!"
	cookstage_information = list(list(0, 0.5, "raw egg and shell"), list(20 SECONDS, 1.2, "cooked egg"), list(40 SECONDS, 0.7, "overcooked egg"), list(90 SECONDS, 0.1, "sad, burnt egg"))
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


/obj/item/reagent_containers/food/snacks/ingredient/tofu
	name = "Tofu"
	desc = "We all love tofu."
	cookstage_information = list(list(0, 0.7, "fresh raw tofu"), list(20 SECONDS, 1.2, "cooked tofu"), list(40 SECONDS, 0.7, "overcooked tofu"), list(90 SECONDS, 0.1, "burnt tofu"))
	filling_color = "#FFFEE0"
	icon_state = "tofu"
	nutriment_amt = 6
	nutriment_desc = list("tofu" = 3, "goeyness" = 3)

/obj/item/reagent_containers/food/snacks/ingredient/tofu/Initialize(mapload)
	. = ..()
	src.bitesize = 3


/obj/item/reagent_containers/food/snacks/ingredient/cheesewheel
	name = "cheese wheel"
	desc = "A big wheel of delcious space cheese."
	icon_state = "cheesewheel"
	slice_path = /obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	cookstage_information = list(list(0, 1, "cheese"), list(20 SECONDS, 1.2, "cheese"), list(40 SECONDS, 0.7, "cheese"), list(90 SECONDS, 0.1, "burnt cheese"))
	slices_num = 6
	filling_color = "#FFF700"
	nutriment_amt = 10
	max_servings = 1

/obj/item/reagent_containers/food/snacks/ingredient/cheesewheel/Initialize(mapload)
	. = ..()
	reagents.add_reagent("protein", 10)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ingredient/cheesewedge
	name = "cheese wedge"
	desc = "A wedge of delicious space cheese. The wheel it was cut from can't have gone far."
	cookstage_information = list(list(0, 1, "cheese"), list(20 SECONDS, 1.2, "cheese"), list(40 SECONDS, 0.7, "cheese"), list(90 SECONDS, 0.1, "burnt cheese"))
	icon_state = "cheesewedge"
	filling_color = "#FFF700"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ingredient/bluecheesewheel
	name = "blue cheese wheel"
	desc = "A big wheel of mold-infused blue cheese."
	cookstage_information = list(list(0, 1, "tangy, creamy cheese with sharp notes of butyric acid"), list(20 SECONDS, 1.2, "tangy, creamy cheese with sharp notes of butyric acid"), list(40 SECONDS, 0.7, "tangy, creamy cheese with sharp notes of butyric acid"), list(90 SECONDS, 0.1, "burnt cheese"))
	icon_state = "bluecheesewheel"
	slice_path = /obj/item/reagent_containers/food/snacks/ingredient/bluecheesewedge
	slices_num = 6
	filling_color = "#f1f0c8"
	nutriment_amt = 10
	max_servings = 1

/obj/item/reagent_containers/food/snacks/ingredient/bluecheesewheel/Initialize(mapload)
	. = ..()
	reagents.add_reagent("protein", 10)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ingredient/bluecheesewedge
	name = "blue cheese wedge"
	desc = "A wedge of mold-infused blue cheese. The wheel it was cut from can't have gone far."
	cookstage_information = list(list(0, 1, "tangy, creamy cheese with sharp notes of butyric acid"), list(20 SECONDS, 1.2, "tangy, creamy cheese with sharp notes of butyric acid"), list(40 SECONDS, 0.7, "tangy, creamy cheese with sharp notes of butyric acid"), list(90 SECONDS, 0.1, "burnt cheese"))
	icon_state = "bluecheesewedge"
	filling_color = "#f1f0c8"
	bitesize = 2
