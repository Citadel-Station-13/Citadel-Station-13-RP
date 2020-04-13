/obj/item/dice/throw_impact(atom/hit_atom)
	result = rand(1, sides)
	icon_state = "[name][result]"

	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "Nat 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."

	visible_message("<span class='notice'>The [src] lands on [result]. [comment]</span>", "", "")