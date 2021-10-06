/obj/item/dice/throw_impact(atom/hit_atom)
	if(!currently_throwing)
		return
	currently_throwing = FALSE
	result = rand(1, sides)
	icon_state = "[name][result]"

	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "Nat 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."

	visible_message("<span class='notice'>The [src] lands on [result]. [comment]</span>", "", "")
	
// snowflake patch
/obj/item/dice
	var/currently_throwing = FALSE

/obj/item/dice/throw_at()
	currently_throwing = TRUE
	return ..()
