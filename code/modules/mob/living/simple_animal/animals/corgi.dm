//Corgi
/mob/living/simple_mob/corgi
	name = "corgi"
	real_name = "corgi"
	desc = "It's a corgi."
	tt_desc = "E Canis lupus familiaris"
	intelligence_level = SA_ANIMAL
	icon_state = "corgi"
	icon_living = "corgi"
	icon_dead = "corgi_dead"

	run_at_them = 0
	turns_per_move = 10

	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"

	see_in_dark = 5
	mob_size = 8

	has_langs = list("Dog")
	speak_chance = 1
	speak = list("YAP", "Woof!", "Bark!", "AUUUUUU")
	speak_emote = list("barks", "woofs")
	emote_hear = list("barks", "woofs", "yaps","pants")
	emote_see = list("shakes its head", "shivers")

	meat_amount = 3
	meat_type = /obj/item/reagent_containers/food/snacks/meat/corgi

	var/obj/item/inventory_head
	var/obj/item/inventory_back

//IAN! SQUEEEEEEEEE~
/mob/living/simple_mob/corgi/Ian
	name = "Ian"
	real_name = "Ian"	//Intended to hold the name without altering it.
	gender = MALE
	desc = "It's a corgi."
	var/turns_since_scan = 0
	var/obj/movement_target
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"

/mob/living/simple_mob/corgi/Ian/Life()
	..()

	//Not replacing with SA FollowTarget mechanics because Ian behaves... very... specifically.

	//Feeding, chasing food, FOOOOODDDD
	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/obj/item/reagent_containers/food/snacks/S in oview(src,3))
					if(isturf(S.loc) || ishuman(S.loc))
						movement_target = S
						break
			if(movement_target)
				stop_automated_movement = 1
				step_to(src,movement_target,1)
				sleep(3)
				step_to(src,movement_target,1)
				sleep(3)
				step_to(src,movement_target,1)

				if(movement_target)		//Not redundant due to sleeps, Item can be gone in 6 decisecomds
					if (movement_target.loc.x < src.x)
						setDir(WEST)
					else if (movement_target.loc.x > src.x)
						setDir(EAST)
					else if (movement_target.loc.y < src.y)
						setDir(SOUTH)
					else if (movement_target.loc.y > src.y)
						setDir(NORTH)
					else
						setDir(SOUTH)

					if(isturf(movement_target.loc) )
						UnarmedAttack(movement_target)
					else if(ishuman(movement_target.loc) && prob(20))
						visible_emote("stares at the [movement_target] that [movement_target.loc] has with sad puppy eyes.")

		if(prob(1))
			visible_emote(pick("dances around","chases their tail"))
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
					setDir(i)
					sleep(1)

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well, you know..."

/mob/living/simple_mob/corgi/attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
	if(istype(O, /obj/item/newspaper))
		if(!stat)
			for(var/mob/M in viewers(user, null))
				if ((M.client && !( M.blinded )))
					M.show_message("<font color='blue'>[user] baps [name] on the nose with the rolled up [O]</font>")
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2))
					setDir(i)
					sleep(1)
	else
		..()

/mob/living/simple_mob/corgi/regenerate_icons()
	overlays = list()

	if(inventory_head)
		var/head_icon_state = inventory_head.icon_state
		if(health <= 0)
			head_icon_state += "2"

		var/icon/head_icon = image('icons/mob/corgi_head.dmi',head_icon_state)
		if(head_icon)
			overlays += head_icon

	if(inventory_back)
		var/back_icon_state = inventory_back.icon_state
		if(health <= 0)
			back_icon_state += "2"

		var/icon/back_icon = image('icons/mob/corgi_back.dmi',back_icon_state)
		if(back_icon)
			overlays += back_icon

	return

