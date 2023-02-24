//Body snatcher. Based off the sleevemate, but instead of storing a mind it lets you swap your mind with someone. Extremely illegal and being caught with one s
/obj/item/bodysnatcher
	name = "\improper Body Snatcher Device"
	desc = "An extremely illegal tool that allows the user to swap minds with the selected humanoid victim. The LED panel on the side states 'Place both heads on the device, pull trigger, then wait for the transfer to complete.'"
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "sleevemate" //Give this a fancier sprite later.
	item_state = "healthanalyzer"
	item_flags = ITEM_NOBLUDGEON
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 200)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2, TECH_ILLEGAL = 1)

/obj/item/bodysnatcher/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	attempt_swap(target, user)

/obj/item/bodysnatcher/proc/attempt_swap(mob/living/M, mob/living/user)
	if(!isliving(M) || !isliving(user))
		return
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(ishuman(M) || issilicon(M)) //Allows body swapping with humans, synths, and pAI's/borgs since they all have a mind.
		if(user == M)
			to_chat(user,"<span class='warning'> A message pops up on the LED display, informing you that you that the mind transfer to yourself was successful... Wait, did that even do anything?</span>")
			return

		if(!M.mind) //Do they have a mind?
			to_chat(user,"<span class='warning'>A warning pops up on the device, informing you that [M] appears braindead.</span>")
			return

		if(M.stat == DEAD) //Are they dead?
			to_chat(user,"<span class='warning'>A warning pops up on the device, informing you that [M] is dead, and, as such, the mind transfer can not be done.</span>")
			return

		var/choice = alert(user,"This will swap your mind with the target's mind. This will result in them controlling your body, and you controlling their body. Continue?","Confirmation","Continue","Cancel")
		if(choice == "Continue" && user.get_active_held_item() == src && user.Adjacent(M))

			user.visible_message("<span class='warning'>[user] pushes the device up their forehead and [M]'s head, the device beginning to let out a series of light beeps!</span>","<span class='notice'>You begin swap minds with [M]!</span>")
			if(do_after(user,35 SECONDS,M))
				if(user.mind && M.mind && M.stat != DEAD && user.stat != DEAD)
					log_and_message_admins("[user.ckey] used a Bodysnatcher to swap bodies with [M.ckey]")
					to_chat(user,"<span class='notice'>Your minds have been swapped! Have a nice day.</span>")
					var/datum/mind/user_mind = user.mind
					var/datum/mind/prey_mind = M.mind
					var/target_ooc_notes = M.ooc_notes
					var/user_ooc_notes = user.ooc_notes
					M.ghostize()
					user.ghostize()
					user.mind = null
					M.mind = null
					user_mind.current = null
					prey_mind.current = null
					user_mind.active = TRUE //If they are 'active', their client is automatically pushed to the mob
					user_mind.transfer_to(M) //This works. Transfers mind & Ckey.
					prey_mind.active = TRUE
					prey_mind.transfer_to(user)
					M.ooc_notes = user_ooc_notes //Let's keep their OOC notes over to their new body.
					user.ooc_notes = target_ooc_notes
					user.sleeping = 10 //Device knocks out both the user and the target.
					user.eye_blurry = 30 //Blurry vision while they both get used to their new body's vision
					user.slurring = 50 //And let's also have them slurring while they attempt to get used to using their new body.
					if(ishuman(M)) //Let's not have the AI slurring, even though its downright hilarious.
						M.sleeping = 10
						M.eye_blurry = 30
						M.slurring = 50

	else
		to_chat(user,"<span class='warning'> A warning pops up on the LED display on the side of the device, informing you that the target is not able to have their mind swapped with!</span>")

/obj/item/bodysnatcher/attack_self(mob/living/user)
	to_chat(user,"<span class='warning'> A message pops up on the LED display, informing you that you that the mind transfer to yourself was successful... Wait, did that even do anything?</span>")
