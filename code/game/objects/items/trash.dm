//Items labled as 'trash' for the trash bag.
//TODO: Make this an item var or something...

//Added by Jack Rost
/obj/item/trash
	icon = 'icons/obj/trash.dmi'
	w_class = ITEMSIZE_SMALL
	desc = "This is rubbish."
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

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
	name = "Moghes Imported Sissalik Jerky tin"
	icon_state = "unathitinred"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

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

/obj/item/trash/lollipop_stick
	name = "used lollipop stick"
	icon = 'icons/obj/food.dmi'
	icon_state = "lollipop_stick"

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
			if(!user.attempt_insert_item_for_installation(src, H.vore_selected))
				return
			playsound(H,'sound/items/eatfood.ogg', rand(10,50), 1)
			to_chat(H, "<span class='notice'>You can taste the flavor of garbage. Wait what?</span>")
			return

	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(R.module.type == /obj/item/robot_module/robot/scrubpup) // You can now feed the trash borg yay.
			if(!user.attempt_insert_item_for_installation(src, R.vore_selected))
				return
			playsound(R,'sound/items/eatfood.ogg', rand(10,50), 1)
			R.visible_message("<span class='warning'>[user] feeds [R] with [src]!</span>")
			return
	..()

/obj/item/trash/fancyplate
	name = "dirty fancy plate"
	icon = 'icons/obj/trash_vr.dmi'
	icon_state = "fancyplate"

//IED Component
/obj/item/trash/punctured_can
	name = "\improper punctured container"
	desc = "This drink container has had a hole punched into the side, rendering it useless."
	icon_state = "punctured"
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

/obj/item/trash/broken_arrow
	name = "\improper broken arrow"
	desc = "This arrow shaft shattered under the stress of impact. It's useless."
	icon_state = "brokenarrow"

/obj/item/trash/brownies
	name = "brownie tray"
	icon_state = "waffles"

/obj/item/trash/snacktray
	name = "snacktray"
	icon_state = "waffles"

/obj/item/trash/dipbowl
	name = "dip bowl"
	icon_state = "waffles"

/obj/item/trash/chipbasket
	name = "empty basket"
	icon_state = "waffles"

//Tyrmalin Imported Foods
/obj/item/trash/cavemoss
	name = "Momma Toecutter's Cavemoss"
	icon_state = "cavemoss_can"

/obj/item/trash/diggerstew
	name = "Momma Toecutter's Canned Digger's Stew"
	icon_state = "diggerstew_can"

/obj/item/trash/canned_beetles
	name = "Grom's Green Ham In a Can"
	icon_state = "canned_beetles"

/obj/item/trash/rust_can
	name = "Iron Soup"
	icon_state = "rust_can"

/obj/item/trash/alraune_bar
	name = "Alraune snack bar"
	icon_state = "alraunesnack"

/obj/item/trash/bugsnacks
	name = "Bugsnacks"
	icon_state = "bugsnacks"
	
/obj/item/trash/brainsnaxtrash
	name = "\improper BrainSnax can"
	icon_state = "brainsnaxtrash"
