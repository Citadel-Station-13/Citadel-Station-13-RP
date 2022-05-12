/obj/item/reagent_containers/blood/attack_self(mob/living/user as mob)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/human_user = user
		if(human_user.species.is_vampire)
			if(user.a_intent == INTENT_HARM)
				if(reagents.total_volume && volume)
					var/remove_volume = volume* 0.1 //10% of what the bloodpack can hold.
					var/reagent_to_remove = reagents.get_master_reagent_id()
					switch(reagents.get_master_reagent_id())
						if("blood")
							user.show_message("<span class='warning'>You sink your fangs into \the [src] and suck the blood out of it!</span>")
							user.visible_message("<font color='red'>[user] sinks their fangs into \the [src] and drains it!</font>")
							user.nutrition += remove_volume*4
							reagents.remove_reagent(reagent_to_remove, remove_volume)
							update_icon()
							if(!bitten_state)
								desc += "<font color='red'> It has two circular puncture marks in it.</font>"
								bitten_state = TRUE
							return
						else
							user.show_message("<span class='warning'>You take a look at \the [src] and notice that it is not filled with blood!</span>")
							return
				else
					user.show_message("<span class='warning'>You take a look at \the [src] and notice it has nothing in it!</span>")
					return
			else
				return

/obj/item/reagent_containers/blood/prelabeled
	name = "IV Pack"
	desc = "Holds liquids used for transfusion. This one's label seems to be hardprinted."

/obj/item/reagent_containers/blood/prelabeled/update_iv_label()
	return

/obj/item/reagent_containers/blood/prelabeled/APlus
	name = "IV Pack (A+)"
	desc = "Holds liquids used for transfusion. This one's label seems to be hardprinted. This one is labeled A+."
	blood_type = "A+"

/obj/item/reagent_containers/blood/prelabeled/AMinus
	name = "IV Pack (A-)"
	desc = "Holds liquids used for transfusion. This one's label seems to be hardprinted. This one is labeled A-."
	blood_type = "A-"

/obj/item/reagent_containers/blood/prelabeled/BPlus
	name = "IV Pack (B+)"
	desc = "Holds liquids used for transfusion. This one's label seems to be hardprinted. This one is labeled B+."
	blood_type = "B+"

/obj/item/reagent_containers/blood/prelabeled/BMinus
	name = "IV Pack (B-)"
	desc = "Holds liquids used for transfusion. This one's label seems to be hardprinted. This one is labeled B-."
	blood_type = "B-"

/obj/item/reagent_containers/blood/prelabeled/ABPlus
	name = "IV Pack (AB+)"
	desc = "Holds liquids used for transfusion. This one's label seems to be hardprinted. This one is labeled AB+."
	blood_type = "AB+"

/obj/item/reagent_containers/blood/prelabeled/ABMinus
	name = "IV Pack (AB-)"
	desc = "Holds liquids used for transfusion. This one's label seems to be hardprinted. This one is labeled AB-."
	blood_type = "AB-"

/obj/item/reagent_containers/blood/prelabeled/OPlus
	name = "IV Pack (O+)"
	desc = "Holds liquids used for transfusion. This one's label seems to be hardprinted. This one is labeled O+."
	blood_type = "O+"

/obj/item/reagent_containers/blood/prelabeled/OMinus
	name = "IV Pack (O-)"
	desc = "Holds liquids used for transfusion. This one's label seems to be hardprinted. This one is labeled O-."
	blood_type = "O-"