/mob/living/simple_mob/corgi/show_inv(mob/user as mob)
	user.set_machine(src)
	if(user.stat) return

	var/dat = 	"<div align='center'><b>Inventory of [name]</b></div><p>"
	if(inventory_head)
		dat +=	"<br><b>Head:</b> [inventory_head] (<a href='?src=\ref[src];remove_inv=head'>Remove</a>)"
	else
		dat +=	"<br><b>Head:</b> <a href='?src=\ref[src];add_inv=head'>Nothing</a>"
	if(inventory_back)
		dat +=	"<br><b>Back:</b> [inventory_back] (<a href='?src=\ref[src];remove_inv=back'>Remove</a>)"
	else
		dat +=	"<br><b>Back:</b> <a href='?src=\ref[src];add_inv=back'>Nothing</a>"

	user << browse(dat, text("window=mob[];size=325x500", name))
	onclose(user, "mob[real_name]")
	return

/mob/living/simple_mob/corgi/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(inventory_head && inventory_back)
		//helmet and armor = 100% protection
		if( istype(inventory_head,/obj/item/clothing/head/helmet) && istype(inventory_back,/obj/item/clothing/suit/armor) )
			if( O.force )
				to_chat(usr, "<span class='warning'>This animal is wearing too much armor. You can't cause them any damage.</span>")
				for (var/mob/M in viewers(src, null))
					M.show_message("<span class='warning'><B>[user] hits [src] with the [O], however [src] is too armored.</B></span>")
			else
				to_chat(usr, "<span class='warning'>This animal is wearing too much armor. You can't reach its skin.</span>")
				for (var/mob/M in viewers(src, null))
					M.show_message("<span class='warning'>[user] gently taps [src] with the [O].</span>")
			if(prob(15))
				visible_emote("looks at [user] with [pick("an amused","an annoyed","a confused","a resentful", "a happy", "an excited")] expression on \his face")
			return
	..()

/mob/living/simple_mob/corgi/Topic(href, href_list)
	if(usr.stat) return

	//Removing from inventory
	if(href_list["remove_inv"])
		if(!Adjacent(usr))
			return
		var/remove_from = href_list["remove_inv"]
		switch(remove_from)
			if("head")
				if(inventory_head)
					name = real_name
					desc = initial(desc)
					speak = list("YAP", "Woof!", "Bark!", "AUUUUUU")
					speak_emote = list("barks", "woofs")
					emote_hear = list("barks", "woofs", "yaps","pants")
					emote_see = list("shakes its head", "shivers")
					desc = "It's a corgi."
					inventory_head.loc = src.loc
					inventory_head = null
					regenerate_icons()
				else
					to_chat(usr, "<span class='warning'>There is nothing to remove from its [remove_from].</span>")
					return
			if("back")
				if(inventory_back)
					inventory_back.loc = src.loc
					inventory_back = null
					regenerate_icons()
				else
					to_chat(usr, "<span class='warning'>There is nothing to remove from its [remove_from].</span>")
					return

	//Adding things to inventory
	else if(href_list["add_inv"])
		if(!Adjacent(usr))
			return
		var/add_to = href_list["add_inv"]
		if(!usr.get_active_hand())
			to_chat(usr, "<span class='warning'>You have nothing in your hand to put on its [add_to].</span>")
			return
		switch(add_to)
			if("head")
				if(inventory_head)
					to_chat(usr, "<span class='warning'>It's is already wearing something.</span>")
					return
				else
					place_on_head(usr.get_active_hand())

					var/obj/item/item_to_add = usr.get_active_hand()
					if(!item_to_add)
						return

					var/list/allowed_types = list(
						/obj/item/bedsheet,
						/obj/item/clothing/glasses/sunglasses,
						/obj/item/clothing/head/caphat,
						/obj/item/clothing/head/that,
						/obj/item/clothing/head/beret,
						/obj/item/clothing/head/nursehat,
						/obj/item/clothing/head/pirate,
						/obj/item/clothing/head/ushanka,
						/obj/item/clothing/head/chefhat,
						/obj/item/clothing/head/wizard,
						/obj/item/clothing/head/wizard/fake,
						/obj/item/clothing/head/hardhat,
						/obj/item/clothing/head/hardhat/white,
						/obj/item/clothing/head/helmet,
						/obj/item/clothing/head/helmet/space/santahat,
						/obj/item/clothing/head/collectable/chef,
						/obj/item/clothing/head/collectable/police,
						/obj/item/clothing/head/collectable/wizard,
						/obj/item/clothing/head/collectable/rabbitears,
						/obj/item/clothing/head/collectable/beret,
						/obj/item/clothing/head/collectable/pirate,
						/obj/item/clothing/head/collectable/hardhat,
						/obj/item/clothing/head/collectable/captain,
						/obj/item/clothing/head/collectable/paper,
						/obj/item/clothing/head/soft
					)

					if( ! ( item_to_add.type in allowed_types ) )
						to_chat(usr, "<span class='warning'>It doesn't seem too keen on wearing that item.</span>")
						return

					usr.drop_item()

					place_on_head(item_to_add)

			if("back")
				if(inventory_back)
					to_chat(usr, "<span class='warning'>It's already wearing something.</span>")
					return
				else
					var/obj/item/item_to_add = usr.get_active_hand()
					if(!item_to_add)
						return

					//Corgis are supposed to be simpler, so only a select few objects can actually be put
					//to be compatible with them. The objects are below.

					var/list/allowed_types = list(
						/obj/item/clothing/suit/armor/vest,
						/obj/item/radio
					)

					if( ! ( item_to_add.type in allowed_types ) )
						to_chat(usr, "<span class='warning'>This object won't fit.</span>")
						return

					usr.drop_item()
					item_to_add.loc = src
					src.inventory_back = item_to_add
					regenerate_icons()
	else
		..()

