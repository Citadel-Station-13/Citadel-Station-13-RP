/obj/machinery/smartfridge
	var/expert_job = "Chef"
/obj/machinery/smartfridge/seeds
	expert_job = "Botanist"
/obj/machinery/smartfridge/secure/extract
	expert_job = "Xenobiologist"
/obj/machinery/smartfridge/secure/medbay
	expert_job = "Chemist"
/obj/machinery/smartfridge/secure/virology
	expert_job = "Medical Doctor" //Virologist is an alt-title unfortunately
/obj/machinery/smartfridge/chemistry
	expert_job = "Chemist" //Unsure what this one is used for, actually
/obj/machinery/smartfridge/drinks
	expert_job = "Bartender"

// Allow thrown items into smartfridges
/obj/machinery/smartfridge/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	if(accept_check(AM) && TT.thrower)
		//Try to find what job they are via ID
		var/obj/item/card/id/thrower_id
		if(ismob(TT.thrower))
			var/mob/T = TT.thrower
			thrower_id = T.GetIdCard()

		//98% chance the expert makes it
		if(expert_job && thrower_id && thrower_id.rank == expert_job && prob(98))
			stock(AM)

		//20% chance a non-expert makes it
		else if(prob(20))
			stock(AM)
