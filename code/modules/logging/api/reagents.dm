//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/proc/log_chemical_reaction_instant(datum/reagent_holder/holder, datum/chemical_reaction/reaction, multiplier)
	log_reagent("H-[ref(holder)] REACTION: [holder.my_atom ? "[holder.my_atom] ([REF(holder.my_atom)])" : "!no-atom!"] [COORD(holder.my_atom)] - [reaction] @ [multiplier]")

/proc/log_chemical_reaction_ticked_start(datum/reagent_holder/holder, datum/chemical_reaction/reaction)
	log_reagent("H-[ref(holder)] REACTION-START: [holder.my_atom ? "[holder.my_atom] ([REF(holder.my_atom)])" : "!no-atom!"] [COORD(holder.my_atom)] - [reaction]")

/proc/log_chemical_reaction_ticked_end(datum/reagent_holder/holder, datum/chemical_reaction/reaction, list/blackboard)
	log_reagent("H-[ref(holder)] REACTION-END: [holder.my_atom ? "[holder.my_atom] ([REF(holder.my_atom)])" : "!no-atom!"] [COORD(holder.my_atom)] - [reaction] @ [json_encode(blackboard)]")
