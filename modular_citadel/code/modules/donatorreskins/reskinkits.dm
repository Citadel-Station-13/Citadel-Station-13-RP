//Welcome to the reskin kits. Use the ones below as a guide to add your own. It's fairly straight foward, and should be relatively fill-in-the-blanks.


/obj/item/reskin_kit/jenna //path
	name = "silver helmet kit" //name of the KIT, not the reskinned item
	desc = "a modkit for making a voidsuit helmet into a silver helmet" //desc of the KIT, not the reskinned item
	icon = 'icons/obj/storage.dmi' //icon of the KIT, not the reskinned item
	icon_state = "box" //icon_state of the KIT, not the reskinned item
	var/product = /obj/item/clothing/head/helmet/space/void/security/jenna //what it makes
	var/list/fromitem = /obj/item/clothing/head/helmet/space/void/security //what it needs
	afterattack(obj/O, mob/user as mob) //after being used
		if(istype(O, product)) // Checks what it was used on
			to_chat(user,"<span class='warning'>[O] is already modified!") //If it's being used on an already reskinned item
		else if(O.type == fromitem) //makes sure O is the right thing
			new product(usr.loc) //spawns the product
			user.visible_message("<span class='warning'>[user] modifies [O]!","<span class='warning'>You modify the [O]!") //Tells the user it's been done
			qdel(O) //Gets rid of the unskinned item
			qdel(src) //gets rid of the kit
		else
			to_chat(user, "<span class='warning'> You can't modify [O] with this kit!</span>") //Tells the user they have the wrong item type.