/mob/living/simple_mob/corgi/proc/place_on_head(obj/item/item_to_add)
	item_to_add.loc = src
	src.inventory_head = item_to_add
	regenerate_icons()

	//Various hats and items (worn on his head) change Ian's behaviour. His attributes are reset when a HAT is removed.
	switch(inventory_head && inventory_head.type)
		if(/obj/item/clothing/head/caphat, /obj/item/clothing/head/collectable/captain)
			name = "Captain [real_name]"
			desc = "Probably better than the last captain."
/*
		if(/obj/item/clothing/head/accessory/kitty, /obj/item/clothing/head/collectable/kitty)
			name = "Runtime"
			emote_see = list("coughs up a furball", "stretches")
			emote_hear = list("purrs")
			speak = list("Purrr", "Meow!", "MAOOOOOW!", "HISSSSS", "MEEEEEEW")
			desc = "It's a cute little kitty-cat! ... wait ... what the hell?"
		if(/obj/item/clothing/head/accessory/bunny, /obj/item/clothing/head/collectable/rabbitears)
			name = "Hoppy"
			emote_see = list("twitches its nose", "hops around a bit")
			desc = "This is hoppy. It's a corgi-...urmm... bunny rabbit"
*/
		if(/obj/item/clothing/head/beret, /obj/item/clothing/head/collectable/beret)
			name = "Yann"
			desc = "Mon dieu! C'est un chien!"
			speak = list("le woof!", "le bark!", "JAPPE!!")
			emote_see = list("cowers in fear", "surrenders", "plays dead","looks as though there is a wall in front of him")
