/obj/item/reagent_containers/food/drinks/shaker
	name = "shaker"
	desc = "A metal shaker to mix drinks in. Can be shaken vigorously in your hand."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = list("x"=17, "y"=10)


/obj/item/reagent_containers/food/drinks/shaker/attack_self(mob/user)

	playsound(loc, "sound/items/shaker.ogg", 75, 1, -1)
	if(prob(50))
		user.visible_message("<span class='rose'>With an almost casual flick, [user] spins [src] in their hands, thoroughly mixing it.</span>")
	else
		user.visible_message("<span class='rose'>[user] shakes [src], mixing the contents up.</span>")
