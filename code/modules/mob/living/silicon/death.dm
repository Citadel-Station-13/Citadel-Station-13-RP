/mob/living/silicon/death_via_gib()
	. = ..("gibbed-r")
	gibs(loc, null, /obj/effect/gibspawner/robot)

/mob/living/silicon/death_via_dust()
	return ..("dust-r", /obj/effect/decal/remains/robot)

/mob/living/silicon/death_via_ash()
	return ..("dust-r")

/mob/living/silicon/death(gibbed,deathmessage)
	if(in_contents_of(/obj/machinery/recharge_station))//exit the recharge station
		var/obj/machinery/recharge_station/RC = loc
		RC.go_out()
	return ..(gibbed,deathmessage)