/*
		if(/obj/item/clothing/head/det_hat)
			name = "Detective [real_name]"
			desc = "[name] sees through your lies..."
			emote_see = list("investigates the area","sniffs around for clues","searches for scooby snacks")
*/
		if(/obj/item/clothing/head/nursehat)
			name = "Nurse [real_name]"
			desc = "[name] needs 100cc of beef jerky...STAT!"
		if(/obj/item/clothing/head/pirate, /obj/item/clothing/head/collectable/pirate)
			name = "[pick("Ol'","Scurvy","Black","Rum","Gammy","Bloody","Gangrene","Death","Long-John")] [pick("kibble","leg","beard","tooth","poop-deck","Threepwood","Le Chuck","corsair","Silver","Crusoe")]"
			desc = "Yaarghh!! Thar' be a scurvy dog!"
			emote_see = list("hunts for treasure","stares coldly...","gnashes his tiny corgi teeth")
			emote_hear = list("growls ferociously", "snarls")
			speak = list("Arrrrgh!!","Grrrrrr!")
		if(/obj/item/clothing/head/ushanka)
			name = "[pick("Comrade","Commissar","Glorious Leader")] [real_name]"
			desc = "A follower of Karl Barx."
			emote_see = list("contemplates the failings of the capitalist economic model", "ponders the pros and cons of vangaurdism")
		if(/obj/item/clothing/head/collectable/police)
			name = "Officer [real_name]"
			emote_see = list("drools","looks for donuts")
			desc = "Stop right there criminal scum!"
		if(/obj/item/clothing/head/wizard/fake,	/obj/item/clothing/head/wizard,	/obj/item/clothing/head/collectable/wizard)
			name = "Grandwizard [real_name]"
			speak = list("YAP", "Woof!", "Bark!", "AUUUUUU", "EI  NATH!")
		if(/obj/item/bedsheet)
			name = "\improper Ghost"
			speak = list("WoooOOOooo~","AUUUUUUUUUUUUUUUUUU")
			emote_see = list("stumbles around", "shivers")
			emote_hear = list("howls","groans")
			desc = "Spooky!"
		if(/obj/item/clothing/head/helmet/space/santahat)
			name = "Rudolph the Red-Nosed Corgi"
			emote_hear = list("barks christmas songs", "yaps")
			desc = "He has a very shiny nose."
		if(/obj/item/clothing/head/soft)
			name = "Corgi Tech [real_name]"
			desc = "The reason your yellow gloves have chew-marks."

/mob/living/simple_mob/corgi/puppy
	name = "corgi puppy"
	real_name = "corgi"
	desc = "It's a corgi puppy."
	icon_state = "puppy"
	icon_living = "puppy"
	icon_dead = "puppy_dead"

//pupplies cannot wear anything.
/mob/living/simple_mob/corgi/puppy/Topic(href, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(usr, "<font color='red'>You can't fit this on [src]</font>")
		return
	..()


//LISA! SQUEEEEEEEEE~
/mob/living/simple_mob/corgi/Lisa
	name = "Lisa"
	real_name = "Lisa"
	gender = FEMALE
	desc = "It's a corgi with a cute pink bow."
	icon_state = "lisa"
	icon_living = "lisa"
	icon_dead = "lisa_dead"
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	var/turns_since_scan = 0
	var/puppies = 0

//Lisa already has a cute bow!
/mob/living/simple_mob/corgi/Lisa/Topic(href, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(usr, "<font color='red'>[src] already has a cute bow!</font>")
		return
	..()

/mob/living/simple_mob/corgi/Lisa/Life()
	..()

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 15)
			turns_since_scan = 0
			var/alone = 1
			var/ian = 0
			for(var/mob/M in oviewers(7, src))
				if(istype(M, /mob/living/simple_mob/corgi/Ian))
					if(M.client)
						alone = 0
						break
					else
						ian = M
				else
					alone = 0
					break
			if(alone && ian && puppies < 4)
				if(near_camera(src) || near_camera(ian))
					return
				new /mob/living/simple_mob/corgi/puppy(loc)


		if(prob(1))
			visible_emote(pick("dances around","chases her tail"))
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
					setDir(i)
					sleep(1)


//Technically this should be like, its own file or something or a subset of dog but whatever. Not a coder.
/mob/living/simple_mob/corgi/tamaskan
	name = "tamaskan"
	real_name = "tamaskan"
	desc = "It's a tamaskan."
	icon_state = "tamaskan"
	icon_living = "tamaskan"
	icon_dead = "tamaskan_dead"

	retaliate = 1 //Tamaskans are bigass dogs, okay?

/mob/living/simple_mob/corgi/tamaskan/spice
	name = "Spice"
	real_name = "Spice"	//Intended to hold the name without altering it.
	gender = FEMALE
	desc = "It's a tamaskan, the name Spice can be found on its collar."
	var/turns_since_scan = 0
	var/obj/movement_target
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
