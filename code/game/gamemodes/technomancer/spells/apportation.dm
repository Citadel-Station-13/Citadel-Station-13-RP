/datum/technomancer/spell/apportation
	name = "Apportation"
	desc = "This allows you to teleport objects into your hand, or to pull people towards you.  If they're close enough, the function \
	will grab them automatically."
	enhancement_desc = "Range is unlimited."
	cost = 25
	obj_path = /obj/item/spell/apportation
	category = UTILITY_SPELLS

/obj/item/spell/apportation
	name = "apportation"
	icon_state = "apportation"
	desc = "Allows you to reach through Bluespace with your hand, and grab something, bringing it to you instantly."
	cast_methods = CAST_RANGED
	aspect = ASPECT_TELE

/obj/item/spell/apportation/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom

		if(!AM.loc) //Don't teleport HUD telements to us.
			return
		if(AM.anchored)
			to_chat(user, "<span class='warning'>\The [hit_atom] is firmly secured and anchored, you can't move it!</span>")
			return

		if(!within_range(hit_atom) && !check_for_scepter())
			to_chat(user, "<span class='warning'>\The [hit_atom] is too far away.</span>")
			return

		//Teleporting an item.
		if(istype(hit_atom, /obj/item))
			var/obj/item/I = hit_atom

			var/datum/effect_system/spark_spread/s1 = new /datum/effect_system/spark_spread
			var/datum/effect_system/spark_spread/s2 = new /datum/effect_system/spark_spread
			s1.set_up(2, 1, user)
			s2.set_up(2, 1, I)
			s1.start()
			s2.start()
			I.visible_message("<span class='danger'>\The [I] vanishes into thin air!</span>")
			I.forceMove(get_turf(user))
			user.transfer_item_to_nullspace(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
			user.put_in_hands(I)
			user.visible_message("<span class='notice'>\A [I] appears in \the [user]'s hand!</span>")
			log_and_message_admins("has stolen [I] with [src].")
			qdel(src)
		//Now let's try to teleport a living mob.
		else if(istype(hit_atom, /mob/living))
			var/mob/living/L = hit_atom
			to_chat(L, "<span class='danger'>You are teleported towards \the [user].</span>")
			var/datum/effect_system/spark_spread/s1 = new /datum/effect_system/spark_spread
			var/datum/effect_system/spark_spread/s2 = new /datum/effect_system/spark_spread
			s1.set_up(2, 1, user)
			s2.set_up(2, 1, L)
			s1.start()
			s2.start()
			L.throw_at_old(get_step(get_turf(src),get_turf(L)), 4, 1, src)
			user.transfer_item_to_nullspace(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)

			spawn(1 SECOND)
				if(!user.Adjacent(L))
					to_chat(user, "<span class='warning'>\The [L] is out of your reach.</span>")
					qdel(src)
					return

				L.afflict_paralyze(20 * 3)
				user.visible_message("<span class='warning'><b>\The [user]</b> seizes [L]!</span>")

				var/obj/item/grab/G = new(user,L)

				user.put_in_hands(G)

				G.state = GRAB_PASSIVE
				G.icon_state = "grabbed1"
				qdel(src)

