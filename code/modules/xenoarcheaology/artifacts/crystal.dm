/obj/structure/crystal
	name = "large crystal"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "crystal"
	density = TRUE

/obj/structure/crystal/Initialize(mapload)
	. = ..()
	icon_state = pick("ano70","ano80")
	desc = pick(
	"It shines faintly as it catches the light.",
	"It appears to have a faint inner glow.",
	"It seems to draw you inward as you look it at.",
	"Something twinkles faintly as you look at it.",
	"It's mesmerizing to behold.")

/obj/structure/crystal/Destroy()
	visible_message("<span class='danger'><b>[src] shatters!</b></span>")
	if(prob(75))
		new /obj/item/material/shard/phoron(loc)
	if(prob(50))
		new /obj/item/material/shard/phoron(loc)
	if(prob(25))
		new /obj/item/material/shard/phoron(loc)
	if(prob(75))
		new /obj/item/material/shard(loc)
	if(prob(50))
		new /obj/item/material/shard(loc)
	if(prob(25))
		new /obj/item/material/shard(loc)
	return ..()

//todo: laser_act
