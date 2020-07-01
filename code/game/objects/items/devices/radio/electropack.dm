/obj/item/radio/electropack
	name = "electropack"
	desc = "Dance my monkeys! DANCE!!!"
	icon_state = "electropack0"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_storage.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_storage.dmi',
			)
	item_state = "electropack"
	frequency = FREQ_ELECTROPACK
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_HUGE

	matter = list(DEFAULT_WALL_MATERIAL = 10000,"glass" = 2500)

	var/code = 2
	var/shock_cooldown = FALSE

///obj/item/electropack/suicide_act(mob/living/carbon/user)
//	user.visible_message("<span class='suicide'>[user] hooks [user.p_them()]self to the electropack and spams the trigger! It looks like [user.p_theyre()] trying to commit suicide!</span>")
//	return (FIRELOSS)

/obj/item/radio/electropack/Initialize()
	. = ..()
	set_frequency(frequency)

/obj/item/electropack/Destroy()
//	SSradio.remove_object(src, frequency)
	. = ..()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/radio/electropack/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.back)
			to_chat(user, "<span class='warning'>You need help taking this off!</span>")
			return
	return ..()

/obj/item/radio/electropack/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/clothing/head/helmet))
		if(!b_stat)
			to_chat(user, "<span class='notice'>[src] is not ready to be attached!</span>")
			return
		var/obj/item/assembly/shock_kit/A = new /obj/item/assembly/shock_kit( user )
		A.icon = 'icons/obj/assemblies.dmi'

		user.drop_from_inventory(W)
		W.loc = A
		W.master = A
		A.part1 = W

		user.drop_from_inventory(src)
		loc = A
		master = A
		A.part2 = src

		user.put_in_hands(A)
		A.add_fingerprint(user)

/obj/item/radio/electropack/Topic(href, href_list) //THE FUCK IS THIS ROUNDTYPE LOCKED???
	var/mob/living/carbon/C = usr
	if(usr.stat || usr.restrained() || C.back == src)
		return

	if(!in_range(src, usr)) //usr.canUseTopic(src, BE_CLOSE))
		usr << browse(null, "window=radio")
		onclose(usr, "radio")
		return

	if(href_list["set"])
		if(href_list["set"] == "freq")
			var/new_freq = input(usr, "Input a new receiving frequency", "Electropack Frequency", format_frequency(frequency)) as num|null
			if(!in_range(src, usr)) //!usr.canUseTopic(src, BE_CLOSE))
				return
			//new_freq = unformat_frequency(new_freq)
			new_freq = text2num(new_freq)
			new_freq *= 10 //basicaly same as that unformat func above!
			new_freq = sanitize_frequency(new_freq, MIN_FREE_FREQ, MAX_FREQ) //TRUE)
			set_frequency(new_freq)

		if(href_list["set"] == "code")
			var/new_code = input(usr, "Input a new receiving code", "Electropack Code", code) as num|null
			if(!in_range(src, usr)) //usr.canUseTopic(src, BE_CLOSE))
				return
			new_code = round(new_code)
			new_code = clamp(new_code, 1, 100)
			code = new_code

		if(href_list["set"] == "power")
			if(!in_range(src, usr)) //usr.canUseTopic(src, BE_CLOSE))
				return
			on = !(on)
			icon_state = "electropack[on]"

	if(usr) //update things
		attack_self(usr)
	return

/obj/item/radio/electropack/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption != code) //huh, signalers send code on enc rather than dat?
		return

	if(isliving(loc) && on)
		if(shock_cooldown == TRUE)
			return
		shock_cooldown = TRUE
		spawn(100)
			shock_cooldown = FALSE //there is no VSC yet
		//addtimer(VARSET_CALLBACK(src, shock_cooldown, FALSE), 100)
		var/mob/living/L = loc
		step(L, pick(GLOB.cardinal))
		to_chat(L, "<span class='danger'>You feel a sharp shock!</span>")
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, L)
		s.start()

		L.Weaken(10)

	if(master && (wires & 1))
		master.receive_signal()
	return

/obj/item/radio/electropack/attack_self(mob/user)
	if(!ishuman(user))
		return

	user.set_machine(src)
	var/dat = {"
<TT>
Turned [on ? "On" : "Off"] - <A href='?src=[REF(src)];set=power'>Toggle</A><BR>
<B>Frequency/Code</B> for electropack:<BR>
Frequency:
[format_frequency(src.frequency)]
<A href='byond://?src=[REF(src)];set=freq'>Set</A><BR>

Code:
[src.code]
<A href='byond://?src=[REF(src)];set=code'>Set</A><BR>
</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return
