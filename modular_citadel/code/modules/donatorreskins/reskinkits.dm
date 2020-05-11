//Welcome to the reskin kits. Use the ones below as a guide to add your own. It's fairly straight foward, and should be relatively fill-in-the-blanks.
//THIS STUFF NEEDS REFACTORING, MORE OBJECT ORIENTED STUFF - KEV
/obj/item/reskin_kit
	name = "broken reskin kit"		//These variables are for the kit, not the item!
	desc = "CODER MAN BAD"
	icon = 'icons/obj/storage.dmi'
	icon_state = "box"
	var/product			//what it makes - TODO: refactor
	var/fromitem		//Path that it works on

/obj/item/reskin_kit/afterattack(obj/O, mob/user)
	if(istype(O, product)) // Checks what it was used on
		to_chat(user,"<span class='warning'>[O] is already modified!</span>") //If it's being used on an already reskinned item
	else if(O.type == fromitem) //makes sure O is the right thing
		new product(user.drop_location()) //spawns the product
		user.visible_message("<span class='warning'>[user] modifies [O]!</span>","<span class='warning'>You modify the [O]!</span>") //Tells the user it's been done
		qdel(O) //Gets rid of the unskinned item
		qdel(src) //gets rid of the kit
	else
		to_chat(user, "<span class='warning'> You can't modify [O] with this kit!</span>") //Tells the user they have the wrong item type.

/obj/item/reskin_kit/jenna
	name = "silver's helmet kit"
	desc = "A modkit for making a security voidsuit helmet into Silver's Helmet"
	product = /obj/item/clothing/head/helmet/space/void/security/jenna
	fromitem = /obj/item/clothing/head/helmet/space/void/security

/obj/item/reskin_kit/stunsword
	name = "stunsword kit"
	desc = "A modkit for making a stunbaton into a wicked stunsword. Remove cell before use."
	product = /obj/item/melee/baton/stunsword //what it makes
	fromitem = /obj/item/melee/baton/loaded // sec lockers use this, doesnt work on others.
