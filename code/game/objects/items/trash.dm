//Items labled as 'trash' for the trash bag.
//TODO: Make this an item var or something...

//Added by Jack Rost
/obj/item/trash
	icon = 'icons/obj/trash.dmi'
	w_class = ITEMSIZE_SMALL
	desc = "This is rubbish."

/obj/item/trash/raisins
	name = "\improper 4no raisins"
	icon_state = "4no_raisins"

/obj/item/trash/candy
	name = "candy"
	icon_state = "candy"

/obj/item/trash/candy/proteinbar
	name = "protein bar"
	icon_state = "proteinbar"

/obj/item/trash/cheesie
	name = "\improper Cheesie Honkers"
	icon_state = "cheesie_honkers"

/obj/item/trash/chips
	name = "chips"
	icon_state = "chips"

/obj/item/trash/popcorn
	name = "popcorn"
	icon_state = "popcorn"

/obj/item/trash/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"

/obj/item/trash/unajerky
	name = "Moghes Imported Sissalik Jerky"
	icon_state = "unathitinred"

/obj/item/trash/syndi_cakes
	name = "syndi cakes"
	icon_state = "syndi_cakes"

/obj/item/trash/waffles
	name = "waffles"
	icon_state = "waffles"

/obj/item/trash/plate
	name = "plate"
	icon_state = "plate"

/obj/item/trash/snack_bowl
	name = "snack bowl"
	icon_state	= "snack_bowl"

/obj/item/trash/pistachios
	name = "pistachios pack"
	icon_state = "pistachios_pack"

/obj/item/trash/semki
	name = "semki pack"
	icon_state = "semki_pack"

/obj/item/trash/tray
	name = "tray"
	icon_state = "tray"

/obj/item/trash/candle
	name = "candle"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle4"

/obj/item/trash/liquidfood
	name = "\improper \"LiquidFood\" ration"
	icon_state = "liquidfood"

/obj/item/trash/liquidprotein
	name = "\improper \"LiquidProtein\" ration"
	icon_state = "liquidprotein"

/obj/item/trash/liquidvitamin
	name = "\improper \"VitaPaste\" ration"
	icon_state = "liquidvitamin"

/obj/item/trash/tastybread
	name = "bread tube"
	icon_state = "tastybread"

/obj/item/trash/baschbeans
	name = "Basch's Baked Beans"
	icon_state = "baschbeans"

/obj/item/trash/attack(mob/M as mob, mob/living/user as mob)
	return

/obj/item/trash/creamcorn
	name = "Garm n' Bozia's Cream Corn"
	icon_state = "creamcorn"

/obj/item/trash/attack(mob/M as mob, mob/living/user as mob)
	return

// Custom garbage or whatever

/obj/item/trash/rkibble
	name = "bowl of Borg-O's"
	desc = "Contains every type of scrap material your robot puppy needs to grow big and strong."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "kibble"

/obj/item/trash/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			forceMove(H.vore_selected)
			to_chat(H, "<span class='notice'>You can taste the flavor of garbage. Wait what?</span>")
			return

	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(R.module.type == /obj/item/robot_module/robot/scrubpup) // You can now feed the trash borg yay.
			playsound(R.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			forceMove(R.vore_selected)
			R.visible_message("<span class='warning'>[user] feeds [R] with [src]!</span>")
			return
	..()

/obj/item/trash/fancyplate
	name = "dirty fancy plate"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "fancyplate"
