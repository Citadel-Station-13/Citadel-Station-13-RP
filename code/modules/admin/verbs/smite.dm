/client/proc/smite(mob/victim as mob)
	set name = "Smite"
	set desc = "Abuse a player with various 'special treatments' from a list."
	set category = "Fun"
	if(!check_rights(R_FUN))
		return

	if(!victim)
		victim = input("Select a player", "Who?") as null|mob in GLOB.player_list

	if(!ishuman(victim))
		return

	var/mob/living/carbon/human/target = victim

	var/list/smite_types = list(
		SMITE_BREAKLEGS,
		SMITE_BLUESPACEARTILLERY,
		SMITE_SPONTANEOUSCOMBUSTION,
		SMITE_LIGHTNINGBOLT,
		SMITE_DISLOCATEALL,
		SMITE_AUTOSAVE,
		SMITE_AUTOSAVE_WIDE,
		SMITE_DARKSPACE_ABDUCT,
		SMITE_DROP_LIMB_RANDOM,
		SMITE_DROP_LIMB_ALL,
		SMITE_DROP_LIMB_PICK
		)

	var/smite_choice = input("Select the type of SMITE for [target]","SMITE Type Choice") as null|anything in smite_types
	if(!smite_choice)
		return

	switch(smite_choice)
		if(SMITE_BREAKLEGS)
			var/broken_legs = 0
			var/obj/item/organ/external/left_leg = target.get_organ(BP_L_LEG)
			if(left_leg && left_leg.fracture())
				broken_legs++
			var/obj/item/organ/external/right_leg = target.get_organ(BP_R_LEG)
			if(right_leg && right_leg.fracture())
				broken_legs++
			if(!broken_legs)
				to_chat(src,"[target] didn't have any breakable legs, sorry.")

		if(SMITE_DISLOCATEALL)
			var/obj/item/organ/external/left_leg = target.get_organ(BP_L_LEG)
			left_leg.dislocate()
			var/obj/item/organ/external/right_leg = target.get_organ(BP_R_LEG)
			right_leg.dislocate()
			var/obj/item/organ/external/left_arm = target.get_organ(BP_L_ARM)
			left_arm.dislocate()
			var/obj/item/organ/external/right_arm = target.get_organ(BP_R_ARM)
			right_arm.dislocate()
			var/obj/item/organ/external/head = target.get_organ(BP_HEAD)
			head.dislocate()

		if(SMITE_DROP_LIMB_PICK)
			var/picked_organ_tag = input("Select the limb you wanna remove of [target]","Limb Choice") as null|anything in list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM,BP_R_FOOT,BP_L_FOOT, BP_R_HAND, BP_L_HAND)
			var/obj/item/organ/external/limb = target.get_organ(picked_organ_tag)
			to_chat(target, SPAN_ALERTSYNDIE("Your sins have cost you your [limb.name]"))
			limb?.droplimb(FALSE, pick(DROPLIMB_EDGE,DROPLIMB_BURN,DROPLIMB_BLUNT))

		if(SMITE_DROP_LIMB_RANDOM)
			var/rand_organ_tag = pick(BP_L_LEG, BP_R_LEG)
			var/obj/item/organ/external/limb = target.get_organ(rand_organ_tag)
			limb?.droplimb(FALSE, pick(DROPLIMB_EDGE,DROPLIMB_BURN,DROPLIMB_BLUNT))
			rand_organ_tag = pick(BP_L_ARM, BP_R_ARM)
			limb = target.get_organ(rand_organ_tag)
			limb?.droplimb(FALSE, pick(DROPLIMB_EDGE,DROPLIMB_BURN,DROPLIMB_BLUNT))
			to_chat(target, SPAN_ALERTSYNDIE("Your sins have cost you an arm and an leg"))

		if(SMITE_DROP_LIMB_ALL)
			for( var/limb_tag in list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM))
				var/obj/item/organ/external/limb = target.get_organ(limb_tag)
				limb?.droplimb(FALSE, pick(DROPLIMB_EDGE,DROPLIMB_BURN,DROPLIMB_BLUNT))
			to_chat(target, SPAN_ALERTSYNDIE(pick("The gods have bestowed you nuggethood", "The gods crave McDonalds", "The gods have turned you into a fucknugget")))

		if(SMITE_BLUESPACEARTILLERY)
			bluespace_artillery(target,src)

		if(SMITE_SPONTANEOUSCOMBUSTION)
			target.adjust_fire_stacks(10)
			target.IgniteMob()
			target.visible_message("<span class='danger'>[target] bursts into flames!</span>")

		if(SMITE_LIGHTNINGBOLT)
			var/turf/T = get_step(get_step(target, NORTH), NORTH)
			T.Beam(target, icon_state="lightning[rand(1,12)]", time = 5)
			target.electrocute_act(75,def_zone = BP_HEAD)
			target.visible_message("<span class='danger'>[target] is struck by lightning!</span>")
		if(SMITE_AUTOSAVE)
			fake_autosave(target, src)

		if(SMITE_AUTOSAVE_WIDE)
			fake_autosave(target, src, TRUE)

		if(SMITE_DARKSPACE_ABDUCT)
			darkspace_abduction(target, src)

		else
			return //Injection? Don't print any messages.

	log_and_message_admins("[key_name(src)] has used SMITE ([smite_choice]) on [key_name(target)].")
	feedback_add_details("admin_verb","SMITE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/bluespace_artillery(mob/living/target, user)
	if(!istype(target))
		return

	if(BSACooldown)
		if(user)
			to_chat(user,"<span class='warning'>BSA is still cooling down, please wait!</span>")
		return

	BSACooldown = 1
	spawn(50)
		BSACooldown = 0

	to_chat(target,"You've been hit by bluespace artillery!")
	log_and_message_admins("[key_name(target)] has been hit by Bluespace Artillery fired by [key_name(user ? user : usr)]")

	var/obj/effect/stop/S
	S = new /obj/effect/stop
	S.victim = target
	S.loc = target.loc
	spawn(20)
		qdel(S)

	var/turf/simulated/floor/T = get_turf(target)
	if(istype(T))
		if(prob(80))	T.break_tile_to_plating()
		else			T.break_tile()

	if(target.health == 1)
		target.gib()
	else
		target.adjustBruteLoss( min( 99 , (target.health - 1) )    )
		target.Stun(20)
		target.Weaken(20)
		target.stuttering = 20

/proc/fake_autosave(var/mob/living/target, var/client/user, var/wide)
	if(!istype(target) || !target.client)
		to_chat(user, "<span class='warning'>Skipping [target] because they are not a /mob/living or have no client.</span>")
		return

	if(wide)
		for(var/mob/living/L in orange(user.view, user.mob))
			fake_autosave(L, user)
		return

	target.applyMoveCooldown(10 SECONDS)

	to_chat(target, "<span class='notice' style='font: small-caps bold large monospace!important'>Autosaving your progress, please wait...</span>")
	target << 'sound/effects/ding.ogg'

	var/static/list/bad_tips = list(
		"Did you know that black shoes protect you from electrocution while hacking?",
		"Did you know that airlocks always have a wire that disables ID checks?",
		"You can always find at least 3 pairs of glowing purple gloves in maint!",
		"Phoron is not toxic if you've had a soda within 30 seconds of exposure!",
		"Space Mountain Wind makes you immune to damage from space for 30 seconds!",
		"A mask and air tank are all you need to be safe in space!",
		"When exploring maintenance, wearing no shoes makes you move faster!",
		"Did you know that the bartender's shotgun is loaded with harmless ammo?",
		"Did you know that the tesla and singulo only need containment for 5 minutes?",
		"Did you know that Admins can't ban you if you don't give them consent?")

	var/tip = pick(bad_tips)
	to_chat(target, "<span class='notice' style='font: small-caps bold large monospace!important'>Tip of the day:</span><br><span class='notice'>[tip]</span>")

	var/atom/movable/screen/loader = new(target)
	loader.name = "Autosaving..."
	loader.desc = "A disc icon that represents your game autosaving. Please wait."
	loader.icon = 'icons/obj/discs_vr.dmi'
	loader.icon_state = "quicksave"
	loader.screen_loc = "NORTH-1, EAST-1"
	target.client.screen += loader

	spawn(10 SECONDS)
		if(target)
			to_chat(target, "<span class='notice' style='font: small-caps bold large monospace!important'>Autosave complete!</span>")
			if(target.client)
				target.client.screen -= loader


/proc/darkspace_abduction(mob/living/target, user)
	var/darkspace_abduction_z
	if(darkspace_abduction_z < 0)
		to_chat(user,"<span class='warning'>The abduction z-level is already being created. Please wait.</span>")
		return
	if(!darkspace_abduction_z)
		darkspace_abduction_z = -1
		to_chat(user,"<span class='warning'>This is the first use of the verb this shift, it will take a minute to configure the abduction z-level. It will be z[world.maxz+1].</span>")
		var/z = world.increment_max_z()
		var/area/areaInstance = new /area/darkspace_abduction(null)
		areaInstance.addSorted()
		for(var/x = 1 to world.maxx)
			for(var/y = 1 to world.maxy)
				var/turf/T = locate(x,y,z)
				T.ChangeTurf(/turf/unsimulated/fake_space)
				T.plane = -100
				areaInstance.contents.Add(T)
				CHECK_TICK
		darkspace_abduction_z = z

	if(!target || !user)
		return

	var/size_of_square = 26
	var/halfbox = round(size_of_square*0.5)
	target.transforming = TRUE
	to_chat(target,"<span class='danger'>You feel a strange tug, deep inside. You're frozen in momentarily...</span>")
	to_chat(user,"<span class='notice'>Beginning vis_contents copy to abduction site, player mob is frozen.</span>")
	sleep(1 SECOND)
	//Lower left corner of a working box
	var/llc_x = max(0,halfbox-target.x) + min(target.x+halfbox, world.maxx) - size_of_square
	var/llc_y = max(0,halfbox-target.y) + min(target.y+halfbox, world.maxy) - size_of_square

	//Copy them all
	for(var/x = llc_x to llc_x+size_of_square)
		for(var/y = llc_y to llc_y+size_of_square)
			var/turf/T_src = locate(x,y,target.z)
			var/turf/T_dest = locate(x,y,darkspace_abduction_z)
			T_dest.vis_contents.Cut()
			T_dest.vis_contents += T_src
			T_dest.density = T_src.density
			T_dest.opacity = T_src.opacity
			CHECK_TICK

	//Feather the edges
	for(var/x = llc_x to llc_x+1) //Left
		for(var/y = llc_y to llc_y+size_of_square)
			if(prob(50))
				var/turf/T = locate(x,y,darkspace_abduction_z)
				T.density = FALSE
				T.opacity = FALSE
				T.vis_contents.Cut()

	for(var/x = llc_x+size_of_square-1 to llc_x+size_of_square) //Right
		for(var/y = llc_y to llc_y+size_of_square)
			if(prob(50))
				var/turf/T = locate(x,y,darkspace_abduction_z)
				T.density = FALSE
				T.opacity = FALSE
				T.vis_contents.Cut()

	for(var/x = llc_x to llc_x+size_of_square) //Top
		for(var/y = llc_y+size_of_square-1 to llc_y+size_of_square)
			if(prob(50))
				var/turf/T = locate(x,y,darkspace_abduction_z)
				T.density = FALSE
				T.opacity = FALSE
				T.vis_contents.Cut()

	for(var/x = llc_x to llc_x+size_of_square) //Bottom
		for(var/y = llc_y to llc_y+1)
			if(prob(50))
				var/turf/T = locate(x,y,darkspace_abduction_z)
				T.density = FALSE
				T.opacity = FALSE
				T.vis_contents.Cut()

	target.forceMove(locate(target.x,target.y,darkspace_abduction_z))
	to_chat(target,"<span class='danger'>The tug relaxes, but everything around you looks... slightly off.</span>")
	to_chat(user,"<span class='notice'>The mob has been moved. ([admin_jump_link(target,usr.client.holder)])</span>")

	target.transforming = FALSE
