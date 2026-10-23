
/obj/machinery/cryopod/ert_ship
	announce_channel = "Response Team"
	on_store_message = "has entered cryogenic storage."
	on_store_name = "NRV Von Braun Cryo"
	on_enter_visible_message = "starts climbing into the"
	on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	on_store_visible_message_1 = "hums and hisses as it moves"
	on_store_visible_message_2 = "into cryogenic storage."

//Misc Stuff
/obj/item/paper/ert_armory_cells
	name = "ERT Armory Cell Supply"
	info = {"To All Current ERT Members,<br>\
All energy weapons here come installed with standard power cells, but the spares on the racks are self-charging tech.<br>\
<br>\
Some fancy new micro-RTG cells or something, I think?<br>\
<br>\
Point is they're fairly expensive and probably prototypes or something, so for the love of God and your own career don't lose any of them and put them back when you return from a sortie.<br>\
<br>\
<i>Lt. Cmdr. Sykes</i>"}

/obj/item/paper/vonbraun_shields
	name = "NRV Von Braun Shield Configuration Documentation"
	info = {"To All Current ERT Members,<br>\
Be advised that use of the NRV Von Braun's shield generator (located adjacent to this document) is strongly recommended when responding to calls, but also that it is not impervious, nor is the ship's point defense system flawless.<br>\
<br>\
Recommended settings as follows:<br>\
Photonic: Off (PD will not work with it enabled!)<br>\
EM: On<br>\
Humanoids: Off<br>\
Atmospheric: Off<br>\
Hull Shield: On<br>\
Radius: 42<br>\
<br>\
The shield generator will tax the Von Braun's reserves greatly so try to use it sparingly. Do not be afraid to use it however, as the Von Braun represents the Company making a <i>significant</i> investment in this sector's future. I can bail you out if the occasional intern goes missing or you break something minor, but if you go flying this thing through an asteroid belt and get massive holes blown in it Central <b>will</b> make <u>everyone</u> involved disappear <b><u>permanently</b></u>.<br>\
<br>\
<i>Lt. Cmdr. Sykes</i>"}

/obj/machinery/computer/cryopod/ert
	name = "responder oversight console"
	desc = "An interface between responders and the cryo oversight systems tasked with keeping track of all responders who enter or exit cryostasis."
	circuit = "/obj/item/circuitboard/robotstoragecontrol"

	storage_type = "responders"
	storage_name = "ERT Oversight Control"
	allow_items = 1
